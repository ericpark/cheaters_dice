import 'package:cheaters_dice/app/widgets/widgets.dart';
import 'package:cheaters_dice/lobby/lobby.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
            return Scaffold(
              appBar: AppBar(title: const Text('Home')),
              bottomNavigationBar: const BottomBar(),
              body: const Center(child: Text('Home Page')),
            );
          },
        );
      },
    );
  }
}
