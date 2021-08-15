import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:workout_player/view_models/main_model.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.d('[SplashScreen] building...');

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'logo',
              child: SvgPicture.asset(
                'assets/svgs/herakles_icon.svg',
                width: 72,
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Herakles: Workout Player',
              style: TextStyles.subtitle1_menlo,
            ),
          ],
        ),
      ),
    );
  }
}
