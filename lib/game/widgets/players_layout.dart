import 'package:cheaters_dice/game/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayersLayout extends StatefulWidget {
  const PlayersLayout({
    required this.players,
    this.activePlayerId = '',
    super.key,
  });

  /// A list of other players in the game in order of play.
  /// This should not include the current player.
  final List<Player> players;
  final String activePlayerId;

  @override
  State<PlayersLayout> createState() => _PlayersLayoutState();
}

class _PlayersLayoutState extends State<PlayersLayout> {
  @override
  Widget build(BuildContext context) {
    final numberOfPlayers = widget.players.length;
    const infoWidget = GameInfo();

    var showBottomRow = true;
    var topChildren = <Widget>[
      Flexible(child: Container()),
      const Expanded(child: SizedBox(width: 1)),
      const Expanded(child: SizedBox(width: 1)),
      const Expanded(child: SizedBox(width: 1)),
      Flexible(child: Container()),
    ];
    var middleChildren = <Widget>[
      const Expanded(child: SizedBox(width: 1)),
      const Expanded(child: infoWidget),
      const Expanded(child: SizedBox(width: 1)),
    ];
    var bottomChildren = <Widget>[
      const Expanded(child: SizedBox(width: 1)),
      const Expanded(child: infoWidget),
      const Expanded(child: SizedBox(width: 1)),
    ];

    switch (numberOfPlayers) {
      case 0:
        break; // Shouldn't play with 1 player
      case 1:
        topChildren = [
          Flexible(child: Container()),
          Expanded(
            child: PlayerAvatar(
              player: widget.players[0],
              active: widget.players[0].id == widget.activePlayerId,
            ),
          ),
          Flexible(child: Container()),
        ];
        showBottomRow = false;
        bottomChildren = [];
      case 2:
        topChildren = [
          Expanded(
            child: PlayerAvatar(
              player: widget.players[0],
              active: widget.players[0].id == widget.activePlayerId,
            ),
          ),
          Expanded(
            child: PlayerAvatar(
              player: widget.players[1],
              active: widget.players[1].id == widget.activePlayerId,
            ),
          ),
        ];
        showBottomRow = false;
        bottomChildren = [];
      case 3:
        topChildren = [
          Flexible(child: Container()),
          Expanded(
            child: PlayerAvatar(
              player: widget.players[1],
              active: widget.players[1].id == widget.activePlayerId,
            ),
          ),
          Flexible(child: Container()),
        ];
        bottomChildren = [
          Expanded(
            child: PlayerAvatar(
              player: widget.players[0],
              active: widget.players[0].id == widget.activePlayerId,
            ),
          ),
          Flexible(child: Container()),
          Expanded(
            child: PlayerAvatar(
              player: widget.players[2],
              active: widget.players[2].id == widget.activePlayerId,
            ),
          ),
        ];
      case 4:
        topChildren = [
          Flexible(child: Container()),
          Expanded(
            flex: 2,
            child: PlayerAvatar(
              player: widget.players[1],
              active: widget.players[1].id == widget.activePlayerId,
            ),
          ),
          Expanded(
            flex: 2,
            child: PlayerAvatar(
              player: widget.players[2],
              active: widget.players[2].id == widget.activePlayerId,
            ),
          ),
          Flexible(child: Container()),
        ];
        middleChildren = [
          Expanded(
            child: PlayerAvatar(
              player: widget.players[0],
              active: widget.players[0].id == widget.activePlayerId,
            ),
          ),
          const Expanded(child: infoWidget),
          Expanded(
            child: PlayerAvatar(
              player: widget.players[3],
              active: widget.players[3].id == widget.activePlayerId,
            ),
          ),
        ];
        showBottomRow = false;
        bottomChildren = [];
      case 5:
        topChildren = [
          Flexible(child: Container()),
          Expanded(
            child: PlayerAvatar(
              player: widget.players[2],
              active: widget.players[2].id == widget.activePlayerId,
            ),
          ),
          Flexible(child: Container()),
        ];
        middleChildren = [
          Expanded(
            child: PlayerAvatar(
              player: widget.players[1],
              active: widget.players[1].id == widget.activePlayerId,
            ),
          ),
          const Expanded(child: infoWidget),
          Expanded(
            child: PlayerAvatar(
              player: widget.players[3],
              active: widget.players[3].id == widget.activePlayerId,
            ),
          ),
        ];
        bottomChildren = [
          Expanded(
            child: PlayerAvatar(
              player: widget.players[0],
              active: widget.players[0].id == widget.activePlayerId,
            ),
          ),
          Flexible(child: Container()),
          Expanded(
            child: PlayerAvatar(
              player: widget.players[4],
              active: widget.players[4].id == widget.activePlayerId,
            ),
          ),
        ];
    }

    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
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
                  children: topChildren,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: middleChildren,
                ),
              ),
            ),
            if (showBottomRow)
              Expanded(
                child: Flex(
                  mainAxisSize: MainAxisSize.min,
                  direction: Axis.horizontal,
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: bottomChildren,
                ),
              ),
          ],
        );
      },
    );
  }
}
