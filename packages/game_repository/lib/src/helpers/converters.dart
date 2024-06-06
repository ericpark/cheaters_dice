import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:game_repository/game_repository.dart';

class DateTimeConverter implements JsonConverter<DateTime, dynamic> {
  const DateTimeConverter();

  @override
  DateTime fromJson(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    }
    if (timestamp is String) {
      return DateTime.parse(timestamp);
    }
    return DateTime.now();
  }

  @override
  Timestamp toJson(DateTime timestamp) => Timestamp.fromDate(timestamp);
}

class DateTimeNullableConverter implements JsonConverter<DateTime?, dynamic> {
  const DateTimeNullableConverter();

  @override
  DateTime fromJson(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    }
    if (timestamp is String) {
      return DateTime.parse(timestamp);
    }
    return DateTime.now();
  }

  @override
  Timestamp toJson(DateTime? timestamp) =>
      Timestamp.fromDate(timestamp ?? DateTime.now());
}

class DiceConverter implements JsonConverter<Map<String, List<Die>>, dynamic> {
  const DiceConverter();

  @override
  Map<String, List<Die>> fromJson(dynamic dice) {
    return (dice as Map<String, dynamic>).map((key, value) {
      return MapEntry(
        key,
        (value as List<dynamic>)
            .map((d) => Die.fromJson(d as Map<String, dynamic>))
            .toList(),
      );

      //return MapEntry(key, list.map(Die.fromJson).toList());
    });
  }

  @override
  Map<String, List<Map<String, dynamic>>> toJson(Map<String, List<Die>> dice) =>
      dice.map((key, value) {
        return MapEntry(key, value.map((e) => e.toJson()).toList());
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

class BidConverter implements JsonConverter<Bid, dynamic> {
  const BidConverter();

  @override
  Bid fromJson(dynamic json) {
    if (json == null) {
      return const Bid();
    }
    return Bid.fromJson(json as Map<String, dynamic>);
  }

  @override
  Map<String, dynamic> toJson(Bid bid) => bid.toJson();
}
