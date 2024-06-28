import 'package:bloc/bloc.dart';
import 'package:cheaters_dice/leaderboard/leaderboard.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart'
    hide Leaderboard;

class LeaderboardCubit extends Cubit<LeaderboardState> {
  LeaderboardCubit(this._leaderboardRepository)
      : super(const LeaderboardState());

  final LeaderboardRepository _leaderboardRepository;

  /// Initialize the auth repository and log in user if already exists
  Future<void> init() async {
    // checks if user was previously logged in
    final leaderboard = ((await _leaderboardRepository.getLeaderboard()) ?? [])
        .map((e) => Leaderboard.fromJson(e.toJson()))
        .toList();

    emit(state.copyWith(leaderboard: leaderboard));
  }

  Future<void> refresh() async {
    final leaderboard = ((await _leaderboardRepository.getLeaderboard()) ?? [])
        .map((e) => Leaderboard.fromJson(e.toJson()))
        .toList();
    emit(state.copyWith(leaderboard: leaderboard));
  }
}
