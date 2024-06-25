// ignore_for_file: require_trailing_commas
import 'package:cheaters_dice/auth/auth.dart';
import 'package:cheaters_dice/game/game.dart';
import 'package:cheaters_dice/lobby/lobby.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:glass/glass.dart';
import 'package:go_router/go_router.dart';

class JoinedLobbyPage extends StatelessWidget {
  const JoinedLobbyPage({required this.lobbyId, super.key});

  final String lobbyId;

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthCubit>().state.user!.id;
    final hostId =
        context.read<LobbyCubit>().state.joinedLobby!.hostId ?? userId;

    return Scaffold(
      appBar: AppBar(
        title:
            Text(context.read<LobbyCubit>().state.joinedLobby?.name ?? 'Lobby'),
        leading: context.canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () async {
                  context.pop('/lobby');

                  await context
                      .read<LobbyCubit>()
                      .leaveLobby(user: context.read<AuthCubit>().state.user!);
                },
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () async {
                  context.go('/lobby');

                  await context
                      .read<LobbyCubit>()
                      .leaveLobby(user: context.read<AuthCubit>().state.user!);
                },
              ),
        actions: userId == hostId
            ? [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    context.push('/lobby/$lobbyId/settings');
                  },
                ),
              ]
            : null,
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
        final userId = context.read<AuthCubit>().state.user!.id;

        return BlocConsumer<LobbyCubit, LobbyState>(
          listener: (context, state) {
            if (state.joinedLobby!.status == LobbyStatus.playing) {
              context.read<GameBloc>().add(GameStart(
                  userId: userId, gameId: state.joinedLobby!.gameId!));
              context.push('/game/${state.joinedLobby!.gameId}');
            }
          },
          builder: (context, state) {
            final hostId = state.joinedLobby!.hostId ?? userId;
            final players = state.joinedLobby!.players.keys.toList();

            return Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      JoinedPlayers(
                        players: state.joinedLobby!.players,
                        hostId: hostId,
                        height: constraints.maxHeight * 0.8,
                        width: constraints.maxWidth * 0.8,
                      ),
                      if (hostId == userId)
                        ElevatedButton(
                          onPressed: players.length < 2
                              ? null
                              : () {
                                  context
                                      .read<LobbyCubit>()
                                      .startGame(
                                        state.joinedLobbyId,
                                        userId,
                                        players,
                                      )
                                      .then((gameId) {
                                    context.read<GameBloc>().add(GameStart(
                                        userId: userId, gameId: gameId));
                                    context.push('/game/$gameId');
                                  });
                                },
                          child: const Text('Start Game'),
                        ),
                    ],
                  ),
                ),
                if (state.joinedLobby!.status == LobbyStatus.loading)
                  Center(
                      child: const SizedBox(
                    //color: Colors.black26.withOpacity(0.5),
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Starting game...',
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(height: 10),
                        CircularProgressIndicator(),
                      ],
                    ),
                  ).asGlass()),
              ],
            );
          },
        );
      },
    );
  }
}

class JoinedPlayers extends StatelessWidget {
  const JoinedPlayers({
    required this.players,
    required this.hostId,
    required this.height,
    required this.width,
    super.key,
  });

  final double height;
  final String hostId;
  final Map<String, Player> players;
  final double width;

  @override
  Widget build(BuildContext context) {
    print(players);
    final playerKeys = players.keys.toList();
    return SizedBox(
      height: height,
      width: width,
      child: ListView.builder(
        itemCount: players.keys.length,
        itemBuilder: (context, index) {
          final player = players[playerKeys[index]];
          final playerName = player?.name ?? player!.id;
          return ListTile(
            title: Text(playerName),
            leading: (player!.id == hostId)
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
    );
  }
}
