import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:cheaters_dice/game/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameInfo extends StatefulWidget {
  const GameInfo({super.key});

  @override
  State<GameInfo> createState() => _GameInfoState();
}

class _GameInfoState extends State<GameInfo> with TickerProviderStateMixin {
  String message = '-';
  Widget animationWidget = Container();
  late AnimationController animation;
  bool _showFirstChild = true;
  final Duration _transitionDuration = const Duration(milliseconds: 2500);

  bool _showRoundResult = false;
  String roundResultMessage = 'STARTING NEW ROUND';
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

  void runAnimation(String? message) {
    _playAnimation();
  }

  Future<void> _playAnimation({bool shouldEndTurn = true}) async {
    try {
      setState(() {
        _showFirstChild = !_showFirstChild;
      });
      await Future<void>.delayed(_transitionDuration);
      setState(() {
        _showFirstChild = !_showFirstChild;
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
        _showFirstChild = !_showFirstChild;
      });
      await Future<void>.delayed(_transitionDuration);
      setState(() {
        _showFirstChild = !_showFirstChild;
        _showRoundResult = !_showRoundResult;
      });
      // Show Dice
      await Future<void>.delayed(_transitionDuration);
      await Future<void>.delayed(_transitionDuration);
      setState(() {
        _showFirstChild = !_showFirstChild;
      });
      // Show Result
      await Future<void>.delayed(_transitionDuration);
      await Future<void>.delayed(_transitionDuration);

      // Show No Bids
      setState(() {
        _showRoundResult = !_showRoundResult;
        if (!finished) {
          _showFirstChild = !_showFirstChild;
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
                    if (lastAction == 'BID') {
                      message = lastAction;
                    }
                  });
                  if (lastAction == 'BID') {
                    _playAnimation();
                  } else {}
                }
              }
              if (state.status == GameStatus.revealing) {
                if (state.lastAction != null) {
                  final lastAction =
                      (state.lastAction!['type'] as String).toUpperCase();

                  setState(() {
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
                    roundResultMessage = 'GAME OVER!';

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
                    child: _showFirstChild
                        ? Card(
                            key: const ValueKey(0),
                            margin: const EdgeInsets.all(8),
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
                                          Dice(value: state.currentBid.value),
                                        ],
                                      ),
                                    ),
                                  )
                                else if (!_showRoundResult)
                                  const Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Text('No Bids'),
                                  )
                                else if (_showRoundResult)
                                  const Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Text('RESULTS'),
                                  ),
                              ],
                            ),
                          )
                        : Card(
                            key: const ValueKey(1),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 4),
                                  if (!_showRoundResult)
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: FittedBox(
                                        alignment: Alignment.topCenter,
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          message,
                                          style: const TextStyle(fontSize: 40),
                                        ),
                                      ),
                                    ),
                                  if (_showRoundResult)
                                    Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Text(roundResultMessage),
                                    ),
                                ],
                              ),
                            ),
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
