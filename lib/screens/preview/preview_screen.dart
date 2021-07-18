import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/screens/preview/preview_screen_model.dart';
import 'package:workout_player/screens/sign_in/sign_in_screen.dart';
import 'package:workout_player/styles/text_styles.dart';

import '../../styles/constants.dart';
import 'widgets/blurred_background_preview_widget.dart';

class PreviewScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final model = watch(previewScreenModelProvider);

    logger.d('Preview Screen building...');

    final size = MediaQuery.of(context).size;

    return Scaffold(
      key: PreviewScreenModel.previewScreenNavigatorKey,
      extendBodyBehindAppBar: true,
      backgroundColor: kBackgroundColor,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          BlurredBackgroundPreviewWidget(),
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: size.height / 20),
                Hero(
                  tag: 'logo',
                  child: SvgPicture.asset(
                    'assets/svgs/herakles_icon.svg',
                    height: 40,
                    width: 40,
                  ),
                ),
                SizedBox(height: size.height / 20),
                VisibilityDetector(
                  key: Key('preview-widgets'),
                  onVisibilityChanged: model.onVisibilityChanged,
                  child: SizedBox(
                    height: size.width,
                    width: size.width,
                    child: AnimatedSwitcher(
                      duration: Duration(seconds: 1),
                      transitionBuilder: (child, animation) {
                        return FadeTransition(opacity: animation, child: child);
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
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(size.width / 2, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: BorderSide(width: 1.5, color: kPrimaryColor),
                    ),
                    onPressed: () => SignInScreen.show(context),
                    child: Text(
                      S.current.getStarted,
                      style: TextStyles.button1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
