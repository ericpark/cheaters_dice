import 'package:cheaters_dice/constants.dart';
import 'package:cheaters_dice/game/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class RulesModal {
  const RulesModal();

  static const _pagePadding = AppConstants.pagePadding;
  static const pageBreakpoint = AppConstants.modalBreakpoint;
  static const _buttonHeight = AppConstants.buttonHeight;

  static final buttonCarouselController = CarouselController();

  void onPressed(BuildContext context, {required PlayerActionType action}) {
    Navigator.of(context).pop();
  }

  SliverWoltModalSheetPage setupPage(
    BuildContext context,
    BuildContext modalSheetContext,
    TextTheme textTheme,
  ) {
    return WoltModalSheetPage(
      hasSabGradient: false,
      stickyActionBar: Padding(
        padding: const EdgeInsets.all(_pagePadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            TextButton(
              onPressed: WoltModalSheet.of(modalSheetContext).showNext,
              child: const SizedBox(
                height: _buttonHeight,
                child: Center(child: Text('Next page')),
              ),
            ),
          ],
        ),
      ),
      topBarTitle: Text('Rules - Setup', style: textTheme.titleSmall),
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
          _pagePadding,
        ),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.7,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Objective:',
                  style: textTheme.headlineLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'To be the last player remaining with dice.',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  'Setup:',
                  style: textTheme.headlineLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  '''
- Each player starts with five six-sided dice and a dice cup.
- Players shake their dice in their cups and then turn the cups over onto the playing surface, keeping the dice hidden from the other players.''',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  'Game Play:',
                  style: textTheme.headlineLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  '''
- The first player makes an opening bid. A bid consists of a face value (1 through 6) and a quantity. For example, "three fives" means there are at least three dice showing the face value five.
- Play proceeds clockwise, with each player either raising the bid or challenging the previous bid.''',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  'Special Rules for Ones (Aces):',
                  style: textTheme.headlineLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  '''
- Ones are typically wild and can be counted as any face value when resolving a bid.
- Some variations of the game may treat ones as regular dice, not wild.''',
                  style: textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SliverWoltModalSheetPage gamePlayPage(
    BuildContext context,
    BuildContext modalSheetContext,
    TextTheme textTheme,
  ) {
    return WoltModalSheetPage(
      hasSabGradient: false,
      stickyActionBar: Padding(
        padding: const EdgeInsets.all(_pagePadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: WoltModalSheet.of(modalSheetContext).showPrevious,
              child: const SizedBox(
                height: _buttonHeight,
                child: Center(child: Text('Prev page')),
              ),
            ),
            TextButton(
              onPressed: WoltModalSheet.of(modalSheetContext).showNext,
              child: const SizedBox(
                height: _buttonHeight,
                child: Center(child: Text('Next page')),
              ),
            ),
          ],
        ),
      ),
      topBarTitle: Text('Game Play', style: textTheme.titleSmall),
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
          _pagePadding,
        ),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.7,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Game Play:',
                  style: textTheme.headlineLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  '''The first player makes an opening bid. A bid consists of a face value (1 through 6) and a quantity. For example, "three fives" means there are at least three dice showing the face value five. Play proceeds clockwise, with each player either raising the bid or challenging the previous bid.''',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  'Raising the Bid:',
                  style: textTheme.headlineLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  '''
- You can increase the quantity of the current face value (e.g., from "three fives" to "four fives").
- You can increase the face value while maintaining or increasing the quantity (e.g., from "three fives" to "three sixes").
- You can also bid a higher quantity and a higher face value (e.g., from "three fives" to "four sixes").''',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  'Challenging the Bid:',
                  style: textTheme.headlineLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  '''If you think the previous player's bid is too high (i.e., there aren't as many dice of the face value as they claim), you can challenge the bid by calling "Liar!"''',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  'Resolving a Challenge:',
                  style: textTheme.headlineLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  '''
- All players reveal their dice.
- Count the number of dice showing the face value of the current bid.
- If the bid is met or exceeded, the challenger loses one die.
- If the bid is not met, the bidder loses one die.''',
                  style: textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SliverWoltModalSheetPage specialsPage(
    BuildContext context,
    BuildContext modalSheetContext,
    TextTheme textTheme,
  ) {
    return WoltModalSheetPage(
      hasSabGradient: false,
      stickyActionBar: Padding(
        padding: const EdgeInsets.all(_pagePadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: WoltModalSheet.of(modalSheetContext).showPrevious,
              child: const SizedBox(
                height: _buttonHeight,
                child: Center(child: Text('Prev page')),
              ),
            ),
            TextButton(
              onPressed: Navigator.of(modalSheetContext).pop,
              child: const SizedBox(
                height: _buttonHeight,
                child: Center(child: Text('Done')),
              ),
            ),
          ],
        ),
      ),
      topBarTitle: Text('Setup', style: textTheme.titleSmall),
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
          _pagePadding,
        ),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.7,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Special Powers (Once per game):',
                  style: textTheme.headlineLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  '''
- Spot on: When a player calls "Spot On," the dice are revealed, and if the bid matches the exact quantity and face value of the dice present, the player who made the challenge wins and everyone else loses 1 die. If the bid does not match exactly, the player loses two dice.
- Skip: Skip yourself. Be careful, the last bid becomes yours!
- Reverse: REVERSE REVERSE. Be careful, the last bid becomes yours!''',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  'Optional Variations:',
                  style: textTheme.headlineLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  '''
- Single Die Showdown: When two players remain, they can enter a single die showdown, where they both reveal one die each round and bid based on that.
- Palafico: In some versions, when a player is down to their last die, they enter a special round called "Palafico," where bids must be exact.''',
                  style: textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
