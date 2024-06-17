import 'package:cheaters_dice/auth/auth.dart';
import 'package:cheaters_dice/lobby/lobby.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LobbySettingPage extends StatelessWidget {
  const LobbySettingPage({required this.lobbyId, super.key});

  final String lobbyId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              context.pop();
            },
          ),
        ],
      ),
      body: const LobbySettingView(),
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

class LobbySettingView extends StatelessWidget {
  const LobbySettingView({super.key});

  @override
  Widget build(BuildContext context) {
    //const gameId = '46hOQ2pQ26C4aIx6iAWF';

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        //final userId = context.read<AuthCubit>().state.user?.id;
        return BlocBuilder<LobbyCubit, LobbyState>(
          builder: (context, state) {
            return const Center(
              child: Text('Settings Page'),
            );
          },
        );
      },
    );
  }
}
