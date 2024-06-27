import 'dart:math';

import 'package:cheaters_dice/game/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayersLayout extends StatefulWidget {
  const PlayersLayout({
    required this.players,
    this.activePlayerId = '',
    super.key,
  });

  final String activePlayerId;

  /// A list of other players in the game in order of play.
  /// This should not include the current player.
  final List<Player> players;

  @override
  State<PlayersLayout> createState() => _PlayersLayoutState();
}

class _PlayersLayoutState extends State<PlayersLayout> {
  List<Widget> calculateCircleCoordinates(
    int numberOfPoints,
    double avatarSize,
  ) {
    final coordinates = <Widget>[];

    const radius = 1.1; // adjust the radius as needed
    const centerX = 0.0; // adjust the center X coordinate as needed
    const centerY = 0.2; // adjust the center Y coordinate as needed
    const startAngle = 3.14159 / 2; // start angle at 3/2 pi

    for (var i = 1; i < numberOfPoints; i++) {
      final angle = startAngle + (2 * 3.14159 * i / numberOfPoints);
      final x = centerX + radius * cos(angle);
      final y = centerY + radius * sin(angle);

      coordinates.add(
        Align(
          alignment: Alignment(x, y),
          child: SizedBox(
            height: avatarSize,
            width: avatarSize,
            child: PlayerAvatar(
              player: widget.players[0],
              active: widget.players[0].id == widget.activePlayerId,
            ),
          ),
        ),
      );
    }

    return coordinates;
  }

  @override
  Widget build(BuildContext context) {
    final numberOfPlayers = widget.players.length + 1;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return BlocBuilder<GameBloc, GameState>(
          builder: (context, state) {
            final shorterSide = constraints.maxHeight < constraints.maxWidth
                ? constraints.maxHeight
                : constraints.maxWidth;
            final avatarSize = shorterSide * 0.35;

            final avatars =
                calculateCircleCoordinates(numberOfPlayers, avatarSize)
                  ..add(
                    Align(
                      alignment: const Alignment(0, 0.2),
                      child: SizedBox(
                        height: avatarSize * 0.8,
                        width: avatarSize * 0.8,
                        child: const GameInfo(),
                      ),
                    ),
                  );

            return Container(
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
              child: Stack(children: avatars),
            );
          },
        );
      },
    );
  }
}
