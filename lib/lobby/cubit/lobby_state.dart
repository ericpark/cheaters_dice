part of 'lobby_cubit.dart';

enum LobbyStatus { initial, waiting, loading, playing, completed, failure }

extension LobbyStatusX on LobbyStatus {
  bool get isInitial => this == LobbyStatus.initial;
  bool get isWaiting => this == LobbyStatus.waiting;
  bool get isLoading => this == LobbyStatus.loading;
  bool get isPlaying => this == LobbyStatus.playing;
  bool get isCompleted => this == LobbyStatus.completed;
  bool get isFailure => this == LobbyStatus.failure;
}

@freezed
abstract class LobbyState with _$LobbyState {
  factory LobbyState({
    @Default(LobbyStatus.initial) LobbyStatus status,
    @Default([]) List<Lobby> availableLobbies,
    @Default('') String joinedLobbyId,
    Lobby? joinedLobby,
  }) = _LobbyState;

  factory LobbyState.initial() => _LobbyState();

  factory LobbyState.fromJson(Map<String, dynamic> json) =>
      _$LobbyStateFromJson(json);
}
