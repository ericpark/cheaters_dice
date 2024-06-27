import 'package:cheaters_dice/app/helpers/helpers.dart';
import 'package:cheaters_dice/game/game.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/player_action.g.dart';
part 'generated/player_action.freezed.dart';

enum PlayerActionType { bid, challenge, spot, skip, reverse }

extension PlayerActionTypeX on PlayerActionType {
  bool get isBid => this == PlayerActionType.bid;
  bool get isChallenge => this == PlayerActionType.challenge;
  bool get isSpotOn => this == PlayerActionType.spot;
}

@freezed
class PlayerAction with _$PlayerAction {
  factory PlayerAction({
    required PlayerActionType actionType,
    required String playerId,
    @DateTimeConverter() DateTime? createdAt,
    Bid? bid,
  }) = _PlayerAction;

  factory PlayerAction.fromJson(Map<String, dynamic> json) =>
      _$PlayerActionFromJson(json);
}
