import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view_models/preview_screen_model.dart';

class FirstPreviewWidget extends ConsumerWidget {
  const FirstPreviewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final model = ref.watch(previewScreenModelProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        VisibilityDetector(
          key: const Key('preview-widgets'),
          onVisibilityChanged: model.onVisibilityChanged,
          child: SizedBox(
            height: size.width,
            width: size.width,
            child: AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: model.currentWidget,
            ),
          ),
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
