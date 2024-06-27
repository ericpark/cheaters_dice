import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cheaters_dice/constants.dart';
import 'package:cheaters_dice/game/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerAvatar extends StatefulWidget {
  const PlayerAvatar({
    required this.player,
    this.active = false,
    super.key,
  });

  final Player player;
  final bool active;

  @override
  State<PlayerAvatar> createState() => _PlayerAvatarState();
}

class _PlayerAvatarState extends State<PlayerAvatar>
    with TickerProviderStateMixin {
  late AnimationController animation;
  final Duration _transitionDuration =
      const Duration(milliseconds: AppConstants.diceTransitionDuration);
  bool _shouldReveal = false;

  Color borderColor = Colors.black;

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

  Future<void> _playAnimation() async {
    try {
      setState(() {
        _shouldReveal = !_shouldReveal;
      });
      await Future<void>.delayed(_transitionDuration);

      await Future<void>.delayed(_transitionDuration);

      setState(() {
        _shouldReveal = !_shouldReveal;
      });
      await Future<void>.delayed(_transitionDuration);

      await Future<void>.delayed(_transitionDuration);
    } on TickerCanceled {
      // The animation got canceled, probably because it was disposed of.
    }
  }

  @override
  Widget build(BuildContext context) {
    borderColor = widget.active ? Colors.green : Colors.black;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return BlocConsumer<GameBloc, GameState>(
          listener: (context, state) {
            if (state.status == GameStatus.revealing) {
              if (state.lastAction != null) {
                /*final lastAction =
                    (state.lastAction!['type'] as String).toUpperCase();

                if (lastAction == 'CHALLENGE') {
                  _playAnimation();
                } else if (lastAction == 'SPOT') {
                  _playAnimation();
                }*/
              }
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(8),
              child: Flex(
                mainAxisAlignment: MainAxisAlignment.center,
                direction: Axis.vertical,
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: borderColor,
                            width: 2,
                          ),
                          borderRadius:
                              BorderRadius.circular(constraints.maxHeight),
                        ),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          maxRadius: constraints.maxWidth * 0.45,
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: widget.player.photo,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  AnimatedSwitcherPlus.translationTop(
                    duration: _transitionDuration,
                    child: !_shouldReveal
                        ? _EmptyPlayerDice(
                            key: const ValueKey('1'),
                            widget: widget,
                            constraints: constraints,
                          )
                        : _RevealedPlayerDice(
                            key: const ValueKey('1'),
                            widget: widget,
                            constraints: constraints,
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _RevealedPlayerDice extends StatelessWidget {
  const _RevealedPlayerDice({
    required this.widget,
    required this.constraints,
    super.key,
  });

  final PlayerAvatar widget;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final previousBid = context.read<GameBloc>().state.lastBid;

    return Row(
      key: key,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.player.dice.length,
        (index) => Container(
          margin: const EdgeInsets.all(4),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Dice(
              key: ValueKey(widget.player.dice[index].id),
              size: constraints.maxHeight * 0.1,
              value: widget.player.dice[index].value,
              highlight: previousBid != null &&
                  (widget.player.dice[index].value == previousBid.value ||
                      widget.player.dice[index].value == 1),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyPlayerDice extends StatelessWidget {
  const _EmptyPlayerDice({
    required this.widget,
    required this.constraints,
    super.key,
  });

  final PlayerAvatar widget;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: key,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.player.dice.length,
        (index) => Container(
          width: constraints.maxHeight * 0.1,
          height: constraints.maxHeight * 0.1,
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(
              constraints.maxHeight * 0.02,
            ),
          ),
          margin: const EdgeInsets.all(4),
        ),
      ),
    );
  }
}
