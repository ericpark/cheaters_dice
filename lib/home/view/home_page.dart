import 'package:cheaters_dice/app/widgets/widgets.dart';
import 'package:cheaters_dice/home/home.dart';
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
            final widgets = [
              Container(
                alignment: Alignment.center,
                height: constraints.maxHeight * 0.65,
                width: constraints.maxWidth * 0.9,
                child: const BannerTile(),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: constraints.maxHeight * 0.18,
                width: constraints.maxWidth * 0.9,
                child: const IntroductionTile(),
              ),
            ];
            return SuperScaffold(
              transitionBetweenRoutes: false,
              appBar: SuperAppBar(
                automaticallyImplyLeading: false,
                titleSpacing: 0,
                searchBar: SuperSearchBar(enabled: false),
                backgroundColor:
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
                leading: IconButton(
                  icon: const Icon(Icons.person),
                  iconSize: 22,
                  onPressed: () {},
                ),
                actions: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_none_sharp),
                      iconSize: 22,
                      onPressed: () {},
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                  ],
                ),
                largeTitle: SuperLargeTitle(
                  largeTitle: 'HOME',
                  actions: [
                    /*SuperAction(
                      child: IconButton(
                        icon: const Icon(Icons.refresh),
                        iconSize: 22,
                        onPressed: () {},
                      ),
                    ),*/
                  ],
                ),
              ),
              body: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: widgets.length,
                itemBuilder: (context, index) {
                  return widgets[index];
                },
              ),
            );
          },
        );
      },
    );
  }
}
