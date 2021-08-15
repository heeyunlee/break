import 'package:firebase_auth/firebase_auth.dart' as fire_auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/view_models/main_model.dart';

import 'home_screen.dart';
import 'preview_screen.dart';
import 'splash_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.d('[LandingScreen] building...');

    final auth = provider.Provider.of<AuthBase>(context, listen: false);

    return StreamBuilder<fire_auth.User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;

          if (user == null) {
            logger.d('user does NOT exist');

            return const PreviewScreen();
          } else {
            logger.d('user does exist ${user.toString()}');

            return provider.Provider<Database>(
              create: (_) => FirestoreDatabase(uid: user.uid),
              child: HomeScreen.create(),
            );
          }
        }
        logger.d('waiting for the connection to Firebase');

        return const SplashScreen();
      },
    );
  }
}
