import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/unit_of_mass.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view/progress/widgets/activity_ring.dart';

class FirstPreviewWidget extends ConsumerWidget {
  const FirstPreviewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // VisibilityDetector(
        //   key: const Key('preview-widgets'),
        //   onVisibilityChanged: model.onVisibilityChanged,
        //   child: SizedBox(
        //     height: size.width,
        //     width: size.width,
        //     child: AnimatedSwitcher(
        //       duration: const Duration(seconds: 1),
        //       transitionBuilder: (child, animation) {
        //         return FadeTransition(
        //           opacity: animation,
        //           child: child,
        //         );
        //       },
        //       child: model.currentWidget,
        //     ),
        //   ),
        // ),
        ActivityRing(
          muscleName: 'Chest',
          liftedWeights: 10000,
          weightGoal: 20000,
          consumedProtein: 75,
          proteinGoal: 150,
          unit: UnitOfMass.kilograms,
          height: size.width,
          width: size.width,
          cardColor: Colors.transparent,
          elevation: 0,
          onTap: () {},
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            height: size.height / 10,
            child: DefaultTextStyle(
              textAlign: TextAlign.center,
              style: TextStyles.body1Menlo,
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
        ),
      ],
    );
  }
}
