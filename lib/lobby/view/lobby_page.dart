import 'package:cheaters_dice/lobby/lobby.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LobbyPage extends StatelessWidget {
  const LobbyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LobbyView();
  }
}

class LobbyView extends StatelessWidget {
  const LobbyView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LobbyCubit, LobbyState>(
      builder: (context, state) {
        return Center(
          child: Column(
            children: [
              TextButton(
                onPressed: () => {
                  Navigator.of(context).pushNamed('/game'),
                },
                child: const Text('Start Game'),
              ),
            ],
          ),
        );
      },
    );
  }
}
