import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_converter/firestore_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:game_repository/game_repository.dart';

part 'generated/action.g.dart';
part 'generated/action.firestore_converter.dart';
part 'generated/action.freezed.dart';

enum ActionType { bid, challenge, spot }

@freezed
@FirestoreConverter(defaultPath: 'actions')
abstract class Action with _$Action {
  const factory Action({
    required ActionType actionType,
    required String playerId,
    required String gameId,
    String? id,
    @DateTimeNullableConverter() DateTime? createdAt,
    @BidConverter() Bid? bid,
    @Default(false) bool processed,
    @Default(0) int round,
    @Default(0) int turn,
  }) = _Action;

  factory Action.fromJson(Map<String, dynamic> json) => _$ActionFromJson(json);
}
