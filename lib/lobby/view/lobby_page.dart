import 'package:cheaters_dice/app/widgets/widgets.dart';
import 'package:cheaters_dice/auth/auth.dart';
import 'package:cheaters_dice/lobby/lobby.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:super_cupertino_navigation_bar/super_cupertino_navigation_bar.dart';

class LobbyPage extends StatelessWidget {
  const LobbyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: LobbyView(),
      bottomNavigationBar: BottomBar(initialActiveIndex: 1),
    );
  }
}

class LobbyView extends StatelessWidget {
  const LobbyView({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthCubit>().state.user!;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return BlocBuilder<LobbyCubit, LobbyState>(
          builder: (context, state) {
            return SuperScaffold(
              transitionBetweenRoutes: false,
              appBar: SuperAppBar(
                title: const Text('LOBBIES'),
                largeTitle: SuperLargeTitle(
                  largeTitle: 'LOBBIES',
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {},
                    ),
                  ],
                ),
                titleSpacing: 0,
                shadowColor: Colors.grey,
                searchBar: SuperSearchBar(
                  enabled: false,
                ),
              ),
              body: ListView.builder(
                shrinkWrap: true,
                itemCount: state.availableLobbies.length,
                itemBuilder: (context, index) {
                  final lobby = state.availableLobbies[index];

                  return ListTile(
                    title: Text(lobby.name),
                    subtitle: Text('STATUS: ${lobby.status.name}'),
                    trailing: ElevatedButton(
                      onPressed: () async {
                        final joinedLobby =
                            await context.read<LobbyCubit>().joinLobby(
                                  lobbyId: lobby.id,
                                  user: currentUser,
                                );

                        if (joinedLobby == null) return;

                        if (joinedLobby.gameId != null &&
                            joinedLobby.status == LobbyStatus.playing) {
                          // If game has started, just jump into the game.
                          if (!context.mounted) return;
                          await context.push('/game/${joinedLobby.gameId}');
                        } else {
                          // No game in progress, just continue to lobby.
                          if (!context.mounted) return;
                          await context.push('/lobby/${lobby.id}');
                        }
                      },
                      child: const Text('Join'),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
