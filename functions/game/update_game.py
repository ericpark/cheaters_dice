import random
from firebase_functions import firestore_fn, https_fn

# The Firebase Admin SDK to access Cloud Firestore.
from firebase_admin import initialize_app, firestore
import google.cloud.firestore

# [START update_game_from_action]
@firestore_fn.on_document_created(document="games/{gameId}/actions/{actionId}")
def update_game_from_action(event: firestore_fn.Event[firestore_fn.DocumentSnapshot | None]) -> None:
    """Listens for new documents to be added to /games/{gameId}/actions/{actionId} and 
    updates the game in /games/{gameId} accordingly."""
    
    if event.data is None: return

    try:
        created_at = event.data.get("created_at")
        processed = event.data.get("processed")
    except KeyError:
        # Invalid document, ignore it.
        return
    
    game_id = event.params["gameId"]
    firestore_client: google.cloud.firestore.Client = firestore.client()
    game_data = firestore_client.document(f"games/{game_id}").get().to_dict()

    last_action_data = _get_last_action(firestore_client, game_id)
    
    update_data = {}

    if last_action_data["action_type"] == "bid":
        update_data = _handle_bid_action(action_data=last_action_data,)
        update_data["order"] = game_data["order"]

    if last_action_data["action_type"] == "challenge":
        update_data = _handle_challenge_action(action_data=last_action_data, game_data=game_data, firestore_client=firestore_client)
        update_data["players"] = _rerollAllPlayersDice(players=update_data["players"])

    if last_action_data["action_type"] == "spot":
        update_data = _handle_spot_on_action(action_data=last_action_data, game_data=game_data, firestore_client=firestore_client)
        update_data["players"] = _rerollAllPlayersDice(players=update_data["players"])

    #TODO: Optional flag to shuffle between rounds?
    #shuffle_between_rounds = game_data.get("shuffle_between_rounds", False)
    #if shuffle_between_rounds: update_data["order"] = _shuffle_order(game_data)

    is_finished = _check_game_is_finished(game_data=update_data)
    if is_finished: 
        update_data["status"] = "finished"
    if is_finished: 
        update_data["winner"] = update_data["order"][0]

    update_data["last_action"] = {"id": last_action_data["id"], "type": last_action_data["action_type"]}
    #Update the game in the database. This will push all the new state to the players.
    _update_game(firestore_client, game_id, update_data)
    _update_action(firestore_client, last_action_data, {"processed": True})
# [END update_game_from_action]


# [START _handle_bid_action]
def _handle_bid_action(action_data: dict) -> dict | None:
    bid_update = {}
    bid_update["player_id"] = action_data["bid"]["player_id"]
    bid_update["number"] = action_data["bid"]["number"]
    bid_update["value"] = action_data["bid"]["value"]

    return {"current_bid": bid_update, "turn":action_data["turn"] + 1}
# [END _handle_bid_action]


# [START _actual_dice_count]
def _handle_challenge_action(action_data: dict, game_data: dict, firestore_client: google.cloud.firestore.Client) -> dict | None:
    last_bid = game_data["current_bid"]
    players = game_data["players"]

    #calculate actual dice count
    actual_dice_count = _actual_dice_count(players=players, bid_value=last_bid["value"])

    challenger_is_correct = last_bid["number"] > actual_dice_count
    round_results = {}
    #if challenger is correct, remove dice from player
    if(challenger_is_correct):
        players[last_bid["player_id"]]["dice"] = players[last_bid["player_id"]]["dice"][:-1]
        game_data["players"][last_bid["player_id"]]["dice"] = players[last_bid["player_id"]]["dice"]
        if len(players[last_bid["player_id"]]["dice"]) == 0:
            game_data["order"].remove(last_bid["player_id"])
            #round_results["lost"] = [last_bid["player_id"]]

    #if challenger is incorrect, remove dice from challenger
    else:
        players[action_data["player_id"]]["dice"] = players[action_data["player_id"]]["dice"][:-1]
        game_data["players"][action_data["player_id"]]["dice"] = players[action_data["player_id"]]["dice"]
        if len(players[action_data["player_id"]]["dice"]) == 0:
            game_data["order"].remove(action_data["player_id"])
            #round_results["lost"] = [action_data["player_id"]]

    #calculate the new remaining dice count
    game_data["total_dice"] = sum([len(player["dice"]) for player in players.values()])

    #Save the game state as a round record
    _save_game_as_round(firestore_client=firestore_client, game_id=action_data["game_id"], game_data=game_data, round_results=round_results)

    #reset the game state
    return { "players": players, "round": action_data["round"] + 1, "turn":0, "current_bid": {"player_id": None, "number": 1, "value": 1}, "order": game_data["order"], "total_dice": game_data["total_dice"]}
