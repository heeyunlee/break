import 'package:firebase_auth/firebase_auth.dart' as _auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../home_screen.dart';
import 'sign_in_screen.dart';
import 'splash_screen.dart';

class LandingScreen extends StatelessWidget {
  static const routeName = '/landing';
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    // Return either HomeScreen or AuthScreen or SplashScreen when loading
    return StreamBuilder<_auth.User>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          if (user == null) {
            return SignInScreen.create(context);
          }
          // Listening to the Firebase Cloud Firestore database
          return Provider<Database>(
            create: (_) => FirestoreDatabase(userId: user.uid),
            child: HomeScreen(),
          );
        }
        return SplashScreen();
      },
    );
  }
}
