import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart' as provider;
import 'package:workout_player/main_provider.dart';

import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/mixpanel_manager.dart';
import 'package:workout_player/services/private_keys.dart';

import 'generated/l10n.dart';
import 'screens/landing_screen.dart';
import 'services/algolia_manager.dart';
import 'services/database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MixpanelManager.init();
  AlgoliaManager.init();
  KakaoContext.clientId = PrivateKeys.kakaoClientId;
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// disable Landscape mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    /// Make Android status bar transparent
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );

    if (kDebugMode || kProfileMode) {
      initLogger(Level.debug);
    }

    logger.d('In [Main] method');

    return provider.MultiProvider(
      providers: [
        provider.Provider<Database>(
          create: (_) => FirestoreDatabase(),
        ),
        provider.Provider<AuthBase>(
          create: (context) => AuthService(),
        ),
      ],
      child: FeatureDiscovery(
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
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
          ),
          home: const LandingScreen(),
        ),
      ),
    );
  }
}
