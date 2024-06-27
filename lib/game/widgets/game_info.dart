import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:cheaters_dice/constants.dart';
import 'package:cheaters_dice/game/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameInfo extends StatefulWidget {
  const GameInfo({super.key});

  @override
  State<GameInfo> createState() => _GameInfoState();
}

class _GameInfoState extends State<GameInfo> with TickerProviderStateMixin {
  Widget animationWidget = Container();
  late AnimationController animation;
  final Duration _transitionDuration =
      const Duration(milliseconds: AppConstants.gameInfoTransitionDuration);
  final Duration _diceTransitionDuration =
      const Duration(milliseconds: AppConstants.diceTransitionDuration);
  bool _showGameInfo = true;
  bool _showRoundResult = false;
  String message = '-';
  String newRoundMessage = 'NEW ROUND';
  String roundResultsMessage = '';
  int test = 0;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
      reverseDuration: _transitionDuration,
    );
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  Future<void> _playEndTurnAnimation({bool shouldEndTurn = true}) async {
    try {
      // Show Challenge or Spot on
      setState(() {
        _showGameInfo = !_showGameInfo;
        test += 1;
      });
      await Future<void>.delayed(_transitionDuration);

      // Show Current Bid
      setState(() {
        _showGameInfo = !_showGameInfo;
        test += 1;
      });

      await Future<void>.delayed(_transitionDuration).then(
        (_) => shouldEndTurn
            ? context.read<GameBloc>().add(TurnCompleted())
            : null,
      );
    } on TickerCanceled {
      // The animation got canceled, probably because it was disposed of.
    }
  }

  Future<void> _playEndRoundAnimation({bool finished = false}) async {
    try {
      // Show Challenge or Spot on
      setState(() {
        _showGameInfo = !_showGameInfo;
        test += 1;
      });
      await Future<void>.delayed(_transitionDuration);

      // Set result information and transition to it
      setState(() {
        _showGameInfo = !_showGameInfo;
        _showRoundResult = !_showRoundResult;
        test += 1;
      });
      await Future<void>.delayed(_transitionDuration);

      // Show Dice animations in Player Avatars
      // This could be done by triggering the dice animation with a custom state
      // but that seems unnecessary for now.
      await Future<void>.delayed(_diceTransitionDuration);

      // Show Result
      setState(() {
        _showGameInfo = !_showGameInfo;
        test += 1;
      });
      await Future<void>.delayed(_transitionDuration);

      // Hide the dice so the future values are not shared.
      await Future<void>.delayed(_diceTransitionDuration);

      // Show No Bids
      setState(() {
        _showRoundResult = !_showRoundResult;
        if (!finished) {
          _showGameInfo = !_showGameInfo;
        }
      });
      await Future<void>.delayed(_transitionDuration);
    } on TickerCanceled {
      // The animation got canceled, probably because it was disposed of.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return BlocConsumer<GameBloc, GameState>(
            listener: (context, state) {
              if (state.status == GameStatus.transitioning) {
                if (state.lastAction != null) {
                  final lastAction =
                      (state.lastAction!['type'] as String).toUpperCase();

                  setState(() {
                    message = lastAction;
                  });
                  _playEndTurnAnimation();
                }
              }
              if (state.status == GameStatus.revealing) {
                if (state.lastAction != null) {
                  final lastAction =
                      (state.lastAction!['type'] as String).toUpperCase();

                  setState(() {
                    roundResultsMessage = state.actionResult ?? 'RESULT';
                    if (lastAction == 'CHALLENGE') {
                      message = 'LIAR';
                    } else if (lastAction == 'SPOT') {
                      message = 'SPOT ON';
                    } else {
                      message = lastAction;
                    }
                  });
                  _playEndRoundAnimation();
                }
              }
              if (state.status == GameStatus.finished) {
                if (state.lastAction != null) {
                  final lastAction =
                      (state.lastAction!['type'] as String).toUpperCase();

                  setState(() {
                    newRoundMessage = 'GAME OVER!';

                    if (lastAction == 'CHALLENGE') {
                      message = 'LIAR';
                    } else if (lastAction == 'SPOT') {
                      message = 'SPOT ON';
                    } else {
                      message = lastAction;
                    }
                  });
                  _playEndRoundAnimation(finished: true);
                }
              }
            },
            builder: (context, state) {
              return Flex(
                direction: Axis.vertical,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedSwitcherPlus.translationTop(
                    duration: _transitionDuration,
                    child: _showGameInfo
                        ? Card(
                            key: ValueKey(test),
                            margin: const EdgeInsets.all(8),
                            child: AspectRatio(
                              aspectRatio: 1,
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 4),
                                    if (state.currentBid !=
                                        const Bid(number: 1, value: 1))
                                      const FittedBox(
                                        alignment: Alignment.bottomCenter,
                                        fit: BoxFit.scaleDown,
                                        child: Text('Current Bid:'),
                                      ),
                                    if (state.currentBid !=
                                        const Bid(number: 1, value: 1))
                                      Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: FittedBox(
                                          alignment: Alignment.topCenter,
                                          fit: BoxFit.scaleDown,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Dice(
                                                value: state.currentBid.number,
                                                isDie: false,
                                              ),
                                              Dice(
                                                value: state.currentBid.value,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    else if (!_showRoundResult)
                                      const _NoBids()
                                    else if (_showRoundResult)
                                      Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Text(roundResultsMessage),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : _GameInfoCard(
                            key: ValueKey(test),
                            test: test,
                            showRoundResult: _showRoundResult,
                            message: message,
                            newRoundMessage: newRoundMessage,
                          ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _GameInfoCard extends StatelessWidget {
  const _GameInfoCard({
    required this.test,
    required bool showRoundResult,
    required this.message,
    required this.newRoundMessage,
    super.key,
  }) : _showRoundResult = showRoundResult;

  final int test;
  final bool _showRoundResult;
  final String message;
  final String newRoundMessage;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: key,
      margin: const EdgeInsets.all(8),
      child: AspectRatio(
        aspectRatio: 1,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!_showRoundResult)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      message,
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                ),
              if (_showRoundResult)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(newRoundMessage),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoBids extends StatelessWidget {
  const _NoBids({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8),
      child: Text('No Bids'),
    );
  }
}
