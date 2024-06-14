import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_converter/firestore_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:game_repository/game_repository.dart';

part 'generated/game.g.dart';
part 'generated/game.firestore_converter.dart';
part 'generated/game.freezed.dart';

enum GameStatus { initial, loading, playing, transitioning, finished, failure }

@freezed
@FirestoreConverter(defaultPath: 'games')
class Game with _$Game {
  factory Game({
    String? hostId,
    String? lobbyId,
    String? id,
    @Default([]) List<String> order,
    @Default([]) List<String> tableOrder,
    @Default(0) int? totalDice, // Total Dice of all players
    @Default(0) int round,
    @Default(0) int turn,
    @Default(GameStatus.initial) GameStatus status,
    @DateTimeNullableConverter() DateTime? createdAt,
    @BidConverter() Bid? currentBid,
    String? winner, // Total Dice of all players
    @PlayersConverter() @Default({}) Map<String, Player> players,
    Map<String, dynamic>? lastAction,
  }) = _Game;

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);
}
