import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cheaters_dice/game/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PlayersContainer extends StatefulWidget {
  const PlayersContainer({
    required this.players,
    this.activePlayerId = '',
    super.key,
  });

  /// A list of other players in the game in order of play.
  /// This should not include the current player.
  final List<Player> players;
  final String activePlayerId;

  @override
  State<PlayersContainer> createState() => _PlayersContainerState();
}

class _PlayersContainerState extends State<PlayersContainer>
    with TickerProviderStateMixin {
  //bool showAnimation = false;
  //bool gameIsFinished = false;
  String message = '-';
  Widget animationWidget = Container();
  late AnimationController animation;
  //late Animation<double> _fadeInFadeOut;
  //bool _showFirstChild = true;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      reverseDuration: const Duration(seconds: 3),
    );
    //_fadeInFadeOut = Tween<double>(begin: 0, end: 1).animate(animation);
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }
/*
  void runAnimation(String? message) {
    setState(() {
      this.message = message ?? this.message;
    });

    _playAnimation();
  }

  Future<void> _playAnimation() async {
    try {
      await animation.forward();
      setState(() {
        _showFirstChild = !_showFirstChild;
      });
      await Future<void>.delayed(const Duration(seconds: 3));
      await animation.reverse();
      context.read<GameBloc>().add(TurnCompleted());
    } on TickerCanceled {
      // The animation got canceled, probably because it was disposed of.
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameBloc, GameState>(
      listener: (context, state) {
        /*if (state.status == GameStatus.transitioning) {
          setState(() {
            if (state.lastAction != null) {
              runAnimation((state.lastAction!['type'] as String).toUpperCase());
            }
          });
          }*/
        if (state.status == GameStatus.finished) {
          final winner = state.players[state.winner!]!.name ??
              state.players[state.winner!]!.id;
          setState(() {
            animationWidget = AnimatedTextKit(
              totalRepeatCount: 1,
              onFinished: () {
                setState(() {
                  animationWidget = Container();
                  context.go('/lobby/${state.lobbyId}');
                  context.read<GameBloc>().add(GameCompleted());
                });
              },
              animatedTexts: [
                /* FadeAnimatedText(
                  (state.lastAction!['type'] as String).toUpperCase(),
                  textStyle: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  duration: const Duration(milliseconds: 3000),
                ),*/
                FadeAnimatedText(
                  'GAME OVER!'.toUpperCase(),
                  textStyle: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  duration: const Duration(milliseconds: 3000),
                ),
                ScaleAnimatedText(
                  'WINNER: $winner'.toUpperCase(),
                  textStyle: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  duration: const Duration(milliseconds: 5000),
                ),
              ],
            );
          });
        }
      },
      builder: (context, state) {
        return SafeArea(
          bottom: false,
          child: Stack(
            children: [
              PlayersLayout(
                players: widget.players,
                activePlayerId: widget.activePlayerId,
              ),
              Center(child: animationWidget),
              /*Center(
                child: AnimatedSwitcherPlus.translationTop(
                  duration: const Duration(milliseconds: 3000),
                  child: _showFirstChild
                      ? FadeTransition(
                          opacity: _fadeInFadeOut,
                          child: Card(
                            key: const ValueKey(0),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.height * 0.3,
                              child: Center(
                                child: Text(
                                  message,
                                  style: const TextStyle(fontSize: 40),
                                ),
                              ),
                            ),
                          ),
                        )
                      : FadeTransition(
                          opacity: _fadeInFadeOut,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.height * 0.3,
                            child: const GameInfo(
                              key: ValueKey(1),
                            ),
                          ),
                        ),
                ),
              ),*/
            ],
          ),
        );
      },
    );
  }
}
