import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:workout_player/styles/theme_colors.dart';
import 'package:workout_player/view/widgets/preview/first_preview_widget.dart';
import 'package:workout_player/view/widgets/preview/second_preview_widget.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/main_model.dart';
import 'package:workout_player/view/widgets/preview/blurred_background_preview_widget.dart';
import 'package:workout_player/view/widgets/preview/show_sign_in_screen_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/view_models/preview_screen_model.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.d('[PreviewScreen] building...');

    context.read(previewScreenModelProvider).init();

    return Scaffold(
      backgroundColor: ThemeColors.background,
      extendBodyBehindAppBar: true,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          const BlurredBackgroundPreviewWidget(),
          PageView(
            controller: context.read(previewScreenModelProvider).pageController,
            children: const [
              FirstPreviewWidget(),
              SecondPreviewWidget(),
              ThirdPreviewWidget(),
            ],
          ),
          const GradientBackground(),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const PreviewLogoWidget(),
                const Spacer(),
                SmoothPageIndicator(
                  controller:
                      context.read(previewScreenModelProvider).pageController,
                  count: 3,
                  effect: const WormEffect(
                    dotColor: Colors.white24,
                    activeDotColor: ThemeColors.primary500,
                    dotHeight: 8,
                    dotWidth: 8,
                    spacing: 12,
                  ),
                ),
                const SizedBox(height: 8),
                const ShowSignInScreenButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
