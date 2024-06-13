import 'package:bloc/bloc.dart';
import 'package:cheaters_dice/lobby/lobby.dart';
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
}
