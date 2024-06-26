import 'package:cheaters_dice/auth/auth.dart';
import 'package:cheaters_dice/constants.dart';
import 'package:cheaters_dice/game/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class BidModal extends StatelessWidget {
  const BidModal({super.key});

  static const _pagePadding = 16.0;
  static const _pageBreakpoint = AppConstants.modalBreakpoint;
  static const _buttonHeight = AppConstants.buttonHeight;
  static const _bottomPaddingForButton = 66.0;

  @override
  Widget build(BuildContext context) {
    SliverWoltModalSheetPage bidPage(
      BuildContext modalSheetContext,
      TextTheme textTheme,
    ) {
      return WoltModalSheetPage(
        hasSabGradient: false,
        stickyActionBar: Padding(
          padding: const EdgeInsets.all(_pagePadding),
          child: BlocBuilder<GameBloc, GameState>(
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
              final canBid = ((isCurrentUser && !bidsEqual) ||
                      (isCurrentUser && firstBid)) &&
                  state.status == GameStatus.playing;
              return Column(
                children: [
                  ElevatedButton(
                    onPressed: canBid
                        ? () {
                            context
                                .read<GameBloc>()
                                .add(const PlayerSubmitBidGameEvent());
                            Navigator.of(context).pop();
                          }
                        : null,
                    child: const SizedBox(
                      height: _buttonHeight,
                      width: double.infinity,
                      child: Center(child: Text('Submit Bid')),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        topBarTitle: Text('Place a Bid', style: textTheme.titleSmall),
        isTopBarLayerAlwaysVisible: true,
        trailingNavBarWidget: IconButton(
          padding: const EdgeInsets.all(_pagePadding),
          icon: const Icon(Icons.close),
          onPressed: Navigator.of(modalSheetContext).pop,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            _pagePadding,
            _pagePadding,
            _pagePadding,
            _bottomPaddingForButton,
          ),
          child: SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.3,
            child: const _BidButtons(),
          ),
        ),
      );
    }

    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        final currentUser = context.read<AuthCubit>().state.user?.id;
        final isCurrentUser = (state.order.isNotEmpty
                ? state.order[state.turn % state.order.length]
                : '') ==
            currentUser;

        return FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Theme.of(context).primaryColor,
            side: BorderSide(
              color:
                  isCurrentUser ? Theme.of(context).primaryColor : Colors.grey,
              width: 2,
            ),
          ),
          onPressed: isCurrentUser && state.status == GameStatus.playing
              ? () {
                  WoltModalSheet.show<void>(
                    context: context,
                    pageListBuilder: (modalSheetContext) {
                      final textTheme = Theme.of(context).textTheme;
                      return [
                        bidPage(modalSheetContext, textTheme),
                      ];
                    },
                    modalTypeBuilder: (context) {
                      final size = MediaQuery.sizeOf(context).width;
                      if (size < _pageBreakpoint) {
                        return WoltModalType.bottomSheet;
                      } else {
                        return WoltModalType.dialog;
                      }
                    },
                    onModalDismissedWithBarrierTap: () {
                      debugPrint('Closed modal sheet with barrier tap');
                      Navigator.of(context).pop();
                    },
                    maxDialogWidth: AppConstants.maxDialogWidth,
                    minDialogWidth: AppConstants.minDialogWidth,
                    minPageHeight: AppConstants.minPageHeight,
                    maxPageHeight: AppConstants.maxPageHeight,
                  );
                }
              : null,
          child: const Text('BID'),
        );
      },
    );
  }
}

class _BidButtons extends StatelessWidget {
  const _BidButtons();

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
                  Flexible(
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
                  Flexible(
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
