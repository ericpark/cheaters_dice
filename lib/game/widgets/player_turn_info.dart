import 'package:flutter/material.dart';

class PlayerTurnInfo extends StatelessWidget {
  const PlayerTurnInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        alignment: Alignment.center,
        height: 30,
        width: 100,
        child: const Text('PLAYER 2 TURN'),
      ),
    );
  }
}
