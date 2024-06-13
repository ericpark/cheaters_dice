import random
from firebase_functions import firestore_fn, https_fn, options

# The Firebase Admin SDK to access Cloud Firestore.
from firebase_admin import initialize_app, firestore
import google.cloud.firestore


# [START create_game]
@https_fn.on_request(   
        cors=options.CorsOptions(
        cors_origins=[r"*"],
        cors_methods=["get", "post"],
    ))
def create_game(event: firestore_fn.Event[firestore_fn.DocumentSnapshot | None]) -> None:
    if event.data is None: return

    try:
        lobby_id = event.data.get('lobby_id')

    except KeyError:
        # Invalid document, ignore it.
        return
    # Get the lobby id parameter from the request
    lobby_id = event.data.get('lobby_id')

    # Generate a new game document id
    game_id = firestore.client().collection('games').document().id

    # Create a new game document in the 'games' collection
    game_data = {
        'id': game_id,
        # Add any other game data you want to include
    }
    firestore.client().collection('games').document(game_id).set(game_data)