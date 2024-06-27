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
  String message = '-';
  Widget animationWidget = Container();
  late AnimationController animation;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      reverseDuration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameBloc, GameState>(
      listener: (context, state) {
        if (state.status == GameStatus.finished) {
          final winner = state.players[state.winner!]!.name ??
              state.players[state.winner!]!.id;

          Future<void>.delayed(const Duration(seconds: 5)).then(
            (value) => setState(() {
              animationWidget = AnimatedTextKit(
                totalRepeatCount: 1,
                onFinished: () {
                  setState(() {
                    animationWidget = Container();
                    context.go('/lobby/${state.lobbyId}');
                    context.read<GameBloc>().add(GameReset());
                  });
                },
                animatedTexts: [
                  FadeAnimatedText(
                    'GAME OVER!'.toUpperCase(),
                    textStyle: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    duration: const Duration(milliseconds: 5000),
                  ),
                  ScaleAnimatedText(
                    'WINNER: $winner'.toUpperCase(),
                    textStyle: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                    duration: const Duration(milliseconds: 8000),
                  ),
                ],
              );
            }),
          );
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
            ],
          ),
        );
      },
    );
  }
}
