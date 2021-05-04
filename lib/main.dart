import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/services/auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/sign_in/landing_screen.dart';
import 'services/database.dart';
import 'generated/l10n.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(MyApp());
  // await initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );

    return MultiProvider(
      providers: [
        Provider<Database>(
          create: (_) => FirestoreDatabase(),
        ),
        Provider<AuthBase>(
          create: (context) => AuthService(),
        ),
        // Provider<UserSavedWorkoutModel>(
        //   create: (context) => UserSavedWorkoutModel(),
        // ),
      ],
      child: MaterialApp(
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'NanumSquareRound',
        ),
        home: LandingScreen(),
      ),
    );
  }
}
