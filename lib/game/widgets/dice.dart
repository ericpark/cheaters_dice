import 'package:flutter/material.dart';

class Dice extends StatelessWidget {
  const Dice({required this.value, this.length = 90, super.key});
  final int value;
  final double length;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        width: length,
        height: length,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 2),
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
}
