import 'package:cheaters_dice/game/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayerActions extends StatelessWidget {
  const PlayerActions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        //Stub
        const currentUser = 'player_1';
        final isCurrentUser = (state.order.isNotEmpty
                ? state.order[state.turn % state.order.length]
                : '') ==
            currentUser;

        final bidsEqual = context
                .read<GameBloc>()
                .compareBids(state.currentBid, state.userBid!) ==
            0;
        final firstBid = state.currentBid.playerId == null;
        final canBid =
            (isCurrentUser && !bidsEqual) || (isCurrentUser && firstBid);
        final canLiar = state.currentBid.playerId != currentUser &&
            state.currentBid.playerId != null;
        final canSpotOn = isCurrentUser && bidsEqual;

        return Center(
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: FilledButton(
                        onPressed: canLiar
                            ? () => context
                                .read<GameBloc>()
                                .add(const PlayerSubmitLiarGameEvent())
                            : null,
                        child: const Text('LIAR'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: FilledButton(
                        onPressed: canSpotOn
                            ? () => context
                                .read<GameBloc>()
                                .add(const PlayerSubmitSpotOnGameEvent())
                            : null,
                        child: const Text('SPOT ON'),
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(child: BidButtons()),
              Expanded(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: FilledButton(
                        onPressed: canBid
                            ? () => context
                                .read<GameBloc>()
                                .add(const PlayerSubmitBidGameEvent())
                            : null,
                        child: const Text('BID'),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8),
                      child: FilledButton(
                        onPressed: null,
                        child: Text('SPECIAL'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class BidButtons extends StatelessWidget {
  const BidButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        //Stub
        const currentUser = 'player_1';
        final isCurrentUser = (state.order.isNotEmpty
                ? state.order[state.turn % state.order.length]
                : '') ==
            currentUser;

        final canIncrementNumber =
            isCurrentUser && state.userBid!.number < state.totalDice!;
        final canDecrementNumber = isCurrentUser &&
            state.userBid!.number - 1 >= state.currentBid.number;

        final canIncrementValue =
            isCurrentUser && context.read<GameBloc>().canIncrementBidValue();
        final canDecrementValue =
            isCurrentUser && context.read<GameBloc>().canDecrementBidValue();

        return Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: IconButton(
                      icon: const Icon(Icons.arrow_upward),
                      onPressed: canIncrementNumber
                          ? () => context.read<GameBloc>().add(
                                const PlayerUpdateUserBidGameEvent(
                                  bidPart: BidPart.number,
                                  bidType: BidUpdateType.increment,
                                ),
                              )
                          : null,
                    ),
                  ),
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Dice(value: state.userBid!.number),
                    ),
                  ),
                  Flexible(
                    child: IconButton(
                      icon: const Icon(Icons.arrow_downward),
                      onPressed: canDecrementNumber
                          ? () => context.read<GameBloc>().add(
                                const PlayerUpdateUserBidGameEvent(
                                  bidPart: BidPart.number,
                                  bidType: BidUpdateType.decrement,
                                ),
                              )
                          : null,
                    ),
                  ),
                ],
              ),
              const Text(' x '),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: IconButton(
                      icon: const Icon(Icons.arrow_upward),
                      onPressed: canIncrementValue
                          ? () => context.read<GameBloc>().add(
                                const PlayerUpdateUserBidGameEvent(
                                  bidPart: BidPart.value,
                                  bidType: BidUpdateType.increment,
                                ),
                              )
                          : null,
                    ),
                  ),
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Dice(value: state.userBid!.value),
                    ),
                  ),
                  Flexible(
                    child: IconButton(
                      icon: const Icon(Icons.arrow_downward),
                      onPressed: canDecrementValue
                          ? () => context.read<GameBloc>().add(
                                const PlayerUpdateUserBidGameEvent(
                                  bidPart: BidPart.value,
                                  bidType: BidUpdateType.decrement,
                                ),
                              )
                          : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
