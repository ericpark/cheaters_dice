import 'package:cheaters_dice/auth/auth.dart';
import 'package:cheaters_dice/lobby/lobby.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class JoinedLobbyPage extends StatelessWidget {
  const JoinedLobbyPage({required this.lobbyId, super.key});

  final String lobbyId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Joined'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.push('/lobby/$lobbyId/settings');
            },
          ),
        ],
      ),
      body: const JoinedLobbyView(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8),
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          mini: true,
          onPressed: () {},
          child: const Icon(Icons.help),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}

class JoinedLobbyView extends StatelessWidget {
  const JoinedLobbyView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final userId = context.read<AuthCubit>().state.user?.id;
        final players = [userId!, 'rcBZlsPOVqU6IHnGcJN0xsvAR5x1'];
        final hostId = userId;
        return BlocBuilder<LobbyCubit, LobbyState>(
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: constraints.maxHeight * 0.8,
                    width: constraints.maxWidth * 0.8,
                    child: ListView.builder(
                      itemCount: players.length,
                      itemBuilder: (context, index) {
                        final player = players[index];
                        return ListTile(
                          title: Text(player),
                          leading: (player == hostId)
                              ? const Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                )
                              : const Icon(
                                  Icons.star,
                                  color: Colors.transparent,
                                ),
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<LobbyCubit>()
                          .createGame(
                            state.joinedLobbyId,
                            userId,
                            players,
                          )
                          .then((gameId) {
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
