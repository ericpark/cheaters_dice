import 'package:cheaters_dice/auth/auth.dart';
import 'package:cheaters_dice/game/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerDice extends StatelessWidget {
  const PlayerDice({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthCubit>().state.user?.id;

    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        return Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: state.players[currentUser]!.dice
                .map((d) => Dice(value: d.value))
                .toList(),
            //..add(Dice(value: 2))
            //..add(Dice(value: 2))
            //..add(Dice(value: 2)),
          ),
        );
      },
    );
  }
}
