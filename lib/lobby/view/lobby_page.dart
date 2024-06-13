import 'package:cheaters_dice/lobby/lobby.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LobbyPage extends StatelessWidget {
  const LobbyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: LobbyView());
  }
}

class LobbyView extends StatelessWidget {
  const LobbyView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return BlocBuilder<LobbyCubit, LobbyState>(
          builder: (context, state) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Available Lobbies:'),
                  SizedBox(
                    height: constraints.maxHeight * 0.7,
                    width: constraints.maxWidth * 0.7,
                    child: ListView.builder(
                      itemCount: state.availableLobbies.length,
                      itemBuilder: (context, index) {
                        final lobby = state.availableLobbies[index];
                        return ListTile(
                          title: Text(lobby.name),
                          subtitle: Text('Players: ${lobby.players}'),
                          trailing: ElevatedButton(
                            onPressed: () {
                              context.go('/lobby/${lobby.id}');
                            },
                            child: const Text('Join'),
                          ),
                        );
                      },
                    ),
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
