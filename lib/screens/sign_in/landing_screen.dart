import 'package:firebase_auth/firebase_auth.dart' as fire_auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../home_screen.dart';
import 'sign_in_screen.dart';
import 'splash_screen.dart';

class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);

    // auth.authStateChanges().listen(
    //   (_fireAuth.User user) {
    //     if (user == null) {
    //       return SignInScreen.create(context);
    //     } else {
    //       return Provider<Database>(
    //         create: (_) => FirestoreDatabase(userId: user.uid),
    //         child: HomeScreen(),
    //       );
    //     }
    //   },
    // );

    // // Return either HomeScreen or AuthScreen or SplashScreen when loading
    return StreamBuilder<fire_auth.User>(
      stream: auth.authStateChanges().asBroadcastStream(),
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
