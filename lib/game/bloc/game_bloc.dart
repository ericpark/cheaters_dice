// ignore_for_file: flutter_style_todos, comment_references

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cheaters_dice/app/helpers/converters.dart';
import 'package:cheaters_dice/game/game.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:game_repository/game_repository.dart' as game_repository;

part 'game_event.dart';
part 'game_state.dart';
part 'generated/game_bloc.g.dart';
part 'generated/game_bloc.freezed.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  GameBloc({required GameRepository gameRepository})
      : _gameRepository = gameRepository,
        super(GameState.initial()) {
    //on<GameEvent>(_onGameEvent);
    on<GameCreated>(_onGameCreated);
    on<GameLoaded>(_onGameLoaded);
    on<GameStateUpdated>(_onGameUpdated);
    on<RoundStarted>(_onRoundStarted);
    on<DiceRollCompleted>(_onRolledDice);
    on<TurnProcessingStarted>(_onTurnProcessingStarted);
    on<PlayerActionSubmitted>(_onPlayerActionSubmitted);
    on<PlayerUpdateUserBidGameEvent>(_onPlayerUpdateBid);
    on<PlayerSubmitBidGameEvent>(_onPlayerSubmitBid);
    on<PlayerSubmitLiarGameEvent>(_onPlayerLiar);
    on<PlayerSubmitSpotOnGameEvent>(_onPlayerSpotOn);
    on<RoundAnimationsCompleted>(_onRoundAnimationsCompleted);
    on<TurnCompleted>(_onTurnComplete);
    on<RoundCompleted>(_onRoundCompleted);

    on<GameCompleted>(_onGameCompleted);
    on<GameReset>(_onGameReset);
  }

  final GameRepository _gameRepository;

  StreamSubscription<DocumentSnapshot<Game>>? _gameStream;

  void init(String userId, String gameId) {
    add(GameCreated(userId: userId, gameId: gameId));
    //add(RoundStart());
  }

  /// Used when creating the game by the host.
  FutureOr<void> _onGameCreated(
    GameCreated event,
    Emitter<GameState> emit,
  ) async {
    debugPrint('Game Created: ${event.gameId}');
    // Close any existing game streams
    await _gameStream?.cancel();

    //Initialize an empty Game with the current user and game Id
    emit(
      GameState.initial().copyWith(
        id: event.gameId,
        currentUserId: event.userId,
      ),
    );

    _gameStream = await _gameRepository.getGameStream(
      gameId: event.gameId,
      onData: (Game? game) {
        add(GameStateUpdated(game: game));
      },
    );

    // Wait for the game to load - this will be updated when the stream updates.
    emit(state.copyWith(status: GameStatus.loading));
  }

  /// Used when creating loading the game by the players
  FutureOr<void> _onGameLoaded(
    GameLoaded event,
    Emitter<GameState> emit,
  ) async {
    debugPrint('Game Loaded: ${event.gameId}');
    // Close any existing game streams
    await _gameStream?.cancel();

    //Initialize an empty Game with the current user and game Id
    _gameStream = await _gameRepository.getGameStream(
      gameId: event.gameId,
      onData: (Game? game) {
        add(GameStateUpdated(game: game));
      },
    );

    // Wait for the game to load - this will be updated when the stream updates.
    emit(
      GameState.initial().copyWith(
        id: event.gameId,
        currentUserId: event.userId,
        status: GameStatus.loading,
      ),
    );
  }

  FutureOr<void> _onGameUpdated(
    GameStateUpdated event,
    Emitter<GameState> emit,
  ) async {
    // Check if game is valid.
    if (event.game == null) return null;

    // Convert server game model to GameState and combine current GameState
    // values. copy over the currentUserId and hasRolled is copied over
    // so the user does not need to roll every turn.
    final serverGameState =
        GameState.fromJson(event.game?.toJson() ?? {}).copyWith(
      currentUserId: state.currentUserId,
      hasRolled: state.hasRolled,
    );

    // Loading State when game is created or loaded
    if (state.status == GameStatus.loading) {
      debugPrint('Game Loading Started');
      add(RoundStarted(game: serverGameState));
      // Might be necessary for the listener to pick up.
      //add(AnimationCompleted());
    } else if ((state.status == GameStatus.playing ||
            state.status == GameStatus.transitioning) &&
        serverGameState.status == GameStatus.playing &&
        state.turn != 0 &&
        serverGameState.turn == 0) {
      debugPrint('Game Round Completed: ${state.round}');

      // Prepare and trigger animations for the round completion.
      add(
        RoundCompleted(
          game: serverGameState.copyWith(players: state.players),
          nextState: serverGameState,
        ),
      );

      await Future<void>.delayed(const Duration(seconds: 5));
      await Future<void>.delayed(const Duration(seconds: 5));

      // Prepare for next round.
      add(RoundStarted(game: serverGameState));
      await Future<void>.delayed(const Duration(seconds: 5));

      // add(AnimationCompleted());
    }
    // Normal Turn ended
    else if ((state.status == GameStatus.playing ||
            state.status == GameStatus.transitioning) &&
        serverGameState.status == GameStatus.playing) {
      add(TurnProcessingStarted(game: serverGameState));
    }

    if (serverGameState.status == GameStatus.finished) {
      add(
        GameCompleted(
          game: serverGameState.copyWith(players: state.players),
          nextState: serverGameState,
        ),
      );
      await Future<void>.delayed(const Duration(seconds: 5));
      await Future<void>.delayed(const Duration(seconds: 5));

      emit(state.copyWith(players: serverGameState.players));
    }
  }

  FutureOr<void> _onRoundStarted(
    RoundStarted event,
    Emitter<GameState> emit,
  ) async {
    // Calculate the total dice
    final totalDice = calculateTotalDice(game: event.game);

    // Set the userBid to the currentBid if it's the first turn
    final userBid = event.game.currentBid == Bid.initial()
        ? Bid.minimum()
        : event.game.currentBid;

    // Changing the status to playing allows players to access the game.
    emit(
      event.game.copyWith(
        userBid: userBid,
        totalDice: totalDice,
        status: GameStatus.playing,
        hasRolled: false,
      ),
    );
  }

  /// Sets the game state to revealing to prevent users from interacting
  /// during the animations. [status] set to [GameStatus.revealing]
  /// triggers animations. Once animations are done, the round animations
  /// complete event is added.
  FutureOr<void> _onRoundCompleted(
    RoundCompleted event,
    Emitter<GameState> emit,
  ) {
    debugPrint('Game Round Completing');
    // Calculate the total dice
    final totalDice = calculateTotalDice(game: event.game);

    // Set the userBid to the currentBid if it's the first turn
    final userBid = event.game.currentBid == Bid.initial()
        ? Bid.minimum()
        : event.game.currentBid;
    // Set the lastBid to the current state's currentBid for comparison purposes
    final lastBid = state.currentBid;
    final losers = event.game.players.entries
        .where(
          (player) =>
              player.value.dice.length >
              event.nextState.players[player.key]!.dice.length,
        )
        .map((player) => player.value.name)
        .toList();

    final String? actionResult;
    if (event.game.lastAction?['type'] == 'challenge') {
      actionResult = '${losers[0]} LOSES 1 DIE';
    } else if (event.game.lastAction?['type'] == 'spot') {
      final challengerId = event.game.lastAction!['player_id'] as String;
      // Checking against the next state to see if the challenger lost dice
      // Can't check length because it could be 1v1
      if (event.game.players[challengerId]!.dice.length >
          event.nextState.players[challengerId]!.dice.length) {
        // Challenger loses dice
        actionResult = '${losers[0]} LOSES 2 DICE';
      } else {
        final challengerName = event.game.players[challengerId]!.name;
        actionResult = 'EVERYONE LOSES 1 DIE EXCEPT $challengerName';
      }
    } else {
      actionResult = null;
    }
    emit(
      event.game.copyWith(
        lastBid: lastBid,
        userBid: userBid,
        totalDice: totalDice,
        actionResult: actionResult,
        status: GameStatus.revealing,
      ),
    );
  }

  /// Sets the game state to transitioning to prevent users from interacting
  /// during the animations. [status] set to [GameStatus.transitioning]
  /// triggers animations. Once animations are done, the turn complete event is
  /// added.
  FutureOr<void> _onTurnProcessingStarted(
    TurnProcessingStarted event,
    Emitter<GameState> emit,
  ) {
    debugPrint('Turn Processing Started (BID, SKIP, REVERSE, ETC)');
    // Calculate the total dice
    final totalDice = calculateTotalDice(game: event.game);

    final userBid = event.game.currentBid == Bid.initial()
        ? Bid.minimum()
        : event.game.currentBid;

    emit(
      event.game.copyWith(
        userBid: userBid,
        totalDice: totalDice,
        status: GameStatus.transitioning,
      ),
    );
  }

  /// Event is added when the animations are completed and the game is ready
  /// This will allow users to interact with actions again.
  FutureOr<void> _onTurnComplete(event, Emitter<GameState> emit) async {
    debugPrint('Turn Animations Complete');
    emit(state.copyWith(status: GameStatus.playing, lastAction: null));
  }

  FutureOr<void> _onRoundAnimationsCompleted(
    event,
    Emitter<GameState> emit,
  ) async {
    emit(state.copyWith(status: GameStatus.playing));
  }

  FutureOr<void> _onPlayerUpdateBid(
    PlayerUpdateUserBidGameEvent event,
    Emitter<GameState> emit,
  ) {
    var userBid = state.userBid;
    if (event.bidType == BidUpdateType.increment &&
        event.bidPart == BidPart.number) {
      // ERROR: Cannot bid higher than total dice
      if (userBid!.number + 1 > state.totalDice!) return null;

      userBid = userBid.copyWith(number: userBid.number + 1);
    }
    if (event.bidType == BidUpdateType.decrement &&
        event.bidPart == BidPart.number) {
      // ERROR: Cannot bid lower than previous bid dice number
      if (userBid!.number - 1 < state.currentBid.number) return null;

      userBid = userBid.copyWith(number: userBid.number - 1);

      if (compareBids(userBid, state.currentBid) == -1) {
        userBid = state.currentBid;
      }
    }

    if (event.bidType == BidUpdateType.increment &&
        event.bidPart == BidPart.value) {
      userBid = incrementBidValue(bid: userBid!, totalDice: state.totalDice!);
    }

    if (event.bidType == BidUpdateType.decrement &&
        event.bidPart == BidPart.value) {
      userBid = decrementBidValue(bid: userBid!, currentBid: state.currentBid);
    }
    emit(state.copyWith(userBid: userBid));
  }

  FutureOr<void> _onPlayerSubmitBid(
    PlayerSubmitBidGameEvent event,
    Emitter<GameState> emit,
  ) async {
    final updatedBid = state.userBid!
        .copyWith(playerId: state.order[state.turn % state.order.length]);

    final newAction = game_repository.Action(
      actionType: game_repository.ActionType.bid,
      bid: game_repository.Bid.fromJson(
        updatedBid
            .copyWith(playerId: state.order[state.turn % state.order.length])
            .toJson(),
      ),
      playerId: state.order[state.turn % state.order.length],
      round: state.round,
      turn: state.turn,
      gameId: state.id!,
    );

    final success =
        await _gameRepository.addPlayerAction(playerAction: newAction);

    //Do not emit if there's an error.
    if (!success) return;

    //emit(state.copyWith(status: GameStatus.transitioning));
  }

  FutureOr<void> _onPlayerLiar(event, Emitter<GameState> emit) async {
    final newAction = game_repository.Action(
      actionType: game_repository.ActionType.challenge,
      playerId: state.order[state.turn % state.order.length],
      round: state.round,
      turn: state.turn,
      gameId: state.id!,
    );

    final success =
        await _gameRepository.addPlayerAction(playerAction: newAction);

    //Do not emit if there's an error.
    if (!success) return;

    //emit(state.copyWith(status: GameStatus.transitioning));
  }

  FutureOr<void> _onPlayerSpotOn(event, Emitter<GameState> emit) async {
    final newAction = game_repository.Action(
      actionType: game_repository.ActionType.spot,
      playerId: state.order[state.turn % state.order.length],
      round: state.round,
      turn: state.turn,
      gameId: state.id!,
    );

    final success =
        await _gameRepository.addPlayerAction(playerAction: newAction);

    //Do not emit if there's an error.
    if (!success) return;

    /*emit(
      state.copyWith(turn: 0, round: state.round + 1, userBid: Bid.minimum()),
    );*/
    //emit(state.copyWith(status: GameStatus.transitioning));
  }

  FutureOr<void> _onPlayerActionSubmitted(
    PlayerActionSubmitted event,
    Emitter<GameState> emit,
  ) async {
    game_repository.ActionType actionType;
    if (event.action == PlayerActionType.spot) {
      actionType = game_repository.ActionType.spot;
    } else if (event.action == PlayerActionType.skip) {
      actionType = game_repository.ActionType.skip;
    } else if (event.action == PlayerActionType.reverse) {
      actionType = game_repository.ActionType.reverse;
    } else {
      return;
    }

    final newAction = game_repository.Action(
      actionType: actionType,
      playerId: state.order[state.turn % state.order.length],
      round: state.round,
      turn: state.turn,
      gameId: state.id!,
    );

    final success =
        await _gameRepository.addPlayerAction(playerAction: newAction);

    //Do not emit if there's an error.
    if (!success) return;

    //emit(state.copyWith(status: GameStatus.transitioning));
  }

  /// Reset the game state to initial before going back to lobby
  FutureOr<void> _onGameCompleted(
    GameCompleted event,
    Emitter<GameState> emit,
  ) async {
    debugPrint('Game Round Completing');
    // Calculate the total dice
    //final totalDice = calculateTotalDice(game: event.game);

    // Set the userBid to the currentBid if it's the first turn
    final userBid = event.game.currentBid == Bid.initial()
        ? Bid.minimum()
        : event.game.currentBid;
    // Set the lastBid to the current state's currentBid for comparison purposes
    final lastBid = state.currentBid;
    final losers = event.game.players.entries
        .where(
          (player) =>
              player.value.dice.length >
              event.nextState.players[player.key]!.dice.length,
        )
        .map((player) => player.value.name)
        .toList();

    final String? actionResult;
    if (event.game.lastAction?['type'] == 'challenge') {
      actionResult = '${losers[0]} LOSES 1 DIE';
    } else if (event.game.lastAction?['type'] == 'spot') {
      final challengerId = event.game.lastAction!['player_id'] as String;
      // Checking against the next state to see if the challenger lost dice
      // Can't check length because it could be 1v1
      if (event.game.players[challengerId]!.dice.length >
          event.nextState.players[challengerId]!.dice.length) {
        // Challenger loses dice
        actionResult = '${losers[0]} LOSES 2 DICE';
      } else {
        final challengerName = event.game.players[challengerId]!.name;
        actionResult = 'EVERYONE LOSES 1 DIE EXCEPT $challengerName';
      }
    } else {
      actionResult = null;
    }
    emit(
      event.game.copyWith(
        lastBid: lastBid,
        userBid: userBid,
        //totalDice: totalDice,
        actionResult: actionResult,
        status: GameStatus.finished,
      ),
    );
  }

  /// Reset the game state to initial before going back to lobby
  FutureOr<void> _onGameReset(event, Emitter<GameState> emit) async {
    emit(GameState.initial());
  }

  bool canIncrementBidValue() {
    // ERROR: Cannot bid higher than total dice
    if (state.userBid!.value == 6 && state.userBid!.number == state.totalDice) {
      return false;
    }
    return true;
  }

  bool canDecrementBidValue() {
    // ERROR: Cannot bid lower than previous bid. CurrentBid is the lowest
    if (state.userBid == state.currentBid) return false;
    // Check if first default bid
    if (state.userBid == Bid.minimum()) return false;

    if (compareBids(state.userBid!, state.currentBid) != 1) return false;

    return true;
  }

  int compareBids(Bid bid1, Bid bid2) {
    if (bid1.number > bid2.number) {
      return 1;
    } else if (bid1.number < bid2.number) {
      return -1;
    } else {
      if (bid1.value > bid2.value) {
        return 1;
      } else if (bid1.value < bid2.value) {
        return -1;
      } else {
        return 0;
      }
    }
  }

  Bid incrementBidValue({required Bid bid, required int totalDice}) {
    if (!canIncrementBidValue()) return bid;

    // Value of 6 is max so incrementing will reset to 2 and increment number
    if (bid.value == 6 && bid.number <= totalDice) {
      return Bid(number: bid.number + 1, value: 2);
    }

    return bid.copyWith(value: bid.value + 1);
  }

  Bid decrementBidValue({required Bid bid, required Bid currentBid}) {
    if (!canDecrementBidValue()) return bid;
    var lowerBid = bid.copyWith(value: bid.value - 1);
    if (lowerBid.value == 1) {
      lowerBid = lowerBid.copyWith(value: 6, number: lowerBid.number - 1);
    }
    if (lowerBid == currentBid) return currentBid;

    return lowerBid;
  }

  List<Player> get playerOrder {
    if (state.order.isEmpty) return [];
    if (state.currentUserId == null) return [];

    final index = state.tableOrder.indexOf(state.currentUserId!);

    final order = state.tableOrder.sublist(index + 1)
      ..addAll(state.tableOrder.sublist(0, index));

    final players = order.map((playerId) => state.players[playerId]!).toList();

    return players;
  }

  int calculateTotalDice({required GameState game}) {
    // Put players in a List in tableOrder
    final players =
        game.tableOrder.map((playerId) => game.players[playerId]!).toList();

    // Calculate the total dice
    final totalDice =
        players.fold<int>(0, (prev, player) => prev + player.dice.length);

    return totalDice;
  }

  FutureOr<void> _onRolledDice(event, Emitter<GameState> emit) async {
    emit(state.copyWith(hasRolled: true));
  }
}
