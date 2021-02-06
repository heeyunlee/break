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
      backgroundColor: BackgroundColor,
      body: Center(
        child: Image.asset(
          'assets/logos/playerh_logo.png',
          height: 150,
          width: 150,
        ),
      ),
    );
  }
}
