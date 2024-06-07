part of 'game_bloc.dart';

enum BidPart { number, value }

enum BidUpdateType { increment, decrement }

@immutable
sealed class GameEvent {
  const GameEvent();
}

class GameStart extends GameEvent {}

class GameStateUpdate extends GameEvent {
  const GameStateUpdate({required this.game});

  //final Bid updatedBid;
  final Game? game;
}

class RoundStart extends GameEvent {}

class TurnStart extends GameEvent {}

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

class TurnCompleted extends GameEvent {}

class RoundCompleted extends GameEvent {}

class GameCompleted extends GameEvent {}
