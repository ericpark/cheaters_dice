import 'package:cheaters_dice/app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:super_cupertino_navigation_bar/super_cupertino_navigation_bar.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: BottomBar(initialActiveIndex: 2),
      body: LeaderboardView(),
    );
  }
}

class LeaderboardView extends StatelessWidget {
  const LeaderboardView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SuperScaffold(
        transitionBetweenRoutes: false,
        appBar: SuperAppBar(
          title: const Text('Leaderboard'),
          largeTitle: SuperLargeTitle(
            largeTitle: 'LEADERBOARD',
            actions: [
              SuperAction(
                behavior: SuperActionBehavior.visibleOnUnFocus,
                child: IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          titleSpacing: 0,
          shadowColor: Colors.grey,
          searchBar: SuperSearchBar(),
        ),
        body: const Center(child: Text('Leaderboard Page')));
  }
}
