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

  bool _showNoBid = false;
  bool _showPlayerActionDisplay = false;
  bool _showCurrentBid = true;
  bool _showRoundResult = false;
  bool _showTransitionMessage = false;

  String playerActionType = '-';
  String transitionMessage = 'NEW ROUND';
  String roundResultsMessage = '';
  int cardKeyValue = 0;

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

  Future<void> _playAnimationTurnEnd({bool shouldEndTurn = true}) async {
    try {
      // Show Challenge or Spot on
      setState(() {
        _showCurrentBid = false;
        _showPlayerActionDisplay = true;
        cardKeyValue += 1;
      });
      await Future<void>.delayed(_transitionDuration);

      // Show Current Bid
      setState(() {
        _showCurrentBid = true;
        _showPlayerActionDisplay = false;
        cardKeyValue += 1;
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
        _showCurrentBid = false;
        _showPlayerActionDisplay = true;
        cardKeyValue += 1;
      });
      await Future<void>.delayed(_transitionDuration);

      // Set result information and transition to it
      setState(() {
        _showPlayerActionDisplay = false;
        _showRoundResult = true;
        cardKeyValue += 1;
      });
      await Future<void>.delayed(_transitionDuration);

      // Show Dice animations in Player Avatars
      // This could be done by triggering the dice animation with a custom state
      // but that seems unnecessary for now.
      await Future<void>.delayed(_diceTransitionDuration);

      // Show Result
      setState(() {
        _showTransitionMessage = true;
        _showRoundResult = false;
        cardKeyValue += 1;
      });
      await Future<void>.delayed(_transitionDuration);

      // Hide the dice so the future values are not shared.
      await Future<void>.delayed(_diceTransitionDuration);

      // Show No Bids
      setState(() {
        _showTransitionMessage = false;
        _showCurrentBid = true;

        cardKeyValue += 1;
      });

      setState(() {
        if (!finished) {
          _showNoBid = true;
          //_showTransitionMessage = true;

          cardKeyValue += 1;
        } else {
          _showNoBid = false;
          _showTransitionMessage = true;
          transitionMessage = 'Returning back to lobby!';
          cardKeyValue += 1;
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
              if (state.lastAction != null) {
                final lastAction =
                    (state.lastAction?['type'] as String).toUpperCase();
                setState(() {
                  if (lastAction == 'CHALLENGE') {
                    playerActionType = 'LIAR';
                  } else if (lastAction == 'SPOT') {
                    playerActionType = 'SPOT ON';
                  } else {
                    playerActionType = lastAction;
                  }
                });
              }
              if (state.status == GameStatus.transitioning) {
                _playAnimationTurnEnd();
              }
              if (state.status == GameStatus.revealing) {
                if (state.lastAction != null) {
                  setState(() {
                    roundResultsMessage = state.actionResult ?? '';
                  });
                  _playEndRoundAnimation();
                }
              }
              if (state.status == GameStatus.finished) {
                if (state.lastAction != null) {
                  setState(() {
                    roundResultsMessage = state.actionResult ?? '';
                    transitionMessage = 'GAME OVER!';
                  });
                  _playEndRoundAnimation(finished: true);
                }
              }
            },
            builder: (context, state) {
              final showNoBid = state.currentBid.playerId == null &&
                  _showCurrentBid &&
                  state.status == GameStatus.playing;

              final showCurrentBid = state.currentBid.playerId != null &&
                  state.currentBid != const Bid(number: 1, value: 1) &&
                  _showCurrentBid;
              return Center(
                child: AnimatedSwitcherPlus.translationTop(
                  duration: _transitionDuration,
                  child: _GameInfoCard(
                    key: ValueKey(cardKeyValue),
                    test: cardKeyValue,
                    message: playerActionType,
                    currentBid: state.currentBid,
                    newRoundMessage: transitionMessage,
                    children: [
                      // NO BID
                      if (showNoBid) const _NoBids(),
                      // CURRENT BID
                      if (showCurrentBid)
                        _CurrentBidDisplay(currentBid: state.currentBid),

                      // PLAYER ACTION (BID, LIAR, SPOT ON)
                      if (_showPlayerActionDisplay)
                        _PlayerActionDisplay(message: playerActionType),

                      // ROUND RESULTS
                      if (_showRoundResult)
                        _RoundResultsWidget(
                          roundResultsMessage: roundResultsMessage,
                        ),

                      // ROUND MESSAGE
                      if (_showTransitionMessage)
                        _RoundResultsWidget(
                          roundResultsMessage: transitionMessage,
                        ),
                    ],
                  ),
                ),
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
    required this.message,
    required this.newRoundMessage,
    required this.currentBid,
    required this.children,
    super.key,
  });

  final int test;
  final String message;
  final String newRoundMessage;
  final Bid currentBid;
  final List<Widget> children;

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
            children: [...children],
          ),
        ),
      ),
    );
  }
}

class _NoBids extends StatelessWidget {
  const _NoBids();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8),
      child: Text('No Bids'),
    );
  }
}

class _PlayerActionDisplay extends StatelessWidget {
  const _PlayerActionDisplay({required this.message});

  final String message;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          message,
          style: const TextStyle(fontSize: 40),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _CurrentBidDisplay extends StatelessWidget {
  const _CurrentBidDisplay({required this.currentBid});

  final Bid currentBid;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const FittedBox(
          alignment: Alignment.bottomCenter,
          fit: BoxFit.scaleDown,
          child: Text('Current Bid:'),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: FittedBox(
            alignment: Alignment.topCenter,
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Dice(
                  value: currentBid.number,
                  isDie: false,
                ),
                Dice(
                  value: currentBid.value,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class _RoundResultsWidget extends StatelessWidget {
  const _RoundResultsWidget({required this.roundResultsMessage});

  final String roundResultsMessage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        roundResultsMessage,
        textAlign: TextAlign.center,
      ),
    );
  }
}
