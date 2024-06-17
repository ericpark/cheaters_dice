import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lobby_repository/lobby_repository.dart';

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
