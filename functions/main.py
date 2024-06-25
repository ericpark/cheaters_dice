from firebase_admin import initialize_app

from game.create_game import *
from game.update_game import *
from lobby.create_lobby import *
from presence.presence import *

app = initialize_app()
