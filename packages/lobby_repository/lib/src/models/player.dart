import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lobby_repository/lobby_repository.dart';

part 'generated/player.freezed.dart';
part 'generated/player.g.dart';

@freezed
class Player with _$Player {
  factory Player({
    required String id,
    String? name,
    @DateTimeNullableConverter() DateTime? joinedAt,
  }) = _Player;

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);
}
