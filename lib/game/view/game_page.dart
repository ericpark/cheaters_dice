import 'package:cheaters_dice/auth/auth.dart';
import 'package:cheaters_dice/game/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GamePage extends StatelessWidget {
  const GamePage({required this.gameId, super.key});

  final String gameId;

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.read<AuthCubit>().state.user!.id;

    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        switch (state.status) {
          case GameStatus.initial:
            context
                .read<GameBloc>()
                .add(GameLoad(userId: currentUserId, gameId: gameId));

            return const GameLoading();
          case GameStatus.loading:
            return const GameLoading();
          case GameStatus.playing:
            return const GameViewMobile();
          case GameStatus.transitioning:
            return const GameViewMobile();
          case GameStatus.failure:
            return const Scaffold(body: Center(child: Text('ERROR')));
          case GameStatus.finished:
            return const GameViewMobile();
        }
      },
    );
  }
}

class GameLoading extends StatelessWidget {
  const GameLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
