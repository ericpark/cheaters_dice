import 'package:cheaters_dice/game/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerDice extends StatefulWidget {
  const PlayerDice({required this.dice, required this.hasRolled, super.key});

  final bool hasRolled;
  final List<Die> dice;

  @override
  State<PlayerDice> createState() => _PlayerDiceState();
}

class _PlayerDiceState extends State<PlayerDice> with TickerProviderStateMixin {
  bool hasRolled = false;
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
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
    if (hasRolled != widget.hasRolled) {
      setState(() {
        hasRolled = widget.hasRolled;
      });
    }

    //if (!hasRolled) {
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
                    child: Dice(value: !hasRolled ? 0 : d.value),
                  ),
                )
                .toList(),
          ),
          if (!hasRolled)
            Positioned.fill(
              child: Align(
                child: ElevatedButton(
                  onPressed: () {
                    _controller.forward().then(
                          (value) => setState(() {
                            hasRolled = true;
                            context.read<GameBloc>().add(RolledDice());
                          }),
                        );
                  },
                  child: const Text('Roll Dice'),
                ),
              ),
            ),
        ],
      ),
    );
    //}

    /*return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.dice.map((d) => Dice(value: d.value)).toList(),
      ),
    );*/
  }
}
