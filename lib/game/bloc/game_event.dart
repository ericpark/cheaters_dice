part of 'game_bloc.dart';

enum BidPart { number, value }

enum BidUpdateType { increment, decrement }

@immutable
sealed class GameEvent {
  const GameEvent();
}

class GameCreated extends GameEvent {
  const GameCreated({required this.userId, required this.gameId});

  final String userId;
  final String gameId;
}

class GameLoaded extends GameEvent {
  const GameLoaded({required this.userId, required this.gameId});

  final String userId;
  final String gameId;
}

class GameStateUpdated extends GameEvent {
  const GameStateUpdated({required this.game});

  //final Bid updatedBid;
  final Game? game;
}

/// Round Start:
///
/// Responsible for Calculating players, total_dice,
class RoundStarted extends GameEvent {
  const RoundStarted({required this.game});
  final GameState game;
}

/// Rolled Dice
///
/// Marks completion of rolling dice animation.
class DiceRollCompleted extends GameEvent {}

/// Turn Start:
///
/// Responsible for calculating the new user bid
class TurnProcessingStarted extends GameEvent {
  const TurnProcessingStarted({required this.game});
  final GameState game;
}

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

class PlayerActionSubmitted extends GameEvent {
  const PlayerActionSubmitted({required this.action});

  final PlayerActionType action;
}

class RoundAnimationsCompleted extends GameEvent {}

class TurnCompleted extends GameEvent {}

class RoundCompleted extends GameEvent {
  const RoundCompleted({required this.game, required this.nextState});
  final GameState game;
  final GameState nextState;
}

class GameCompleted extends GameEvent {}
