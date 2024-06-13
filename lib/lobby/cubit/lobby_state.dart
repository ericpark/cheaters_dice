part of 'lobby_cubit.dart';

enum LobbyStatus { initial, waiting, playing, completed, failure }

extension LobbyStatusX on LobbyStatus {
  bool get isInitial => this == LobbyStatus.initial;
  bool get isWaiting => this == LobbyStatus.waiting;
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
  }) = _LobbyState;

  factory LobbyState.initial() => _LobbyState();

  factory LobbyState.fromJson(Map<String, dynamic> json) =>
      _$LobbyStateFromJson(json);
}
