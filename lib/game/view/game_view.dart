import 'package:cheaters_dice/game/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class GameViewMobile extends StatelessWidget {
  const GameViewMobile({super.key});

  @override
  Widget build(BuildContext context) {
    print('making game view mobile');
    final temp = context.read<GameBloc>().playerOrder;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cheaters Dice'),
        leading: IconButton(
          onPressed: () {
            //context.read<GameBloc>().add(const GameQuitGameEvent());
            context.go('/');
          },
          icon: const Icon(Icons.close),
        ),
      ),
      body: ColoredBox(
        color: Colors.grey.shade200,
        child: BlocBuilder<GameBloc, GameState>(
          builder: (context, state) {
            return SafeArea(
              bottom: false,
              child: SizedBox.expand(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 8,
                      child: SizedBox.expand(
                        child: Center(
                          child: PlayersContainer(
                            activePlayerId:
                                state.order[state.turn % state.order.length],
                            players:
                                context.read<GameBloc>().playerOrder.isNotEmpty
                                    ? temp
                                    : [],
                          ),
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 2,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: PlayerDice(),
                      ),
                    ),
                    //const Divider(height: 8, endIndent: 50, indent: 50),
                    const Expanded(flex: 2, child: PlayerActions()),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8),
        child: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          mini: true,
          onPressed: () {
            context.read<GameBloc>().add(
                  const PlayerUpdateUserBidGameEvent(
                    bidPart: BidPart.number,
                    bidType: BidUpdateType.increment,
                  ),
                );
            context.read<GameBloc>().add(const PlayerSubmitBidGameEvent());
          },
          child: const Icon(Icons.settings),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}

class GameViewHorizontal extends StatelessWidget {
  const GameViewHorizontal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColoredBox(
        color: Colors.grey.shade400,
        child: SafeArea(
          bottom: false,
          child: SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 7,
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
                const Divider(height: 8, endIndent: 50, indent: 50),
                const Expanded(flex: 3, child: PlayerActions()),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8),
        child: FloatingActionButton(
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }
}
