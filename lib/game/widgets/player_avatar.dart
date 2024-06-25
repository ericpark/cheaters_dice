import 'package:animated_switcher_plus/animated_switcher_plus.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  final Duration _transitionDuration = const Duration(milliseconds: 5000);
  bool _shouldReveal = false;

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
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return BlocConsumer<GameBloc, GameState>(
          listener: (context, state) {
            if (state.status == GameStatus.transitioning) {
              if (state.lastAction != null) {
                final lastAction =
                    (state.lastAction!['type'] as String).toUpperCase();

                if (lastAction == 'CHALLENGE') {
                  _playAnimation();
                } else if (lastAction == 'SPOT ON') {
                  _playAnimation();
                }
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
                            color: widget.active ? Colors.green : Colors.black,
                            width: 2,
                          ),
                          borderRadius:
                              BorderRadius.circular(constraints.maxHeight),
                        ),
                        child: CircleAvatar(
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
                        ? Row(
                            key: const ValueKey('0'),
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
                          )
                        : Row(
                            key: const ValueKey('1'),
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              widget.player.dice.length,
                              (index) => Container(
                                margin: const EdgeInsets.all(4),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Dice(
                                    size: constraints.maxHeight * 0.1,
                                    value: widget.player.dice[index].value,
                                  ),
                                ),
                              ),
                            ),
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
