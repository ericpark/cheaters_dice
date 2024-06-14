import 'package:cheaters_dice/game/game.dart';
import 'package:flutter/material.dart';

class PlayerAvatar extends StatelessWidget {
  const PlayerAvatar({required this.player, this.active = false, super.key});

  final Player player;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Flex(
            mainAxisAlignment: MainAxisAlignment.center,
            direction: Axis.vertical,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: active ? Colors.green : Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(constraints.maxHeight),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: CircleAvatar(
                    radius: constraints.maxHeight * 0.90,
                    backgroundColor: Colors.blue,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        player.name.toString(),
                        style: const TextStyle(
                          fontSize: 48,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              //SizedBox(height: constraints.maxHeight * 0.05),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    player.dice.length,
                    (index) => Container(
                      width: constraints.maxHeight * 0.1,
                      height: constraints.maxHeight * 0.1,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius:
                            BorderRadius.circular(constraints.maxHeight * 0.02),
                      ),
                      margin: const EdgeInsets.all(4),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
