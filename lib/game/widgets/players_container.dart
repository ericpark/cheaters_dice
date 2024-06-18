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

class _PlayersContainerState extends State<PlayersContainer> {
  //bool showAnimation = false;
  //bool gameIsFinished = false;
  Widget animationWidget = Container();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameBloc, GameState>(
      listener: (context, state) {
        if (state.status == GameStatus.transitioning) {
          setState(() {
            if (state.lastAction != null) {
              animationWidget = AnimatedTextKit(
                totalRepeatCount: 1,
                onFinished: () {
                  setState(() {
                    animationWidget = Container();
                    context.read<GameBloc>().add(TurnCompleted());
                  });
                },
                animatedTexts: [
                  FadeAnimatedText(
                    (state.lastAction!['type'] as String).toUpperCase(),
                    textStyle: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    duration: const Duration(milliseconds: 3000),
                  ),
                ],
              );
            }
          });
        }
        if (state.status == GameStatus.finished) {
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
                FadeAnimatedText(
                  (state.lastAction!['type'] as String).toUpperCase(),
                  textStyle: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  duration: const Duration(milliseconds: 3000),
                ),
                FadeAnimatedText(
                  'GAME OVER!'.toUpperCase(),
                  textStyle: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  duration: const Duration(milliseconds: 3000),
                ),
                ScaleAnimatedText(
                  'WINNER: ${state.winner!}'.toUpperCase(),
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
          child: Stack(
            children: [
              PlayersLayout(
                players: widget.players,
                activePlayerId: widget.activePlayerId,
              ),
              Center(child: animationWidget),
            ],
          ),
        );
      },
    );
  }
}
