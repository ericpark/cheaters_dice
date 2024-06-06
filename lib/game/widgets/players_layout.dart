import 'package:cheaters_dice/game/game.dart';
import 'package:flutter/material.dart';

class PlayersLayout extends StatelessWidget {
  const PlayersLayout({required this.players, super.key});

  /// A list of other players in the game in order of play.
  /// This should not include the current player.
  final List<Player> players;

  @override
  Widget build(BuildContext context) {
    final numberOfPlayers = players.length;
    Widget centerLeftSlot = Container();
    Widget centerTopSlot = Container();
    Widget centerRightSlot = Container();
    Widget leftSlot = Container();
    Widget rightSlot = Container();

    var shouldShowTopLeftAndRight = false;
    var shouldShowTopCenter = false;
    var shouldShowMiddleLeftAndRight = false;

    switch (numberOfPlayers) {
      case 0:
        break; // Shouldn't play with 1 player
      case 1:
        centerTopSlot = PlayerAvatar(player: players[0]);

        shouldShowTopCenter = true;
      case 2:
        centerLeftSlot = PlayerAvatar(player: players[0]);
        centerLeftSlot = PlayerAvatar(player: players[1]);

        shouldShowTopLeftAndRight = true;
      case 3:
        leftSlot = PlayerAvatar(player: players[0]);
        centerTopSlot = PlayerAvatar(player: players[1]);
        rightSlot = PlayerAvatar(player: players[2]);

        shouldShowTopCenter = true;
        shouldShowMiddleLeftAndRight = true;
      case 4:
        leftSlot = PlayerAvatar(player: players[0]);
        centerLeftSlot = PlayerAvatar(player: players[1]);
        centerRightSlot = PlayerAvatar(player: players[2]);
        rightSlot = PlayerAvatar(player: players[3]);

        shouldShowTopLeftAndRight = true;
        shouldShowMiddleLeftAndRight = true;

      case 5:
        leftSlot = PlayerAvatar(player: players[0]);
        centerLeftSlot = PlayerAvatar(player: players[1]);
        centerTopSlot = PlayerAvatar(player: players[2]);
        centerRightSlot = PlayerAvatar(player: players[3]);
        rightSlot = PlayerAvatar(player: players[4]);

        shouldShowTopLeftAndRight = true;
        shouldShowTopCenter = true;
        shouldShowMiddleLeftAndRight = true;
    }

    return Flex(
      direction: Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Center(
            child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(child: Container()),
                if (shouldShowTopLeftAndRight) Expanded(child: centerLeftSlot),
                if (shouldShowTopCenter) Expanded(child: centerTopSlot),
                if (shouldShowTopLeftAndRight) Expanded(child: centerRightSlot),
                Flexible(child: Container()),
              ],
            ),
          ),
        ),
        Expanded(
          child: Flex(
            direction: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (shouldShowMiddleLeftAndRight) Expanded(child: leftSlot),
              const Expanded(child: CurrentBid()),
              if (shouldShowMiddleLeftAndRight) Expanded(child: rightSlot),
            ],
          ),
        ),
      ],
    );
  }
}
