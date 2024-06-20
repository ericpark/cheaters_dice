part of 'game_bloc.dart';

enum BidPart { number, value }

enum BidUpdateType { increment, decrement }

@immutable
sealed class GameEvent {
  const GameEvent();
}

class GameStart extends GameEvent {
  const GameStart({required this.userId, required this.gameId});

  final String userId;
  final String gameId;
}

class GameLoad extends GameEvent {
  const GameLoad({required this.userId, required this.gameId});

  final String userId;
  final String gameId;
}

class GameStateUpdate extends GameEvent {
  const GameStateUpdate({required this.game});

  //final Bid updatedBid;
  final Game? game;
}

/// Round Start:
///
/// Responsible for Calculating players, total_dice,
class RoundStart extends GameEvent {
  const RoundStart({required this.game});
  final GameState game;
}

/// Rolled Dice
///
/// Marks completion of rolling dice animation.
class RolledDice extends GameEvent {}

/// Turn Start:
///
/// Responsible for calculating the new user bid
class ProcessTurnStart extends GameEvent {
  const ProcessTurnStart({required this.game});
  final GameState game;
}

class PlayerActionGameEvent extends GameEvent {}

class PlayerUpdateUserBidGameEvent extends GameEvent {
  const PlayerUpdateUserBidGameEvent({
    required this.bidPart,
    required this.bidType,
  });

  final BidPart bidPart;
  final BidUpdateType bidType;
}

class PlayerSubmitBidGameEvent extends GameEvent {
  const PlayerSubmitBidGameEvent();
}

class PlayerSubmitLiarGameEvent extends GameEvent {
  const PlayerSubmitLiarGameEvent();
}

class PlayerSubmitSpotOnGameEvent extends GameEvent {
  const PlayerSubmitSpotOnGameEvent();
}

class AnimationCompleted extends GameEvent {}

class TurnCompleted extends GameEvent {}

class RoundCompleted extends GameEvent {}

class GameCompleted extends GameEvent {}
