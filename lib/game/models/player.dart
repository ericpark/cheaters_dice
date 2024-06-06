import 'package:cheaters_dice/app/helpers/converters.dart';
import 'package:cheaters_dice/game/game.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/player.freezed.dart';
part 'generated/player.g.dart';

@freezed
class Player with _$Player {
  factory Player({
    required String id,
    String? name,
    @Default(0) int? numberOfDice,
    @PlayerDiceConverter() @Default([]) List<Die> dice,
  }) = _Player;

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);
}
