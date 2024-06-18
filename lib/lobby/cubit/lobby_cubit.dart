import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cheaters_dice/lobby/lobby.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lobby_repository/lobby_repository.dart' as lobby_repository;

part 'generated/lobby_cubit.freezed.dart';
part 'generated/lobby_cubit.g.dart';
part 'lobby_state.dart';

class LobbyCubit extends Cubit<LobbyState> {
  LobbyCubit({required lobby_repository.LobbyRepository lobbyRepository})
      : _lobbyRepository = lobbyRepository,
        super(LobbyState.initial());

  final lobby_repository.LobbyRepository _lobbyRepository;
  StreamSubscription<DocumentSnapshot<lobby_repository.Lobby>>? _lobbyStream;

  void init() {
    emit(
      state.copyWith(
        availableLobbies: [
          Lobby(
            id: 'j2n4DG1ldWmUwRcmqSKZ',
            name: 'Lobby 1',
            players: {},
          ),
          Lobby(
            id: 'OoYiN0d1AEzhWy7CYqUV',
            name: 'Lobby 2',
            players: {},
          ),
        ],
      ),
    );
  }

  Future<Lobby?> joinLobby(String lobbyId) async {
    final joinedLobby = Lobby.fromJson(
      (await _lobbyRepository.getLobbyById(lobbyId: lobbyId))!.toJson(),
    );
    await _lobbyStream?.cancel();

    _lobbyStream = await _lobbyRepository.getLobbyStream(
      lobbyId: lobbyId,
      onData: (lobby) async {
        if (lobby != null) {
          final lobbyStream = Lobby.fromJson(lobby.toJson());

          emit(
            state.copyWith(
              joinedLobby: lobbyStream,
              joinedLobbyId: lobbyId,
              status: joinedLobby.status,
            ),
          );
        }
      },
    );
    emit(
      state.copyWith(
        joinedLobbyId: lobbyId,
        joinedLobby: joinedLobby,
        status: joinedLobby.status,
      ),
    );
    return joinedLobby;
  }

  Future<String> startGame(
    String lobbyId,
    String hostId,
    List<String> players,
  ) async {
    await _lobbyRepository
        .updateLobbyById(lobbyId: lobbyId, data: {'status': 'loading'});
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
