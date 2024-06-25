from firebase_functions import db_fn, https_fn
import datetime

# The Firebase Admin SDK to access Cloud Firestore.
from firebase_admin import firestore, db
import google.cloud.firestore

# Presence should always be updated first THEN lobby information.
@db_fn.on_value_updated(reference="/{user_id}/online")
def update_presence(event: db_fn.Event[db_fn.Change]) -> None:

    if event.data.after is not None:
        online_status = event.data.after

        user_db_ref = db.reference(event.reference).parent

        user_db_ref.child('online').set(online_status)
        user_db_ref.child('last_seen').set(datetime.datetime.now().strftime('%s'))
        

        if user_db_ref is not None:
            # if user is now offline and the user is in a lobby, remove the user from the lobby
            if(user_db_ref.child('lobby_id').get() is not None and online_status == False):
                user_db_ref.child('lobby_id').delete()
                return

@db_fn.on_value_created(reference="/{user_id}/lobby_id")
def add_user_to_lobby(event: db_fn.Event[str]) -> None:
    # lobby id existed and now it doesn't meaning the user left the lobby

    if event.data is not None:
        joined_lobby_id = event.data
        user_id = event.params['user_id']

        # Generate a new lobby document id
        # Create a new lobby document in the 'lobbies' collection
        lobby_ref =  firestore.client().collection('lobbies').document(joined_lobby_id)
        lobby_data = lobby_ref.get().to_dict()
        if lobby_data['players'] is not None:
            user_data = firestore.client().collection('users').document(user_id).get().to_dict()

            lobby_data['players'][user_id] =  user_data
        else:
            lobby_data['players'][user_id] = user_data
        
        lobby_ref.update({'players': lobby_data['players']})

    return 

@db_fn.on_value_deleted(reference="/{user_id}/lobby_id")
def remove_user_from_lobby(event: db_fn.Event[str]) -> None:
    # lobby id existed and now it doesn't meaning the user left the lobby
    if event.data is not None:
        previous_lobby_id = event.data
        user_id = event.params['user_id']

        # Generate a new lobby document id
        # Create a new lobby document in the 'lobbies' collection
        lobby_ref =  firestore.client().collection('lobbies').document(previous_lobby_id)
        lobby_data = lobby_ref.get().to_dict()
        if lobby_data['players'] is not None:
            lobby_data['players'].pop(user_id, None)
            lobby_ref.update({'players': lobby_data['players']})
    
    return 
