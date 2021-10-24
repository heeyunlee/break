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
import 'package:workout_player/styles/platform_colors.dart';

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
        systemNavigationBarContrastEnforced: false,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: [
        SystemUiOverlay.top,
        SystemUiOverlay.bottom,
      ],
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
        child: FutureBuilder<MaterialYouPalette?>(
            future: getMaterialYouColor(),
            builder: (context, snapshot) {
              // print('''
              // accent1.shade100 ${snapshot.data?.accent1.shade100.toString()}
              // accent1.shade200 ${snapshot.data?.accent1.shade200.toString()}
              // accent1.shade300 ${snapshot.data?.accent1.shade300.toString()}
              // accent1.shade400 ${snapshot.data?.accent1.shade400.toString()}
              // accent1.shade500 ${snapshot.data?.accent1.shade500.toString()}
              // accent1.shade600 ${snapshot.data?.accent1.shade600.toString()}
              // accent1.shade700 ${snapshot.data?.accent1.shade700.toString()}
              // accent1.shade800 ${snapshot.data?.accent1.shade800.toString()}
              // accent1.shade900 ${snapshot.data?.accent1.shade900.toString()}

              // accent2.shade100 ${snapshot.data?.accent2.shade100.toString()}
              // accent2.shade200 ${snapshot.data?.accent2.shade200.toString()}
              // accent2.shade300 ${snapshot.data?.accent2.shade300.toString()}
              // accent2.shade400 ${snapshot.data?.accent2.shade400.toString()}
              // accent2.shade500 ${snapshot.data?.accent2.shade500.toString()}
              // accent2.shade600 ${snapshot.data?.accent2.shade600.toString()}
              // accent2.shade700 ${snapshot.data?.accent2.shade700.toString()}
              // accent2.shade800 ${snapshot.data?.accent2.shade800.toString()}
              // accent2.shade900 ${snapshot.data?.accent2.shade900.toString()}

              // ''');

              // print('''
              // accent3.shade100 ${snapshot.data?.accent3.shade100.toString()}
              // accent3.shade200 ${snapshot.data?.accent3.shade200.toString()}
              // accent3.shade300 ${snapshot.data?.accent3.shade300.toString()}
              // accent3.shade400 ${snapshot.data?.accent3.shade400.toString()}
              // accent3.shade500 ${snapshot.data?.accent3.shade500.toString()}
              // accent3.shade600 ${snapshot.data?.accent3.shade600.toString()}
              // accent3.shade700 ${snapshot.data?.accent3.shade700.toString()}
              // accent3.shade800 ${snapshot.data?.accent3.shade800.toString()}
              // accent3.shade900 ${snapshot.data?.accent3.shade900.toString()}

              // neutral1.shade100 ${snapshot.data?.neutral1.shade100.toString()}
              // neutral1.shade200 ${snapshot.data?.neutral1.shade200.toString()}
              // neutral1.shade300 ${snapshot.data?.neutral1.shade300.toString()}
              // neutral1.shade400 ${snapshot.data?.neutral1.shade400.toString()}
              // neutral1.shade500 ${snapshot.data?.neutral1.shade500.toString()}
              // neutral1.shade600 ${snapshot.data?.neutral1.shade600.toString()}
              // neutral1.shade700 ${snapshot.data?.neutral1.shade700.toString()}
              // neutral1.shade800 ${snapshot.data?.neutral1.shade800.toString()}
              // neutral1.shade900 ${snapshot.data?.neutral1.shade900.toString()}
              // ''');

              // print('''
              // neutral2.shade100 ${snapshot.data?.neutral2.shade100.toString()}
              // neutral2.shade200 ${snapshot.data?.neutral2.shade200.toString()}
              // neutral2.shade300 ${snapshot.data?.neutral2.shade300.toString()}
              // neutral2.shade400 ${snapshot.data?.neutral2.shade400.toString()}
              // neutral2.shade500 ${snapshot.data?.neutral2.shade500.toString()}
              // neutral2.shade600 ${snapshot.data?.neutral2.shade600.toString()}
              // neutral2.shade700 ${snapshot.data?.neutral2.shade700.toString()}
              // neutral2.shade800 ${snapshot.data?.neutral2.shade800.toString()}
              // neutral2.shade900 ${snapshot.data?.neutral2.shade900.toString()}
              // ''');

              return GetMaterialApp(
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                debugShowCheckedModeBanner: false,
                theme: CustomThemeData.createTheme(snapshot.data),
                home: const LandingScreen(),
              );
            }),
      ),
    );
  }
}
