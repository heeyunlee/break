import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:workout_player/main_provider.dart';
import 'package:workout_player/screens/preview/preview_screen_model.dart';

import '../../styles/constants.dart';
import 'widgets/blurred_background_preview_widget.dart';
import 'widgets/get_started_widget.dart';
import 'widgets/logo_widget.dart';
import 'widgets/rotate_animated_text_widget.dart';

class PreviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    logger.d('Preview Screen building...');

    return Scaffold(
      key: PreviewScreenModel.previewScreenNavigatorKey,
      extendBodyBehindAppBar: true,
      backgroundColor: kBackgroundColor,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          const BlurredBackgroundPreviewWidget(),
          SafeArea(
            child: Column(
              children: [
                const LogoWidget(),
                Consumer(
                  builder: (context, watch, _) {
                    final size = MediaQuery.of(context).size;
                    final model = watch(previewScreenModelProvider);

                    return VisibilityDetector(
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
                    );
                  },
                ),
                const RotateAnimatedTextWidget(),
                const Spacer(),
                const GetStartedWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
