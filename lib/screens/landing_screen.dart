import 'package:firebase_auth/firebase_auth.dart' as fire_auth;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/main_provider.dart';

import 'home/home_screen.dart';
import 'preview/preview_screen.dart';
import 'splash/splash_screen.dart';

class LandingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    logger.d('LandingScreen build...');

    final auth = provider.Provider.of<AuthBase>(context, listen: false);

    return StreamBuilder<fire_auth.User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;

          if (user == null) {
            return const PreviewScreen();
          } else {
            return provider.Provider<Database>(
              create: (_) => FirestoreDatabase(uid: user.uid),
              child: HomeScreen.create(),
            );
          }
        }
        return const SplashScreen();
      },
    );
  }
}
