import 'package:flutter/material.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.d('SplashScreen building...');

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Herakles', style: TextStyles.headline3_menlo),
            const SizedBox(height: 8),
            const Text(
              'wokrout. share. and gain.',
              style: TextStyles.subtitle2_menlo,
            ),
            const SizedBox(height: 104),
          ],
        ),
      ),
    );
  }
}
