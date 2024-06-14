import 'package:bloc/bloc.dart';
import 'package:cheaters_dice/lobby/lobby.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/lobby_cubit.freezed.dart';
part 'generated/lobby_cubit.g.dart';
part 'lobby_state.dart';

class LobbyCubit extends Cubit<LobbyState> {
  LobbyCubit() : super(LobbyState.initial());

  void init() {
    emit(
      state.copyWith(
        availableLobbies: [
          Lobby(
            id: 'j2n4DG1ldWmUwRcmqSKZ',
            name: 'Lobby 1',
            players: 2,
          ),
          Lobby(
            id: '46hOQ2pQ26C4aIx6iAWF',
            name: 'Lobby 2',
            players: 3,
          ),
        ],
      ),
    );
  }

  void joinLobby(String lobbyId) {
    emit(state.copyWith(joinedLobbyId: lobbyId));
  }

  Future<String> createGame(
    String lobbyId,
    String hostId,
    List<String> players,
  ) async {
    final callable = FirebaseFunctions.instance.httpsCallable(
      'create_game',
      options: HttpsCallableOptions(
        timeout: const Duration(seconds: 5),
      ),
    );
    final result = await callable.call<Map<String, dynamic>>({
      'lobby_id': lobbyId,
      'players': players,
      'host_id': hostId,
      'starting_dice': 3,
    });
    final gameId = result.data;
    return gameId['game_id'] as String;
  }
}
