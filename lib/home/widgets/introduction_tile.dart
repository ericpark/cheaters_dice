import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cheaters_dice/constants.dart';
import 'package:cheaters_dice/home/home.dart';
import 'package:flutter/material.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class IntroductionTile extends StatelessWidget {
  const IntroductionTile({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final colorizeColors = [
      Colors.white,
      primaryColor,
      Colors.white,
      Colors.white,
    ];

    const colorizeTextStyle = TextStyle(
      fontSize: 25,
      fontFamily: 'Horizon',
    );

    return GestureDetector(
      onTap: () {
        WoltModalSheet.show<void>(
          context: context,
          pageListBuilder: (modalSheetContext) {
            final textTheme = Theme.of(context).textTheme;
            return [
              const RulesModal()
                  .setupPage(context, modalSheetContext, textTheme),
              const RulesModal()
                  .gamePlayPage(context, modalSheetContext, textTheme),
              const RulesModal()
                  .specialsPage(context, modalSheetContext, textTheme),
            ];
          },
          modalTypeBuilder: (context) {
            final size = MediaQuery.sizeOf(context).width;
            if (size < RulesModal.pageBreakpoint) {
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
      child: AbsorbPointer(
        child: Card(
          clipBehavior: Clip.antiAlias,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.7),
                  Theme.of(context).primaryColor.withOpacity(0.4),
                  Theme.of(context).primaryColor.withOpacity(0.1),
                ],
              ),
            ),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: AnimatedTextKit(
                              totalRepeatCount: 1,
                              animatedTexts: [
                                ColorizeAnimatedText(
                                  'Learn to play',
                                  textStyle: colorizeTextStyle,
                                  colors: colorizeColors,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
