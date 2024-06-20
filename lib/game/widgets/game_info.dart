import 'package:cheaters_dice/game/game.dart';
import 'package:cheaters_dice/game/widgets/play_direction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameInfo extends StatelessWidget {
  const GameInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return BlocBuilder<GameBloc, GameState>(
            builder: (context, state) {
              return Flex(
                direction: Axis.vertical,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    margin: const EdgeInsets.all(8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 4),
                        if (state.currentBid != const Bid(number: 1, value: 1))
                          const FittedBox(
                            alignment: Alignment.bottomCenter,
                            fit: BoxFit.scaleDown,
                            child: Text('Current Bid:'),
                          ),
                        if (state.currentBid != const Bid(number: 1, value: 1))
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: FittedBox(
                              alignment: Alignment.topCenter,
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Dice(
                                    value: state.currentBid.number,
                                    isDie: false,
                                  ),
                                  Dice(value: state.currentBid.value),
                                ],
                              ),
                            ),
                          )
                        else
                          const Padding(
                            padding: EdgeInsets.all(20),
                            child: Text('No Bids'),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
