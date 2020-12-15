import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'common_widgets/workout/choose_workout.dart';
import 'forms/new_playlist/edit_playlist_title.dart';
import 'forms/new_playlist/new_workout_playlist_form.dart';
import 'screens/authenticate/auth_screen.dart';
import 'screens/authenticate/landing_screen.dart';
import 'screens/bottom_navigation_tabs/search_tab/search_tab.dart';
import 'screens/cardio_entry/cardio_entry_screen.dart';
import 'screens/details/workout_detail_screen.dart';
import 'screens/home.dart';
import 'screens/protein_entry/protein_entry_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'services/apple_signin_available.dart';
import 'services/auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final appleSignInAvailable = await AppleSignInAvailable.check();
  runApp(
    Provider<AppleSignInAvailable>.value(
      value: appleSignInAvailable,
      child: MyApp(),
    ),
  );
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
          ChangeNotifierProvider<FirebaseProvider>(
            create: (_) => FirebaseProvider(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            }),
            fontFamily: 'NanumSquareRound',
          ),
          home: LandingScreen(),
          routes: {
            ChooseWorkout.routeName: (context) => ChooseWorkout(),
            AuthScreen.routeName: (context) => AuthScreen(),
            SettingsScreen.routeName: (context) => SettingsScreen(),
            HomeScreen.routeName: (context) => HomeScreen(),
            SearchTab.routeName: (context) => SearchTab(),
            CardioEntryScreen.routeName: (context) => CardioEntryScreen(),
            ProteinEntryScreen.routeName: (context) => ProteinEntryScreen(),
            NewWorkoutPlaylistForm.routeName: (context) =>
                NewWorkoutPlaylistForm(),
            EditPlaylistTitle.routeName: (context) => EditPlaylistTitle(),
            WorkoutDetailScreen.routeName: (context) => WorkoutDetailScreen(0),
          },
        ));
  }
}
