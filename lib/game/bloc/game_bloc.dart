// ignore_for_file: flutter_style_todos

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
    on<GameStart>(_onGameStart);
    on<GameStateUpdate>(_onGameUpdate);
    on<RoundStart>(_onRoundStart);
    on<ProcessTurnStart>(_onProcessTurnStart);
    on<PlayerActionGameEvent>(_onPlayerAction);
    on<PlayerUpdateUserBidGameEvent>(_onPlayerUpdateBid);
    on<PlayerSubmitBidGameEvent>(_onPlayerSubmitBid);
    on<PlayerSubmitLiarGameEvent>(_onPlayerLiar);
    on<PlayerSubmitSpotOnGameEvent>(_onPlayerSpotOn);
    on<AnimationCompleted>(_onAnimationCompleted);
    on<TurnCompleted>(_onTurnComplete);
    on<GameCompleted>(_onGameComplete);
  }

  final GameRepository _gameRepository;

  StreamSubscription<DocumentSnapshot<Game>>? _gameStream;

  void init(String userId, String gameId) {
    add(GameStart(userId: userId, gameId: gameId));
    //add(RoundStart());
  }

  FutureOr<void> _onGameStart(GameStart event, Emitter<GameState> emit) async {
    debugPrint('Game Start: ${event.gameId}');
    // Close any existing game streams
    await _gameStream?.cancel();

    // Initialize a new game with the host as first player.
    emit(
      GameState.initial()
          .copyWith(id: event.gameId, currentUserId: event.userId),
    );

    _gameStream = await _gameRepository.getGameStream(
      gameId: event.gameId,
      onData: (Game? game) {
        add(GameStateUpdate(game: game));
      },
    );

    // Wait for the game to load
    emit(state.copyWith(status: GameStatus.loading));
  }

  /// Load Games for other players besides the host.
  FutureOr<void> _onGameLoad(GameStart event, Emitter<GameState> emit) async {
    debugPrint('Game Load: ${event.gameId}');
    // Close any existing game streams
    await _gameStream?.cancel();

    // Wait for the game to load
    emit(state.copyWith(status: GameStatus.loading));

    _gameStream = await _gameRepository.getGameStream(
      gameId: event.gameId,
      onData: (Game? game) {
        add(GameStateUpdate(game: game));
      },
    );
  }

  FutureOr<void> _onGameUpdate(
    GameStateUpdate event,
    Emitter<GameState> emit,
  ) async {
    if (event.game == null) return null;

    final serverGameState = GameState.fromJson(event.game?.toJson() ?? {})
        .copyWith(currentUserId: state.currentUserId);

    if (state.status == GameStatus.loading) {
      add(RoundStart(game: serverGameState));

      //await Future<void>.delayed(const Duration(seconds: 5));

      add(AnimationCompleted());
    }

    if (state.status == GameStatus.playing) {
      // Make transition
      add(ProcessTurnStart(game: serverGameState));
    }

    if (serverGameState.status == GameStatus.finished) {
      await Future<void>.delayed(const Duration(seconds: 5));

      emit(serverGameState.copyWith(status: GameStatus.finished));
    }
  }

  FutureOr<void> _onProcessTurnStart(
    ProcessTurnStart event,
    Emitter<GameState> emit,
  ) {
    final players = event.game.tableOrder
        .map((playerId) => event.game.players[playerId]!)
        .toList();
    final totalDice = players.fold<int>(
      0,
      (previousValue, player) => previousValue + player.dice.length,
    );
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

  FutureOr<void> _onRoundStart(RoundStart event, Emitter<GameState> emit) {
    final players = event.game.tableOrder
        .map((playerId) => event.game.players[playerId]!)
        .toList();
    final totalDice = players.fold<int>(
      0,
      (previousValue, player) => previousValue + player.dice.length,
    );
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

  FutureOr<void> _onPlayerAction(event, Emitter<GameState> emit) {
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

    emit(
      state.copyWith(
        currentBid: updatedBid,
        userBid: updatedBid,
        turn: state.turn + 1,
      ),
    );
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

    /*emit(
      state.copyWith(turn: 0, round: state.round + 1, userBid: Bid.minimum()),
    );*/
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
  }

  FutureOr<void> _onTurnComplete(event, Emitter<GameState> emit) async {
    emit(state.copyWith(status: GameStatus.playing, lastAction: null));
  }

  FutureOr<void> _onAnimationCompleted(event, Emitter<GameState> emit) async {
    emit(state.copyWith(status: GameStatus.playing));
  }

  /// Reset the game state to initial before going back to lobby
  FutureOr<void> _onGameComplete(event, Emitter<GameState> emit) async {
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
}
