import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view_models/main_model.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/view/widgets/preview/blurred_background_preview_widget.dart';
import 'package:workout_player/view/widgets/preview/progress_tab_widgets_previews.dart';
import 'package:workout_player/view/widgets/preview/show_sign_in_screen_button.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.d('[PreviewScreen] building...');

    final a = PageController();

    return Scaffold(
      backgroundColor: kBackgroundColor,
      extendBodyBehindAppBar: true,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          const BlurredBackgroundPreviewWidget(),
          PageView(
            controller: a,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  // PreviewLogoWidget(),
                  ProgressTabWidgetsPreviews(),
                  Text(
                    'Widgets',
                    style: TextStyles.body2,
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Widgets',
                    style: TextStyles.body2,
                  ),
                ],
              ),
              const Placeholder(),
            ],
          ),

          SafeArea(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SmoothPageIndicator(
                controller: a,
                count: 3,
                effect: const WormEffect(
                  dotColor: Colors.white24,
                  activeDotColor: kPrimaryColor,
                  dotHeight: 8,
                  dotWidth: 8,
                  spacing: 12,
                ),
              ),
              const SizedBox(height: 8),
              const ShowSignInScreenButton(),
            ],
          )),

          // SafeArea(
          //   child: Column(
          //     children: const [
          //       PreviewLogoWidget(),
          //       ProgressTabWidgetsPreviews(),
          //       RotateAnimatedTextWidget(),
          //       Spacer(),
          //       ShowSignInScreenButton(),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
