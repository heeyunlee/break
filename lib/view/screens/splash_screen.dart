import 'package:flutter/material.dart';
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'logo',
              child: Image.asset(
                'assets/logos/break_icon.png',
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
