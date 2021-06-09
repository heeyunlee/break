import 'package:flutter/material.dart';
import 'package:workout_player/constants.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Herakles', style: kHeadline3Menlo),
            const SizedBox(height: 8),
            const Text(
              'wokrout. share. and gain.',
              style: kSubtitle2Menlo,
            ),
            const SizedBox(height: 104),
          ],
        ),
      ),
      // body: Center(
      //   child: Image.asset(
      //     'assets/logos/playerh_logo.png',
      //     height: 150,
      //     width: 150,
      //   ),
      // ),
    );
  }
}
