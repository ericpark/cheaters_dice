import 'package:cheaters_dice/game/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerDice extends StatelessWidget {
  const PlayerDice({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        return Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: state.players['player_1']!.dice
                .map((d) => Dice(value: d.value))
                .toList(),
          ),
        );
      },
    );
  }
}
