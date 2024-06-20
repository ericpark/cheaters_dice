import 'package:cheaters_dice/auth/cubit/auth_cubit.dart';
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
        final currentUser = context.read<AuthCubit>().state.user?.id;
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
            ((isCurrentUser && !bidsEqual) || (isCurrentUser && firstBid)) &&
                state.status == GameStatus.playing;
        final canLiar = state.currentBid.playerId != currentUser &&
            state.currentBid.playerId != null &&
            state.status == GameStatus.playing;
        final canSpotOn =
            isCurrentUser && bidsEqual && state.status == GameStatus.playing;
        //print('MAKING HERE');

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(15),
          ),
          //margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisSize: MainAxisSize.min,
              children: [
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: SpecialModal(),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.red.shade300,
                        side: BorderSide(
                          color: canLiar ? Colors.red.shade300 : Colors.grey,
                          width: 2,
                        ),
                      ),
                      onPressed: canLiar
                          ? () => context
                              .read<GameBloc>()
                              .add(const PlayerSubmitLiarGameEvent())
                          : null,
                      child: const Text('LIAR'),
                    ),
                  ),
                ),
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: BidModal(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class PlayerActionsExpanded extends StatelessWidget {
  const PlayerActionsExpanded({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        final currentUser = context.read<AuthCubit>().state.user?.id;
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
            ((isCurrentUser && !bidsEqual) || (isCurrentUser && firstBid)) &&
                state.status == GameStatus.playing;
        final canLiar = state.currentBid.playerId != currentUser &&
            state.currentBid.playerId != null &&
            state.status == GameStatus.playing;
        final canSpotOn =
            isCurrentUser && bidsEqual && state.status == GameStatus.playing;
        //print('MAKING HERE');

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(15),
          ),
          //margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FilledButton(
                          onPressed: canLiar
                              ? () => context
                                  .read<GameBloc>()
                                  .add(const PlayerSubmitLiarGameEvent())
                              : null,
                          child: const Text('LIAR'),
                        ),
                        const FilledButton(
                          onPressed: null,
                          child: Text('SPECIAL'),
                        ),
                      ],
                    ),
                  ),
                ),
                const Flexible(
                  fit: FlexFit.tight,
                  child: BidButtons(),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FilledButton(
                          onPressed: canSpotOn
                              ? () => context
                                  .read<GameBloc>()
                                  .add(const PlayerSubmitSpotOnGameEvent())
                              : null,
                          child: const Text('SPOT ON'),
                        ),
                        FilledButton(
                          onPressed: canBid
                              ? () => context
                                  .read<GameBloc>()
                                  .add(const PlayerSubmitBidGameEvent())
                              : null,
                          child: const Text('BID'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
        final currentUser = context.read<AuthCubit>().state.user?.id;
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
                  Expanded(
                    child: IconButton(
                      padding: EdgeInsets.zero,
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
                      child: Dice(value: state.userBid!.number, isDie: false),
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      padding: EdgeInsets.zero,
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
                      padding: EdgeInsets.zero,
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
                      padding: EdgeInsets.zero,
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

class BidButtonsAlternative extends StatelessWidget {
  const BidButtonsAlternative({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        final currentUser = context.read<AuthCubit>().state.user?.id;
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

        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(''),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Dice(value: state.userBid!.number),
                  ),
                ),
                const Text('Number'),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: IconButton(
                    padding: EdgeInsets.zero,
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
                  child: IconButton(
                    padding: EdgeInsets.zero,
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
            //const Text(' x '),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(''),
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Dice(value: state.userBid!.value),
                  ),
                ),
                const Text('Value'),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: IconButton(
                    padding: EdgeInsets.zero,
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
                  child: IconButton(
                    padding: EdgeInsets.zero,
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
        );
      },
    );
  }
}
