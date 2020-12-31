import 'package:firebase_auth/firebase_auth.dart' as _auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/services/authentication_service.dart';
import 'package:workout_player/services/database.dart';

import '../home_screen.dart';
import 'sign_in_screen.dart';
import 'splash_screen.dart';

class LandingScreen extends StatelessWidget {
  static const routeName = '/landing';
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthServiceProvider>(context, listen: false);
    // Return either HomeScreen or AuthScreen or SplashScreen when loading
    return StreamBuilder(
      stream: _auth.FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final _auth.User user = snapshot.data;
          if (user == null) {
            return SignInScreen();
            // return SignInScreen();
          }
          // Listening to the Firebase Cloud Firestore database
          return Provider<Database>(
            create: (_) => FirestoreDatabase(uid: user.uid),
            child: HomeScreen(),
          );
        }
        return SplashScreen();
      },
    );
  }
}
