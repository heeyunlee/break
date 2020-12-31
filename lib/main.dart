import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'screens/home_tab/home_tab.dart';
import 'screens/library_tab/library_tab.dart';
import 'screens/search_tab/search_tab.dart';
import 'screens/sign_in/landing_screen.dart';
import 'services/authentication_service.dart';
import 'services/database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthServiceProvider>(
          create: (_) => AuthServiceProvider(),
        ),
        Provider<Database>(
          create: (_) => FirestoreDatabase(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'NanumSquareRound',
        ),
        home: LandingScreen(),
        routes: {
          HomeTab.routeName: (context) => HomeTab(),
          SearchTab.routeName: (context) => SearchTab(),
          LibraryTab.routeName: (context) => LibraryTab(),
        },
      ),
    );
  }
}
