import 'package:firebase_auth/firebase_auth.dart' as fireAuth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../home.dart';
import 'auth_screen.dart';

class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Return either HomeScreen or AuthScreen
    return StreamBuilder(
      stream: fireAuth.FirebaseAuth.instance.authStateChanges(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.active) {
          final fireAuth.User user = userSnapshot.data;
          if (user == null) {
            return AuthScreen();
          }
          return HomeScreen();
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
