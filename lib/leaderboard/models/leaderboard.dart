import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/leaderboard.g.dart';
part 'generated/leaderboard.freezed.dart';

@freezed
class Leaderboard with _$Leaderboard {
  factory Leaderboard({
    String? playerId,
    @Default('') String name,
    String? profileImage,
    @Default(1000) int elo,
    @Default(0) int longestStreak, // longest game win streak
    @Default(0) int games,
    @Default(0) int wins,
    @Default(0) int successfulChallenges, // player challenging others
    @Default(0) int totalChallenges,
    @Default(0) int challengedBids, // player getting challenged by others
    @Default(0) int totalBids,
  }) = _Leaderboard;

  factory Leaderboard.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardFromJson(json);
}
