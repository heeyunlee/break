import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/screens/preview/widgets/first_preview_widget.dart';
import 'package:workout_player/screens/preview/preview_screen_provider.dart';
import 'package:workout_player/screens/preview/widgets/third_preview_widget.dart';
import 'package:workout_player/screens/sign_in/sign_in_screen.dart';
import 'package:workout_player/screens/sign_in/sign_in_screen_model.dart';
import 'package:workout_player/services/main_provider.dart';
import 'package:workout_player/styles/button_styles.dart';

import '../../styles/constants.dart';
import 'widgets/second_preview_widget.dart';
import 'widgets/app_preview_widget.dart';

class PreviewScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    logger.d('Preview Screen building...');

    final model = watch(previewScreenNotifierProvider);

    final os = Platform.operatingSystem;
    final locale = Intl.getCurrentLocale();
    final osLocale = os + locale;

    final size = MediaQuery.of(context).size;

    return Scaffold(
      key: previewScreenNavigatorKey,
      extendBodyBehindAppBar: true,
      backgroundColor: kBackgroundColor,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView(
            controller: model.pageController,
            onPageChanged: model.setCurrentPage,
            children: <Widget>[
              FirstPreviewWidget(),
              SecondPreviewWidget(),
              ThirdPreviewWidget(),

              // Workout Player
              AppPreviewWidget(
                imageRoot: previewImages[osLocale]![3],
                subtitle: S.current.WorkoutSeamlesslyWithWorkoutPlayer,
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: Platform.isIOS ? 38 : 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(width: 8),
                SizedBox(
                  width: 100,
                  child: TextButton(
                    style: ButtonStyles.textButton_1,
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      SignInScreen.show(context);
                    },
                    child: Text(S.current.skip),
                  ),
                ),
                SizedBox(
                  width: size.width - 216,
                  height: 48,
                  child: Center(
                    child: SmoothPageIndicator(
                      controller: model.pageController,
                      count: 4,
                      effect: const WormEffect(
                        activeDotColor: kPrimaryColor,
                        dotHeight: 9,
                        dotWidth: 9,
                        spacing: 10,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: TextButton(
                    style: ButtonStyles.textButton_google,
                    onPressed: () {
                      HapticFeedback.mediumImpact();

                      if (model.currentPage < 3) {
                        model.incrementCurrentPage();
                        model.pageController.animateToPage(
                          model.currentPage,
                          duration: Duration(milliseconds: 350),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        SignInScreen.show(context);
                      }
                    },
                    child: Text(
                      (model.currentPage == 3)
                          ? S.current.start
                          : S.current.next,
                      style: kButtonText,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
