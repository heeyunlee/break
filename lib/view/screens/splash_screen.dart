import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:workout_player/styles/theme_colors.dart';
import 'package:workout_player/view_models/main_model.dart';
import 'package:workout_player/styles/text_styles.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.d('[SplashScreen] building...');

    return Scaffold(
      backgroundColor: ThemeColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'logo',
              child: SvgPicture.asset(
                'assets/svgs/break_logo.svg',
                width: 72,
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'break your fitness goals',
              style: TextStyles.subtitle1Menlo,
            ),
          ],
        ),
      ),
    );
  }
}
