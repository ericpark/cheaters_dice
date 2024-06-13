import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cheaters_dice/game/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayersLayout extends StatefulWidget {
  const PlayersLayout({required this.players, super.key});

  /// A list of other players in the game in order of play.
  /// This should not include the current player.
  final List<Player> players;

  @override
  State<PlayersLayout> createState() => _PlayersLayoutState();
}

class _PlayersLayoutState extends State<PlayersLayout> {
  bool showAnimation = false;

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
          Expanded(child: PlayerAvatar(player: widget.players[0])),
          Flexible(child: Container()),
        ];
        showBottomRow = false;
        bottomChildren = [];

      case 2:
        topChildren = [
          Expanded(child: PlayerAvatar(player: widget.players[0])),
          Expanded(child: PlayerAvatar(player: widget.players[1])),
        ];
        showBottomRow = false;
        bottomChildren = [];
      case 3:
        topChildren = [
          Flexible(child: Container()),
          Expanded(child: PlayerAvatar(player: widget.players[1])),
          Flexible(child: Container()),
        ];
        bottomChildren = [
          Expanded(child: PlayerAvatar(player: widget.players[0])),
          Flexible(child: Container()),
          Expanded(child: PlayerAvatar(player: widget.players[2])),
        ];
      case 4:
        topChildren = [
          Flexible(child: Container()),
          Expanded(flex: 2, child: PlayerAvatar(player: widget.players[1])),
          Expanded(flex: 2, child: PlayerAvatar(player: widget.players[2])),
          Flexible(child: Container()),
        ];
        middleChildren = [
          Expanded(child: PlayerAvatar(player: widget.players[0])),
          const Expanded(child: infoWidget),
          Expanded(child: PlayerAvatar(player: widget.players[3])),
        ];
        showBottomRow = false;
        bottomChildren = [];
      case 5:
        topChildren = [
          Flexible(child: Container()),
          Expanded(child: PlayerAvatar(player: widget.players[2])),
          Flexible(child: Container()),
        ];
        middleChildren = [
          Expanded(child: PlayerAvatar(player: widget.players[1])),
          const Expanded(child: infoWidget),
          Expanded(child: PlayerAvatar(player: widget.players[3])),
        ];
        bottomChildren = [
          Expanded(child: PlayerAvatar(player: widget.players[0])),
          Flexible(child: Container()),
          Expanded(child: PlayerAvatar(player: widget.players[4])),
        ];
    }

    return BlocConsumer<GameBloc, GameState>(
      listener: (context, state) {
        if (state.status == GameStatus.transitioning) {
          //print('transitioning');
          setState(() {
            showAnimation = true;
          });
          //print('transitioning completed');
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Stack(
            children: [
              Flex(
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
              ),
              Center(
                child: showAnimation
                    ? AnimatedTextKit(
                        totalRepeatCount: 1,
                        onFinished: () {
                          setState(() {
                            showAnimation = false;
                          });
                        },
                        animatedTexts: [
                          FadeAnimatedText(
                            'BID',
                            textStyle: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                            duration: const Duration(milliseconds: 3000),
                          ),
                          ScaleAnimatedText(
                            'CALLED YOU A LIAR',
                            textStyle: const TextStyle(
                              fontSize: 70,
                              fontFamily: 'Canterbury',
                            ),
                          ),
                        ],
                      )
                    : Container(),
              ),
            ],
          ),
        );
      },
    );
  }
}
