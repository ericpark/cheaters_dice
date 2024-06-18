import 'package:cheaters_dice/auth/auth.dart';
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

class _PlayerDiceState extends State<PlayerDice> {
  bool hasRolled = false;

  @override
  void initState() {
    hasRolled = widget.hasRolled;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('hasRolled: $hasRolled widget: ${widget.hasRolled}  ');
    if (hasRolled != widget.hasRolled) {
      setState(() {
        hasRolled = widget.hasRolled;
      });
    }

    if (!hasRolled) {
      return Center(
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              hasRolled = true;
              context.read<GameBloc>().add(RolledDice());
            });
          },
          child: const Text('Roll Dice'),
        ),
      );
    }

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.dice.map((d) => Dice(value: d.value)).toList(),
      ),
    );
  }
}
