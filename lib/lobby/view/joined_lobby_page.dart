import 'package:cheaters_dice/auth/auth.dart';
import 'package:cheaters_dice/lobby/lobby.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class JoinedLobbyPage extends StatelessWidget {
  const JoinedLobbyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const JoinedLobbyView(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8),
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          mini: true,
          onPressed: () {},
          child: const Icon(Icons.settings),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}

class JoinedLobbyView extends StatelessWidget {
  const JoinedLobbyView({super.key});

  @override
  Widget build(BuildContext context) {
    //const gameId = '46hOQ2pQ26C4aIx6iAWF';

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final userId = context.read<AuthCubit>().state.user?.id;
        return BlocBuilder<LobbyCubit, LobbyState>(
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      context.read<LobbyCubit>().createGame(
                        state.joinedLobbyId,
                        userId!,
                        [userId, 'rcBZlsPOVqU6IHnGcJN0xsvAR5x1'],
                      ).then((gameId) {
                        //context.read<GameBloc>().add();
                        context.go('/game/$gameId');
                      });
                    },
                    child: const Text('Start Game'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
