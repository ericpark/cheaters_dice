import random
from firebase_functions import firestore_fn, https_fn

# The Firebase Admin SDK to access Cloud Firestore.
from firebase_admin import initialize_app, firestore
import google.cloud.firestore


from game.create_game import *
from game.update_game import *
from lobby.create_lobby import *

app = initialize_app()
# [END import]
