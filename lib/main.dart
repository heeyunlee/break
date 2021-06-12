import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:provider/provider.dart' as provider;

import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/mixpanel_manager.dart';

import 'generated/l10n.dart';
import 'screens/landing_screen.dart';
import 'services/database.dart';
import 'services/main_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MixpanelManager.init();
  AlgoliaManager.init();
  KakaoContext.clientId = KakaoManager.kakaoClientId;

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(ProviderScope(child: MyApp()));
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

    return provider.MultiProvider(
      providers: [
        provider.Provider<Database>(
          create: (_) => FirestoreDatabase(),
        ),
        provider.Provider<AuthBase>(
          create: (context) => AuthService(),
        ),
      ],
      child: GetMaterialApp(
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
          primaryColorBrightness: Brightness.dark,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        home: LandingScreen(),
      ),
    );
  }
}
