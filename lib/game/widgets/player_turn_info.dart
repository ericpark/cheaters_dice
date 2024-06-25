import 'package:cheaters_dice/auth/cubit/auth_cubit.dart';
import 'package:cheaters_dice/game/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerTurnInfo extends StatelessWidget {
  const PlayerTurnInfo({required this.player, super.key});

  final Player? player;

  @override
  Widget build(BuildContext context) {
    if (player == null) {
      return const SizedBox();
    }
    final currentPlayerTurn =
        player!.id == context.read<AuthCubit>().state.user?.id;
    final currentPlayerName = currentPlayerTurn
        ? 'Your Turn'
        : "${player!.name ?? 'Player ${player!.id}'}'s turn";

    return Card(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: currentPlayerTurn ? Colors.green : Colors.black,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        height: 30,
        width: 100,
        child: Text(currentPlayerName),
      ),
    );
  }
}
