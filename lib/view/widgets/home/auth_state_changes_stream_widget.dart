import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_player/providers.dart' show firebaseAuthProvider;
import 'package:workout_player/view/screens/home.dart';
import 'package:workout_player/view/screens/preview_screen.dart';
import 'package:workout_player/view/screens/splash_screen.dart';
import 'package:workout_player/view/widgets/builders/custom_stream_builder_new.dart';

class AuthStateChangesStreamWidget extends ConsumerWidget {
  const AuthStateChangesStreamWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(firebaseAuthProvider);

    return CustomStreamBuilderNew<User?>(
      stream: auth.authStateChanges(),
      errorBuilder: (context, e) => const SplashScreen(),
      loadingBuilder: (context) => const SplashScreen(),
      emptyWidgetBuilder: (context) => const PreviewScreen(),
      builder: (context, user) => const Home(),
    );
  }
}
