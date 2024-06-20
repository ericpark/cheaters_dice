import 'package:flutter/material.dart';

class PlayDirection extends StatelessWidget {
  const PlayDirection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Direction'),
          Icon(Icons.rotate_right_sharp),
        ],
      ),
    );
  }
}
