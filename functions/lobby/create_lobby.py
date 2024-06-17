import random
from firebase_functions import firestore_fn, https_fn, options

# The Firebase Admin SDK to access Cloud Firestore.
from firebase_admin import initialize_app, firestore
import google.cloud.firestore


# [START create_lobby]
@https_fn.on_call()
def create_lobby(req: https_fn.CallableRequest):
    if req.data is None: return

    try:
        host_id = req.data['host_id']

    except KeyError:
        # Invalid document, ignore it.
        return
    # Get the host id parameter from the request
    host_id = req.data['host_id']


    # Generate a new lobby document id
    # Create a new lobby document in the 'lobbies' collection
    lobby_id = firestore.client().collection('lobbies').document().id

    lobby_data = {
        'id': lobby_id,
        'host_id': host_id,
        'players': [{'id':host_id}],
        'settings': {'starting_dice': 3},
        'status': 'initial',
    }
    firestore.client().collection('lobbies').document(lobby_id).set(lobby_data)

    return {'lobby_id':lobby_id }
# [END create_lobby]