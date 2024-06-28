import 'package:cached_network_image/cached_network_image.dart';
import 'package:cheaters_dice/app/widgets/widgets.dart';
import 'package:cheaters_dice/constants.dart';
import 'package:cheaters_dice/leaderboard/leaderboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_cupertino_navigation_bar/super_cupertino_navigation_bar.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: false,
      bottomNavigationBar: const BottomBar(initialActiveIndex: 2),
      body: const LeaderboardView(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }
}

class LeaderboardView extends StatelessWidget {
  const LeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return BlocBuilder<LeaderboardCubit, LeaderboardState>(
          builder: (context, state) {
            final leaderboard = state.leaderboard;

            return SuperScaffold(
              transitionBetweenRoutes: false,
              appBar: SuperAppBar(
                automaticallyImplyLeading: false,
                titleSpacing: 0,
                searchBar: SuperSearchBar(enabled: false),
                backgroundColor:
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.5),
                leading: IconButton(
                  icon: const Icon(Icons.filter_alt),
                  iconSize: 22,
                  onPressed: () {},
                ),
                actions: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.refresh),
                      iconSize: 22,
                      onPressed: () async =>
                          context.read<LeaderboardCubit>().refresh(),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                  ],
                ),
                largeTitle: SuperLargeTitle(
                  largeTitle: 'LEADERBOARD',
                  actions: [],
                ),
              ),
              body: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: leaderboard.length,
                itemBuilder: (context, index) {
                  final player = leaderboard[index];
                  return LeaderboardTile(
                    player: player,
                    rank: index,
                    height: constraints.maxHeight / 8,
                    width: constraints.maxWidth,
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

class LeaderboardTile extends StatelessWidget {
  const LeaderboardTile({
    required this.player,
    required this.rank,
    required this.height,
    required this.width,
    super.key,
  });

  final Leaderboard player;
  final int rank;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    final rankString = (rank + 1).toString();
    final trophyColor = rank == 0
        ? Colors.amber
        : rank == 1
            ? Colors.grey
            : rank == 2
                ? Colors.brown
                : Colors.transparent;

    final winPercentage =
        player.wins / (player.games > 0 ? player.games : 1) * 100;

    return Card(
      clipBehavior: Clip.hardEdge,
      margin: EdgeInsets.symmetric(
        horizontal: width * 0.05,
        vertical: 10,
      ),
      child: SizedBox(
        height: height,
        width: width * 0.9,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: height * 0.6,
              width: height * 0.6,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(50),
              ),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: height * 0.6 / 2,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: player.profileImage ??
                        AppConstants.defaultProfilePictureUrl,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Flex(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  direction: Axis.vertical,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${player.name} (${player.elo})',
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                    //const Divider(),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('W: ${player.wins}'),
                        const Text(' | '),
                        Text('L: ${player.games - player.wins}'),
                        const Text(' | '),
                        Text('${winPercentage.toStringAsFixed(1)} %'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              constraints: const BoxConstraints(maxWidth: 125),
              width: width * 0.25,
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              child: Row(
                //mainAxisSize: MainAxisSize.max,
                //mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //const VerticalDivider(),
                  //const Center(child: Text('#')),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.centerRight,
                      clipBehavior: Clip.none,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('#'),
                              Text(
                                rankString,
                                textScaler: const TextScaler.linear(1.5),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              Icons.emoji_events_rounded,
                              color: trophyColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
