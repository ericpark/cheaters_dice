import 'package:dice_icons/dice_icons.dart';
import 'package:flutter/material.dart';

class Dice extends StatelessWidget {
  const Dice({
    required this.value,
    this.size = 90,
    this.isDie = true,
    this.highlight = false,
    super.key,
  });

  final int value;
  final double size;
  final bool isDie;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    var icon = DiceIcons.dice0;

    switch (value) {
      case 1:
        icon = DiceIcons.dice1;
      case 2:
        icon = DiceIcons.dice2;
      case 3:
        icon = DiceIcons.dice3;
      case 4:
        icon = DiceIcons.dice4;
      case 5:
        icon = DiceIcons.dice5;
      case 6:
        icon = DiceIcons.dice6;
      default:
        icon = DiceIcons.dice0;
    }

    return Padding(
      padding: EdgeInsets.zero,
      child: Container(
        // This is done so the boxes line up when side by side. The die needs to
        // a bit bigger vs the standard number
        width: size + (!isDie ? 0 : 2),
        height: size + (!isDie ? 0 : 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size / 6.28),
          border: !isDie ? Border.all(width: 3) : null,
          color: highlight ? Theme.of(context).primaryColor : null,
        ),
        child: Center(
          child: !isDie
              ? Text(
                  '$value',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : Icon(
                  icon,
                  size: size + 2,
                  color: highlight ? Colors.white : Colors.black,
                ),
        ),
      ),
    );
  }
}
