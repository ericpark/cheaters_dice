import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_converter/firestore_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lobby_repository/lobby_repository.dart';

part 'generated/lobby.g.dart';
part 'generated/lobby.firestore_converter.dart';
part 'generated/lobby.freezed.dart';

enum LobbyStatus {
  initial,
  waiting,
  loading,
  playing,
  transitioning,
  finished,
  failure
}

@freezed
@FirestoreConverter(defaultPath: 'lobbies')
class Lobby with _$Lobby {
  factory Lobby({
    String? gameId,
    String? hostId,
    String? id,
    //@Default([]) List<String> order,
    //@Default([]) List<String> tableOrder,
    @Default(LobbyStatus.initial) LobbyStatus status,
    @DateTimeNullableConverter() DateTime? createdAt,
    @PlayersConverter() @Default({}) Map<String, Player> players,
    @Default({}) Map<String, dynamic> settings,
    String? name,
  }) = _Lobby;

  factory Lobby.fromJson(Map<String, dynamic> json) => _$LobbyFromJson(json);
}
