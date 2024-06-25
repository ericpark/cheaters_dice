import random
from firebase_functions import firestore_fn, https_fn, options

# The Firebase Admin SDK to access Cloud Firestore.
from firebase_admin import initialize_app, firestore
import google.cloud.firestore


# [START create_game]
@https_fn.on_call()
def create_game(req: https_fn.CallableRequest):
    if req.data is None: return

    try:
        lobby_id = req.data['lobby_id']

    except KeyError:
        # Invalid document, ignore it.
        return
    # Get the lobby id parameter from the request
    lobby_id = req.data['lobby_id']    
    order = req.data['players']
    random_start = random.randint(0, len(order) - 1)
    order = order[random_start:] + order[:random_start]
    try:
        # Generate a new game document id
        game_id = firestore.client().collection('games').document().id
        
        lobby_data = firestore.client().collection('lobbies').document(lobby_id).get().to_dict()
        
        # Create a new game document in the 'games' collection
        game_data = {
            'id': game_id,
            'lobby_id': lobby_id,
            'current_bid': {
                'number': 1,
                'player_id': None,
                'value': 1,
            },
            'host_id': req.data['host_id'],
            'round': 0,
            'turn': 0,
            'status': 'playing',
            'order': order,
            'table_order': req.data['players'],
            'players': dict( (player, {'id': player, 'photo': lobby_data['players'][player]['photo'], 'name': f"{lobby_data['players'][player]['first_name']} {lobby_data['players'][player]['last_name']}",  'dice': [{'id': '{player}_{num}'.format(player=player, num=d), 'value': random.randint(1, 6)} for d in range(req.data['starting_dice'])]} ) for player in req.data['players']),
            'total_dice': req.data['starting_dice'] * len(req.data['players']),
        }
        firestore.client().collection('games').document(game_id).set(game_data)
        firestore.client().collection('lobbies').document(lobby_id).update({'game_id': game_id,'status': 'playing'})
        return {'game_id': game_id}
    except Exception as e:
        firestore.client().collection('lobbies').document(lobby_id).update({'status': 'waiting'})
        return {'error': 'Failed to create game'}
