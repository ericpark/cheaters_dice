import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';

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
