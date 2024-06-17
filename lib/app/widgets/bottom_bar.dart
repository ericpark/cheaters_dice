import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({this.initialActiveIndex = 0, super.key});

  final int initialActiveIndex;

  @override
  Widget build(BuildContext context) {
    return ConvexAppBar(
      style: TabStyle.react,
      items: const [
        TabItem(icon: Icons.home),
        TabItem(icon: Icons.games),
        TabItem(icon: Icons.assessment),
      ],
      initialActiveIndex: initialActiveIndex,
      onTap: (int i) {
        if (i == 0) {
          context.go('/');
        }
        if (i == 1) {
          context.go('/lobby');
        }
        if (i == 2) {
          context.go('/leaderboard');
        }
      },
    );
  }
}
