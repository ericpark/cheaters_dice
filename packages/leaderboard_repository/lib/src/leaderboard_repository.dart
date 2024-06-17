// ignore_for_file: unnecessary_parenthesis

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:leaderboard_repository/leaderboard_repository.dart';

class LeaderboardRepository {
  LeaderboardRepository();

  Future<List<Leaderboard>?> getLeaderboard() async {
    final leaderboardRef = leaderboardCollection();

    try {
      return await leaderboardRef.get().then(
        (result) {
          final leaderboard = <Leaderboard>[];

          for (final doc in result.docs) {
            leaderboard.add(doc.data());
          }
          return leaderboard;
        },
        onError: (dynamic e) => debugPrint('Error completing: $e'),
      );
    } catch (err) {
      debugPrint('Error while retrieving lobby: $err');
      return null;
    }
  }
}
