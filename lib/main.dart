import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:logger/logger.dart';
import 'package:workout_player/services/logging.dart';
import 'package:workout_player/view/widgets/home/auth_state_changes_stream_widget.dart';

import 'generated/l10n.dart';
import 'services/algolia_manager.dart';
import 'services/mixpanel_manager.dart';
import 'services/private_keys.dart';
import 'styles/themes.dart';
import 'styles/platform_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MixpanelManager().init();
  AlgoliaManager().initAlgolia();
  KakaoContext.clientId = kKakaoNativeAppkey;
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(),
    ),
  );
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
      child: FutureBuilder<MaterialYouPalette?>(
        future: getMaterialYouColor(),
        builder: (context, snapshot) {
          return GetMaterialApp(
            useInheritedMediaQuery: true,
            locale: DevicePreview.locale(context),
            builder: DevicePreview.appBuilder,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            debugShowCheckedModeBanner: false,
            theme: Themes.createTheme(snapshot.data),
            home: const AuthStateChangesStreamWidget(),
          );
        },
      ),
    );
  }
}
