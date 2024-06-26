part of 'game_bloc.dart';

enum GameStatus {
  initial,
  loading,
  playing,
  transitioning,
  revealing,
  finished,
  failure,
}

extension GameStatusX on GameStatus {
  bool get isInitial => this == GameStatus.initial;
  bool get isLoading => this == GameStatus.loading;
  bool get isPlaying => this == GameStatus.playing;
  bool get isTransitioning => this == GameStatus.transitioning;
  bool get isFinished => this == GameStatus.finished;
  bool get isFailure => this == GameStatus.failure;
}

@freezed
abstract class GameState with _$GameState {
  factory GameState({
    @Default('') String? hostId, // Game Id
    @Default('') String? lobbyId,
    @Default('') String? id, // Game Id
    @Default(GameStatus.initial) GameStatus status,
    @Default(Bid()) Bid currentBid, // Last Accepted bid
    @Default(Bid()) Bid? userBid, // Bid by the current player
    @Default(Bid()) Bid? lastBid, // Bid used for comparison calculations
    @Default(0) int? totalDice, // Total Dice of all players
    @Default(0) int round,
    @Default(0) int turn,
    @Default([]) List<String> order, // Order of playerIds who are still playing
    @Default([]) List<String> tableOrder, //Order of all players
    //@Default({}) Map<String, List<Die>> dice, // Dice of each player
    String? winner, // Total Dice of all players
    @PlayersConverter() @Default({}) Map<String, Player> players,
    @Default('') String? currentUserId, // Current User Id
    Map<String, dynamic>? lastAction,
    bool? hasRolled,
    String? actionResult,
  }) = _GameState;

  factory GameState.initial() => _GameState();

  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);
}
