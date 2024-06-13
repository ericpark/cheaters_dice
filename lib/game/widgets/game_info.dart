import 'package:cheaters_dice/game/game.dart';
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
              final player = state.order.isNotEmpty
                  ? state.order[state.turn % state.order.length]
                  : 'waiting...';
              return (state.currentBid != const Bid(number: 1, value: 1))
                  ? Flex(
                      direction: Axis.vertical,
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Expanded(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        "$player's turn",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const FittedBox(
                                alignment: Alignment.bottomCenter,
                                fit: BoxFit.scaleDown,
                                child: Text('Current Bid:'),
                              ),
                              FittedBox(
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
                            ],
                          ),
                        ),
                      ],
                    )
                  : const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('No Bids'),
                    );
            },
          );
        },
      ),
    );
  }
}
