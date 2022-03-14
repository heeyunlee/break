import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:workout_player/providers.dart' show previewModelProvider;
import 'package:workout_player/utils/assets.dart';
import 'package:workout_player/view/preview/widgets/first_preview_widget.dart';
import 'package:workout_player/view/preview/widgets/gradient_background.dart';
import 'package:workout_player/view/preview/widgets/preview_logo_widget.dart';
import 'package:workout_player/view/preview/widgets/second_preview_widget.dart';
import 'package:workout_player/view/preview/widgets/show_sign_in_screen_button.dart';
import 'package:workout_player/view/preview/widgets/third_preview_widget.dart';
import 'package:workout_player/widgets/widgets.dart';

class Preview extends ConsumerStatefulWidget {
  const Preview({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PreviewState();
}

class _PreviewState extends ConsumerState<Preview> {
  @override
  void initState() {
    super.initState();
    ref.read(previewModelProvider).init();
  }

  @override
  void dispose() {
    ref.read(previewModelProvider).dispose();
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
          BlurredImage(
            imageProvider: Assets.backgroundImageProviders[2],
          ),
          PageView(
            controller: ref.read(previewModelProvider).pageController,
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
                  controller: ref.read(previewModelProvider).pageController,
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
