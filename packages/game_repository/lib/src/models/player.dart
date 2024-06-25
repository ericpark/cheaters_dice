import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:game_repository/game_repository.dart';

part 'generated/player.freezed.dart';
part 'generated/player.g.dart';

@freezed
class Player with _$Player {
  factory Player({
    required String id,
    String? name,
    @Default(0) int numberOfDice,
    @PlayerDiceConverter() @Default([]) List<Die> dice,
    String? photo,
  }) = _Player;

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);
}
