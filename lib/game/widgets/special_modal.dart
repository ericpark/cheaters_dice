import 'package:cheaters_dice/auth/auth.dart';
import 'package:cheaters_dice/game/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class SpecialModal extends StatelessWidget {
  const SpecialModal({super.key});

  static const _pagePadding = 16.0;
  static const _pageBreakpoint = 500.0;
  static const _buttonHeight = 50.0;
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
                      child: Center(child: Text('SPOT ON')),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        topBarTitle: Text('Cheats', style: textTheme.titleSmall),
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
            child: Container(),
          ),
        ),
      );
    }

    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        return FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Theme.of(context).primaryColor,
            side: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
          onPressed: () {
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
              maxDialogWidth: 560,
              minDialogWidth: 200,
              minPageHeight: 0,
              maxPageHeight: 0.9,
            );
          },
          child: const Text('SPECIAL'),
        );
      },
    );
  }
}
