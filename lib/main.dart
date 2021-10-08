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
import 'package:workout_player/styles/custom_theme_data.dart';

import 'package:workout_player/view_models/main_model.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/mixpanel_manager.dart';
import 'package:workout_player/services/private_keys.dart';

import 'generated/l10n.dart';
import 'services/algolia_manager.dart';
import 'services/database.dart';
import 'view/screens/landing_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MixpanelManager().init();
  AlgoliaManager().initAlgolia();
  KakaoContext.clientId = kakaoClientId;
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );

    if (kDebugMode || kProfileMode) {
      initLogger(Level.debug);
    }

    logger.d('In [Main] method');

    return ProviderScope(
      child: provider.MultiProvider(
        providers: [
          provider.Provider<Database>(
            create: (_) => FirestoreDatabase(),
          ),
          provider.Provider<AuthBase>(
            create: (context) => AuthService(),
          ),
        ],
        child: GetMaterialApp(
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          debugShowCheckedModeBanner: false,
          theme: CustomThemeData.defaultTheme,
          home: const LandingScreen(),
        ),
      ),
    );
  }
}
