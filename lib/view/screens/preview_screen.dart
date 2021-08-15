import 'package:flutter/material.dart';
import 'package:workout_player/view_models/main_model.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/view/widgets/preview/blurred_background_preview_widget.dart';
import 'package:workout_player/view/widgets/preview/logo_widget.dart';
import 'package:workout_player/view/widgets/preview/progress_tab_widgets_previews.dart';
import 'package:workout_player/view/widgets/preview/rotate_animated_text_widget.dart';
import 'package:workout_player/view/widgets/preview/show_sign_in_screen_button.dart';

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
