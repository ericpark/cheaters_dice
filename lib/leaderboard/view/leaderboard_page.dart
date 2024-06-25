import 'package:cached_network_image/cached_network_image.dart';
import 'package:cheaters_dice/app/widgets/widgets.dart';
import 'package:cheaters_dice/constants.dart';
import 'package:flutter/material.dart';
import 'package:super_cupertino_navigation_bar/super_cupertino_navigation_bar.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      bottomNavigationBar: BottomBar(initialActiveIndex: 2),
      body: LeaderboardView(),
    );
  }
}

class LeaderboardView extends StatelessWidget {
  const LeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final leaderboard = ['Eric', 'Meeko'];
    return LayoutBuilder(
      builder: (context, constraints) {
        return SuperScaffold(
          transitionBetweenRoutes: false,
          appBar: SuperAppBar(
            title: const Text('Leaderboard'),
            largeTitle: SuperLargeTitle(
              largeTitle: 'LEADERBOARD',
              actions: [
                SuperAction(
                  child: IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            titleSpacing: 0,
            shadowColor: Colors.grey,
            searchBar: SuperSearchBar(),
          ),
          body: Center(
            child: SizedBox(
              height: constraints.maxHeight,
              width: (constraints.maxWidth > 1000)
                  ? constraints.maxWidth * 0.4
                  : constraints.maxWidth,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: leaderboard.length,
                itemBuilder: (context, index) {
                  final player = leaderboard[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      title: Text(player),
                      contentPadding: const EdgeInsets.all(8),
                      leading: CircleAvatar(
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: AppConstants.defaultProfilePictureUrl,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                      trailing: Text(
                        '#${index + 1}',
                        textScaler: const TextScaler.linear(2),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
