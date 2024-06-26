import 'package:cheaters_dice/app/widgets/widgets.dart';
import 'package:cheaters_dice/auth/auth.dart';
import 'package:cheaters_dice/lobby/lobby.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_cupertino_navigation_bar/super_cupertino_navigation_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: false,
      extendBodyBehindAppBar: true,
      body: const HomeView(),
      bottomNavigationBar: const BottomBar(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return BlocBuilder<LobbyCubit, LobbyState>(
          builder: (context, state) {
            return SuperScaffold(
              transitionBetweenRoutes: false,
              appBar: SuperAppBar(
                leading: IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () {},
                ),
                actions: IconButton(
                  icon: const Icon(Icons.notifications_none_sharp),
                  onPressed: () {},
                ),
                title: const Text('Home'),
                largeTitle: SuperLargeTitle(
                  largeTitle: 'HOME',
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.more_vert_sharp),
                      onPressed: () {
                        context.read<AuthCubit>().logout();
                      },
                    ),
                  ],
                ),
                titleSpacing: 0,
                shadowColor: Colors.grey,
                searchBar: SuperSearchBar(
                  enabled: false,
                ),
              ),
              body: const Center(
                child: Text('Home Page'),
              ),
            );
          },
        );
      },
    );
  }
}
