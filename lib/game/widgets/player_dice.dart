import 'package:cheaters_dice/constants.dart';
import 'package:cheaters_dice/game/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerDice extends StatefulWidget {
  const PlayerDice({
    required this.dice,
    required this.hasRolled,
    required this.reveal,
    super.key,
  });

  final bool hasRolled;
  final List<Die> dice;
  final bool reveal;

  @override
  State<PlayerDice> createState() => _PlayerDiceState();
}

class _PlayerDiceState extends State<PlayerDice> with TickerProviderStateMixin {
  bool hasRolled = false;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: AppConstants.diceRollDuration),
    vsync: this,
  );

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticInOut,
  );

  @override
  void initState() {
    hasRolled = widget.hasRolled;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if dice was already rolled but the widget was rebuilt, do not reroll.
    if (hasRolled != widget.hasRolled) {
      setState(() {
        hasRolled = widget.hasRolled;
      });
    }
    final previousBid = context.read<GameBloc>().state.lastBid;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.dice
                .map(
                  (d) => RotationTransition(
                    turns: _animation,
                    child: Dice(
                      value: !hasRolled ? 0 : d.value,
                      highlight: widget.reveal == true &&
                          previousBid != null &&
                          (d.value == previousBid.value || d.value == 1),
                    ), //0 = blank
                  ),
                )
                .toList(),
          ),
          if (!hasRolled)
            Positioned.fill(
              child: Align(
                child: ElevatedButton(
                  onPressed: () {
                    _controller.forward().then((value) {
                      setState(() {
                        hasRolled = true;
                      });
                      context.read<GameBloc>().add(DiceRollCompleted());
                      _controller.reset();
                    });
                  },
                  child: const Text('ROLL'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
