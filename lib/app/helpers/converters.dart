import 'package:cheaters_dice/game/models/die.dart';
import 'package:cheaters_dice/game/models/player.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

class DateTimeConverter implements JsonConverter<DateTime, dynamic> {
  const DateTimeConverter();

  @override
  DateTime fromJson(dynamic timestamp) {
    /*if (timestamp is Timestamp) {
      return timestamp.toDate();
    }*/
    if (timestamp is String) {
      return DateTime.parse(timestamp);
    }
    return DateTime.now();
  }

  @override
  String toJson(DateTime object) => DateFormat('yyyy-MM-dd').format(object);
}

class PlayersConverter implements JsonConverter<Map<String, Player>, dynamic> {
  const PlayersConverter();

  @override
  Map<String, Player> fromJson(dynamic players) {
    return (players as Map<String, dynamic>).map((key, value) {
      return MapEntry(
        key,
        Player.fromJson(value as Map<String, dynamic>),
      );

      //return MapEntry(key, list.map(Die.fromJson).toList());
    });
  }

  @override
  Map<String, dynamic> toJson(Map<String, Player> players) =>
      players.map((key, value) {
        return MapEntry(key, value.toJson());
      });
}

class PlayerDiceConverter implements JsonConverter<List<Die>, dynamic> {
  const PlayerDiceConverter();

  @override
  List<Die> fromJson(dynamic dice) {
    return (dice as List<dynamic>)
        .map((d) => Die.fromJson(d as Map<String, dynamic>))
        .toList();

    //return MapEntry(key, list.map(Die.fromJson).toList());
  }

  @override
  List<Map<String, dynamic>> toJson(List<Die> dice) =>
      dice.map((e) => e.toJson()).toList();
}
