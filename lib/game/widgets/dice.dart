import 'package:dice_icons/dice_icons.dart';
import 'package:flutter/material.dart';

class Dice extends StatelessWidget {
  const Dice({
    required this.value,
    this.length = 90,
    this.isDie = true,
    super.key,
  });

  final int value;
  final double length;
  final bool isDie;

  @override
  Widget build(BuildContext context) {
    if (!isDie) {
      return Padding(
        padding: EdgeInsets.zero,
        child: Container(
          width: length,
          height: length,
          decoration: BoxDecoration(
            border: Border.all(width: 2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(
              '$value',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    }
    var icon = DiceIcons.dice0;

    switch (value) {
      case 1:
        icon = DiceIcons.dice0;
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

    return Center(
      child: Icon(
        icon,
        size: length + 2,
      ),
    );
  }
}
