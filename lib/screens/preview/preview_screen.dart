import 'package:flutter/material.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/styles/constants.dart';

import 'widgets/blurred_background_preview_widget.dart';
import 'widgets/progress_tab_widgets_previews.dart';
import 'widgets/show_sign_in_screen_button.dart';
import 'widgets/logo_widget.dart';
import 'widgets/rotate_animated_text_widget.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.d('[PreviewScreen] building...');

    return Scaffold(
      backgroundColor: kBackgroundColor,
      extendBodyBehindAppBar: true,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          const BlurredBackgroundPreviewWidget(),
          SafeArea(
            child: Column(
              children: const [
                LogoWidget(),
                ProgressTabWidgetsPreviews(),
                RotateAnimatedTextWidget(),
                Spacer(),
                ShowSignInScreenButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
