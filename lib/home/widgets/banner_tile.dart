import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class BannerTile extends StatelessWidget {
  const BannerTile({super.key});

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
      fontSize: 50,
      fontFamily: 'Horizon',
      color: Colors.white,
    );

    return Card(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.only(left: 10, right: 10, top: 15),
      child: SizedBox(
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Image.asset(
              'assets/home/introduction_background.jpg',
              height: double.infinity,
              width: double.infinity,
              repeat: ImageRepeat.repeat,
            ),
            Container(color: Colors.black87.withOpacity(0.5)),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      AnimatedTextKit(
                        repeatForever: true,
                        animatedTexts: [
                          ColorizeAnimatedText(
                            'Cheaters Dice',
                            textStyle: colorizeTextStyle,
                            colors: colorizeColors,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: 80,
                    child: DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 35,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 7,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      child: AnimatedTextKit(
                        repeatForever: true,
                        animatedTexts: [
                          FlickerAnimatedText('LYING IS AN ART'),
                          FlickerAnimatedText('CHEATING IS A SKILL'),
                          FlickerAnimatedText('LET THE GAMES BEGIN'),
                        ],
                      ),
                    ),
                  ),
                  //const AnimatedTextWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedTextWidget extends StatelessWidget {
  const AnimatedTextWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Row(
        children: <Widget>[
          const SizedBox(width: 20, height: 100),
          const Center(
            child: Text(
              '',
              style: TextStyle(fontSize: 43, color: Colors.white),
            ),
          ),
          const SizedBox(width: 20, height: 100),
          DefaultTextStyle(
            style: const TextStyle(
              fontSize: 40,
              fontFamily: 'Horizon',
            ),
            child: AnimatedTextKit(
              repeatForever: true,
              animatedTexts: [
                RotateAnimatedText('ROLL'),
                RotateAnimatedText('BID'),
                RotateAnimatedText('CHEAT'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
