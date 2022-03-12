import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:workout_player/view/preview/widgets/blurred_background_preview_widget.dart';
import 'package:workout_player/view/preview/widgets/first_preview_widget.dart';
import 'package:workout_player/view/preview/widgets/gradient_background.dart';
import 'package:workout_player/view/preview/widgets/preview_logo_widget.dart';
import 'package:workout_player/view/preview/widgets/second_preview_widget.dart';
import 'package:workout_player/view/preview/widgets/show_sign_in_screen_button.dart';
import 'package:workout_player/view/preview/widgets/third_preview_widget.dart';

import 'package:workout_player/view_models/preview_screen_model.dart';

class PreviewScreen extends ConsumerStatefulWidget {
  const PreviewScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends ConsumerState<PreviewScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(previewScreenModelProvider).init();
  }

  @override
  void dispose() {
    ref.read(previewScreenModelProvider).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          const BlurredBackgroundPreviewWidget(),
          PageView(
            controller: ref.read(previewScreenModelProvider).pageController,
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
                      ref.read(previewScreenModelProvider).pageController,
                  count: 3,
                  effect: WormEffect(
                    dotColor: theme.colorScheme.primary.withOpacity(0.24),
                    activeDotColor: theme.colorScheme.primary,
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
