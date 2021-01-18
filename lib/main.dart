import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/services/auth.dart';

import 'screens/home_tab/home_tab.dart';
import 'screens/library_tab/library_tab.dart';
import 'screens/library_tab/workout/user_saved_workout_model.dart';
import 'screens/search_tab/search_tab.dart';
import 'screens/sign_in/landing_screen.dart';
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
        Provider<Database>(
          create: (_) => FirestoreDatabase(),
        ),
        Provider<AuthBase>(
          create: (context) => AuthService(),
        ),
        Provider<UserSavedWorkoutModel>(
          create: (context) => UserSavedWorkoutModel(),
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