# [END _actual_dice_count]


# [START _handle_spot_on_action]
def _handle_spot_on_action(action_data: dict, game_data: dict, firestore_client: google.cloud.firestore.Client) -> dict | None:
    last_bid = game_data["current_bid"]
    players = game_data["players"]

    #calculate actual dice count
    actual_dice_count = _actual_dice_count(players=players, bid_value=last_bid["value"])

    challenger_is_correct = last_bid["number"] == actual_dice_count
    round_results = {}
    #if challenger is correct, remove dice from all players
    if(challenger_is_correct):
        for player_id, player in players.items():
            if(player_id == action_data["player_id"]): 
                continue
            players[player_id]["dice"] = player["dice"][:-1]
            game_data["players"][player_id]["dice"] = players[player_id]["dice"] 
            if len(players[player_id]["dice"]) == 0:
                game_data["order"].remove(last_bid["player_id"])
    #if challenger is incorrect, remove two dice from challenger
    else:
        players[action_data["player_id"]]["dice"] = players[action_data["player_id"]]["dice"][:-2]
        game_data["players"][action_data["player_id"]]["dice"] = players[action_data["player_id"]]["dice"]
        if len(players[action_data["player_id"]]["dice"]) == 0:
            game_data["order"].remove(action_data["player_id"])

    #calculate the new remaining dice count
    game_data["total_dice"] = sum([len(player["dice"]) for player in players.values()])

    #Save the game state as a round record
    _save_game_as_round(firestore_client=firestore_client, game_id=action_data["game_id"], game_data=game_data, round_results=round_results)

    #reset the game state
    return { "players": players, "round": action_data["round"] + 1, "turn":0, "current_bid": {"player_id": None, "number": 1, "value": 1}, "order": game_data["order"], "total_dice": game_data["total_dice"]}
# [END _handle_spot_on_action]


############################################################################################################
############################################################################################################

# [START _get_last_action]
def _get_last_action(firestore_client: google.cloud.firestore.Client, game_id: str) -> dict:
    """TODO: Filter for last action that was processed and then filter out any actions that happened before that one.
    This is to ensure that we are only processing the next action in the sequence in race conditions. 
    
    EX: Processed at 8:01, then 8:02, should not process 8:00 afterwards. """


    query = firestore_client.collection(f"games/{game_id}/actions").where("processed", "==", False).order_by("created_at").limit_to_last(1)
    results = query.get()

    if results is None:
        return {"action_type": ""}
    
    return results[0].to_dict()
# [END _get_last_action]


# [START _actual_dice_count]
def _actual_dice_count(players: dict, bid_value: int) -> int:
    actual_dice_count = 0

    # Each player has a list of dice. Filter out the dice that are not the bid value or 1.
    for player_id, player in players.items():
        filtered_dice = [die for die in player["dice"] if die["value"] == 1 or die["value"] == bid_value]
        actual_dice_count += len(filtered_dice)

    return actual_dice_count
# [END _actual_dice_count]


# [START _rerollAllPlayersDice]
def _rerollAllPlayersDice(players: dict) -> dict:
    # Reroll all remaining dice
    for player_id, player in players.items():
        players[player_id]["dice"] = [{"id": die["id"], "value": random.randint(1, 6)} for die in player["dice"]]

    return players
# [END _rerollAllPlayersDice]


# [START _check_game_is_finished]
def _check_game_is_finished(game_data: dict) -> bool:    
    # When dice are removed, the order will be updated. If there is only one player left, the game is over.
    return len(game_data["order"]) <= 1
# [END _check_game_is_finished]


# [START _update_game]
def _update_game(firestore_client: google.cloud.firestore.Client, game_id: str, update_data: dict):
    firestore_client.document(f"games/{game_id}").update(update_data)
# [END _update_game]


# [START _update_action]
def _update_action(firestore_client: google.cloud.firestore.Client, action_data: dict, update_data: dict):
    firestore_client.document(f"games/{action_data["game_id"]}/actions/{action_data["id"]}").update(update_data)
# [END _update_action]


# [START _save_game_as_round]
def _save_game_as_round(firestore_client: google.cloud.firestore.Client, game_id: str, game_data: dict, round_results: dict):
    game_data["results"] = round_results
    firestore_client.collection(f"games/{game_id}/rounds").add(game_data)
# [END _save_game_as_round]

# [END all]