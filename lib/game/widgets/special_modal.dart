import 'package:cheaters_dice/auth/auth.dart';
import 'package:cheaters_dice/constants.dart';
import 'package:cheaters_dice/game/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class SpecialModal extends StatelessWidget {
  const SpecialModal({super.key});

  static const _pagePadding = AppConstants.pagePadding;
  static const _pageBreakpoint = AppConstants.modalBreakpoint;
  static const _buttonHeight = AppConstants.buttonHeight;

  static final buttonCarouselController = CarouselController();

  void onPressed(BuildContext context) {
    context.read<GameBloc>().add(const PlayerSubmitSpotOnGameEvent());
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    SliverWoltModalSheetPage bidPage(
      BuildContext modalSheetContext,
      TextTheme textTheme,
    ) {
      const standardPadding = EdgeInsets.fromLTRB(
        _pagePadding,
        _pagePadding,
        _pagePadding,
        _pagePadding,
      );
      return WoltModalSheetPage(
        hasSabGradient: false,
        topBarTitle: Text('Cheats 👀', style: textTheme.titleSmall),
        isTopBarLayerAlwaysVisible: true,
        trailingNavBarWidget: IconButton(
          padding: const EdgeInsets.all(_pagePadding),
          icon: const Icon(Icons.close),
          onPressed: Navigator.of(modalSheetContext).pop,
        ),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.3,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              0,
              _pagePadding,
              0,
              _pagePadding,
            ),
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

                final canSpotOn = isCurrentUser &&
                    bidsEqual &&
                    state.status == GameStatus.playing;
                return ExpandableCarousel(
                  options: CarouselOptions(
                    showIndicator: false,
                  ),
                  items: [1].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.28,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Padding(
                                padding: standardPadding,
                                child: SizedBox(
                                  height: _buttonHeight,
                                  width: double.infinity,
                                  child: Center(child: Text('Spot On')),
                                ),
                              ),
                              const Expanded(
                                child: Text(AppConstants.spotOnDescription),
                              ),
                              Padding(
                                padding: standardPadding,
                                child: ElevatedButton(
                                  onPressed: canSpotOn
                                      ? () => onPressed(context)
                                      : null,
                                  child: const SizedBox(
                                    height: _buttonHeight,
                                    width: double.infinity,
                                    child: Center(child: Text('SPOT ON')),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ),
      );
    }

    return BlocBuilder<GameBloc, GameState>(
      builder: (context, state) {
        final disabled = state.status.isTransitioning;

        return FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Theme.of(context).primaryColor,
            side: BorderSide(
              color: disabled ? Colors.grey : Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
          onPressed: disabled
              ? null
              : () {
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
                },
          child: const Text('SPECIAL'),
        );
      },
    );
  }
}
