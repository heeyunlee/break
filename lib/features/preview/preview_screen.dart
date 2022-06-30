import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/providers.dart' show previewScreenState;
import 'package:workout_player/routes/app_routes.dart';
import 'package:workout_player/utils/assets.dart';
import 'package:workout_player/features/preview/widgets/first_preview_widget.dart';
import 'package:workout_player/features/preview/widgets/gradient_background.dart';
import 'package:workout_player/features/preview/widgets/preview_logo_widget.dart';
import 'package:workout_player/features/preview/widgets/second_preview_widget.dart';
import 'package:workout_player/features/preview/widgets/third_preview_widget.dart';
import 'package:workout_player/features/widgets/buttons/break_elevated_button.dart';
import 'package:workout_player/widgets/widgets.dart';

class PreviewScreen extends ConsumerStatefulWidget {
  const PreviewScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PreviewScreen> createState() => _PreviewState();
}

class _PreviewState extends ConsumerState<PreviewScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _pageController.addListener(() {
      ref.read(previewScreenState).currentPageIndex =
          _pageController.page?.round() ?? 0;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    // ref.read(previewScreenState).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final model = ref.watch(previewScreenState);

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          BlurredImage(
            // imageProvider: Assets.backgroundImageProviders[2],
            imageProvider: AdaptiveCachedNetworkImage.provider(
              context,
              imageUrl: Assets.bgURL[2],
            ),
          ),
          PageView(
            controller: _pageController,
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
                  controller: _pageController,
                  count: 3,
                  effect: WormEffect(
                    dotColor: theme.colorScheme.primary.withOpacity(0.24),
                    activeDotColor: theme.colorScheme.primary,
                    dotHeight: 8,
                    dotWidth: 8,
                    spacing: 12,
                  ),
                ),
                const SizedBox(height: 24),
                BreakElevatedButton(
                  color: theme.primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  onPressed: () async {
                    final shouldShowSignInScreen = await model.onPressed();

                    if (!mounted) return;

                    if (shouldShowSignInScreen) {
                      context.goNamed(AppRoutes.signIn.name);
                    } else {
                      _pageController.animateToPage(
                        model.currentPageIndex,
                        curve: Curves.linear,
                        duration: const Duration(milliseconds: 300),
                      );
                    }
                  },
                  child: SizedBox(
                    width: size.width - 64,
                    height: 48,
                    child: Center(
                      child: Text(
                        (model.currentPageIndex == 2)
                            ? S.current.getStarted
                            : S.current.next.toUpperCase(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).padding.bottom),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
