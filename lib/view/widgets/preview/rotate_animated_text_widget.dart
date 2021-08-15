import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/text_styles.dart';

class RotateAnimatedTextWidget extends StatelessWidget {
  const RotateAnimatedTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: size.height / 10,
        child: DefaultTextStyle(
          textAlign: TextAlign.center,
          style: TextStyles.headline6,
          child: AnimatedTextKit(
            repeatForever: true,
            animatedTexts: [
              RotateAnimatedText(S.current.previewScreenMessage1),
              RotateAnimatedText(
                S.current.previewScreenMessage2,
                textAlign: TextAlign.center,
              ),
              RotateAnimatedText(
                S.current.previewScreenMessage3,
                textAlign: TextAlign.center,
              ),
              RotateAnimatedText(S.current.previewScreenMessage4),
            ],
          ),
        ),
      ),
    );
  }
}
