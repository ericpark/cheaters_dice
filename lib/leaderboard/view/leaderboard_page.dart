import 'package:cheaters_dice/app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      bottomNavigationBar: const BottomBar(initialActiveIndex: 2),
      body: const Center(child: Text('Leaderboard Page')),
    );
  }
}
