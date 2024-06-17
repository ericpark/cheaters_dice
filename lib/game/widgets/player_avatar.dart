import 'package:cached_network_image/cached_network_image.dart';
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
                    //backgroundColor: Colors.blue,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://firebasestorage.googleapis.com/v0/b/cheaters-dice.appspot.com/o/aussie.jpg?alt=media&token=090a5254-2ca9-4271-8f18-5bf0c73094a8',
                        placeholder: (context, url) =>
                            const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
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
