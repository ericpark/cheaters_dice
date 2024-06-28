import 'package:cheaters_dice/leaderboard/leaderboard.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/leaderboard_state.g.dart';
part 'generated/leaderboard_state.freezed.dart';

@freezed
abstract class LeaderboardState with _$LeaderboardState {
  const factory LeaderboardState({
    // This is okay because we will never write toJson
    @Default([]) List<Leaderboard> leaderboard,
  }) = _LeaderboardState;

  factory LeaderboardState.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardStateFromJson(json);
}
