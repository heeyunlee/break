import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:workout_player/view/widgets/widgets.dart';

import 'package:workout_player/view_models/preview_screen_model.dart';

class PreviewScreen extends ConsumerWidget {
  const PreviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    ref.read(previewScreenModelProvider).init();

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
