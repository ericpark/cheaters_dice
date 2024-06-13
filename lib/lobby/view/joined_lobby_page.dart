import 'package:cheaters_dice/lobby/lobby.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class JoinedLobbyPage extends StatelessWidget {
  const JoinedLobbyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: JoinedLobbyView());
  }
}

class JoinedLobbyView extends StatelessWidget {
  const JoinedLobbyView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return BlocBuilder<LobbyCubit, LobbyState>(
          builder: (context, state) {
            const gameId = '46hOQ2pQ26C4aIx6iAWF';
            if (state.joinedLobbyId != 'j2n4DG1ldWmUwRcmqSKZ') {
              context.go('/game/$gameId');
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => {
                      context.go('/game/$gameId'),
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
