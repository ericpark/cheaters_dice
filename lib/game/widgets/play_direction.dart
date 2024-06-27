import 'package:flutter/material.dart';

class PlayDirection extends StatelessWidget {
  const PlayDirection({required this.clockwise, super.key});

  final bool clockwise;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          border: Border.all(width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        height: 30,
        width: 100,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FittedBox(fit: BoxFit.scaleDown, child: Text('Direction')),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Icon(
                clockwise ? Icons.rotate_right_sharp : Icons.rotate_left_sharp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
