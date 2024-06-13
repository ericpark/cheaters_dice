import 'package:cheaters_dice/lobby/lobby.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/lobby.freezed.dart';
part 'generated/lobby.g.dart';

@freezed
abstract class Lobby with _$Lobby {
  factory Lobby({
    @Default(LobbyStatus.initial) LobbyStatus status,
    @Default('') String id,
    @Default('') String name,
    @Default(0) int players,
  }) = _Lobby;

  factory Lobby.initial() => _Lobby();

  factory Lobby.fromJson(Map<String, dynamic> json) => _$LobbyFromJson(json);
}
