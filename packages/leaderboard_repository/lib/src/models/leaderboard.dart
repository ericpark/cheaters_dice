import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_converter/firestore_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';

part 'generated/leaderboard.g.dart';
part 'generated/leaderboard.firestore_converter.dart';
part 'generated/leaderboard.freezed.dart';

@freezed
@FirestoreConverter(defaultPath: 'leaderboard')
class Leaderboard with _$Leaderboard {
  factory Leaderboard({
    String? id,
    @Default(0) int games,
    @Default(0) int wins,
    @Default('') String name,
    String? profileImage,
    @DateTimeNullableConverter() DateTime? createdAt,
  }) = _Leaderboard;

  factory Leaderboard.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardFromJson(json);
}
