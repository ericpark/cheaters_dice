import 'package:cheaters_dice/game/game.dart';
import 'package:cheaters_dice/game/widgets/player_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const GameView();
  }
}

class GameView extends StatelessWidget {
  const GameView({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(),
          body: SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 9,
                  child: SizedBox.expand(
                    child: Center(
                      child: PlayersLayout(
                        players: context.read<GameBloc>().playerOrder.isNotEmpty
                            ? context.read<GameBloc>().playerOrder
                            : [],
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 100),
                  child: Divider(),
                ),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: context
                            .read<GameBloc>()
                            .state
                            .players['player_1']!
                            .dice
                            .map((d) => Dice(value: d.value))
                            .toList(),
                      ),
                    ),
                  ),
                ),
                const Expanded(flex: 2, child: PlayerActions()),
              ],
            ),
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: () {
                  context.read<GameBloc>().add(
                        const PlayerUpdateUserBidGameEvent(
                          bidPart: BidPart.number,
                          bidType: BidUpdateType.increment,
                        ),
                      );
                  context.read<GameBloc>().add(
                        const PlayerSubmitBidGameEvent(),
                      );
                },
                child: const Icon(Icons.skip_next),
              ),
            ],
          ),
        );
      },
    );
  }
}
