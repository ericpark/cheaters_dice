from firebase_functions import firestore_fn, https_fn

# The Firebase Admin SDK to access Cloud Firestore.
from firebase_admin import initialize_app, firestore
import google.cloud.firestore

app = initialize_app()
# [END import]



# [START update_game_from_action]
@firestore_fn.on_document_updated(document="games/{gameId}/actions/{actionId}")
def update_game_from_action(event: firestore_fn.Event[firestore_fn.DocumentSnapshot | None]) -> None:
    """Listens for new documents to be added to /games/{gameId}/actions/{actionId} and 
    updates the game in /games/{gameId} accordingly."""

    
    if event.data.after is None: 
        return
    try:
        created_at = event.data.after.get("created_at")
        processed = event.data.after.get("processed")
    except KeyError:
        # Invalid document, ignore it.
        return
    
    gameId = event.params["gameId"]
    firestore_client: google.cloud.firestore.Client = firestore.client()
    game_data = firestore_client.document(f"games/{gameId}").get().to_dict()

    last_action_data = _get_last_action(firestore_client, gameId)
    
    update_data = {}

    if last_action_data["action_type"] == "bid":
        update_data = _handle_bid_action(action_data=last_action_data,)

    if last_action_data["action_type"] == "challenge":
        update_data = _handle_challenge_action(action_data=last_action_data, game_data=game_data)

    if last_action_data["action_type"] == "spot":
        update_data = _handle_spot_on_action(action_data=last_action_data, game_data=game_data)

    is_in_progress = _check_game_in_progress(game_data=game_data)

    #Update the game in the database. This will push all the new state to the players.
    _update_game(firestore_client, gameId, update_data)


# [END update_game_from_action]
# [END all]

def _get_last_action(firestore_client: google.cloud.firestore.Client, gameId: str) -> dict:
    """TODO: Filter for last action that was processed and then filter out any actions that happened before that one.
    This is to ensure that we are only processing the next action in the sequence in race conditions. 
    
    EX: Processed at 8:01, then 8:02, should not process 8:00 afterwards. """


    query = firestore_client.collection(f"games/{gameId}/actions").where("processed", "==", False).order_by("created_at").limit_to_last(1)
    results = query.get()

    if results is None:
        return {"action_type": ""}
    
    return results[0].to_dict()

def _handle_bid_action(action_data: dict) -> dict | None:
    bid_update = {}
    bid_update["player_id"] = action_data["bid"]["player_id"]
    bid_update["number"] = action_data["bid"]["number"]
    bid_update["value"] = action_data["bid"]["value"]

    return {"current_bid": bid_update, "turn":action_data["turn"] + 1}

def _handle_challenge_action(action_data: dict, game_data: dict) -> dict | None:
    last_bid = game_data["current_bid"]
    players = game_data["players"]

    actual_dice_count = 0

    #calculate actual dice count
    filtered_dice = {}
    for player_id, player in players.items():
        filtered_dice[player_id] = [die for die in player["dice"] if die["value"] == 1 or die["value"] == last_bid["value"]]
        actual_dice_count += len(filtered_dice[player_id])
    

    challenger_is_correct = last_bid["number"] > actual_dice_count
    #if challenger is correct, remove dice from player
    if(challenger_is_correct):
        players[last_bid["player_id"]]["dice"] = players[last_bid["player_id"]]["dice"][:-1]
        if len(players[last_bid["player_id"]]["dice"]) == 0:
            game_data["order"].remove(last_bid["player_id"])
    #if challenger is incorrect, remove dice from challenger
    else:
        players[action_data["player_id"]]["dice"] = players[action_data["player_id"]]["dice"][:-1]
        if len(players[action_data["player_id"]]["dice"]) == 0:
            game_data["order"].remove(action_data["player_id"])

    #reset the game state
    return { "players": players, "round": action_data["round"] + 1, "turn":0, "current_bid": {"player_id": None, "number": 1, "value": 2} }

def _handle_spot_on_action(action_data: dict, game_data: dict) -> dict | None:
    last_bid = game_data["current_bid"]
    dice = game_data["dice"]
    actual_dice_count = 0

    #calculate actual dice count
    filtered_dice = {}
    for player_id, player_dice in dice.items():
        filtered_dice[player_id] = [die for die in player_dice if die["value"] == 1 or die["value"] == last_bid["value"]]
        actual_dice_count += len(filtered_dice[player_id])
    
    #must be exactly the same
    challenger_is_correct = last_bid["number"] == actual_dice_count
    #if challenger is correct, remove dice from player
    if(challenger_is_correct):
        dice[last_bid["player_id"]] = dice[last_bid["player_id"]][:-2]
    #if challenger is incorrect, remove dice from challenger
    else:
        dice[action_data["player_id"]] = dice[action_data["player_id"]][:-2]

    #reset the game state
    return {"dice":dice, "round": action_data["round"] + 1, "turn":0, "current_bid": {"player_id": None, "number": 1, "value": 2} }



def _check_game_in_progress(game_data: dict) -> bool:    
    #dice = game_data["order"]

    #Filter out any players without dice.
    #players_remaining = [players_dice for players_dice in dice if len(players_dice) > 0]
    
    #return len(players_remaining) > 1 #If there is more than one player remaining, the game is still in progress.
    return len(game_data["order"]) > 1

def _update_game(firestore_client: google.cloud.firestore.Client, gameId: str, update_data: dict):
    firestore_client.document(f"games/{gameId}").update(update_data)

