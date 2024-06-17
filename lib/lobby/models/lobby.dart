import 'package:cheaters_dice/app/helpers/helpers.dart';
import 'package:cheaters_dice/game/game.dart';
import 'package:cheaters_dice/lobby/lobby.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/lobby.freezed.dart';
part 'generated/lobby.g.dart';

@freezed
abstract class Lobby with _$Lobby {
  factory Lobby({
    @Default(LobbyStatus.initial) LobbyStatus status,
    String? gameId,
    String? hostId,
    @Default([]) List<String> order,
    @Default([]) List<String> tableOrder,
    //@DateTimeNullableConverter() DateTime? createdAt,
    @PlayersConverter() @Default({}) Map<String, Player> players,
    @Default({}) Map<String, dynamic> settings,
    @Default('') String id,
    @Default('') String name,
  }) = _Lobby;

  factory Lobby.initial() => _Lobby();

  factory Lobby.fromJson(Map<String, dynamic> json) => _$LobbyFromJson(json);
}
