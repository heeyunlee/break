import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_player/screens/auth_screen.dart';
import 'package:workout_player/screens/home_screen.dart';

import 'screens/cardio_entry_screen.dart';
import 'screens/landing_screen.dart';
import 'screens/protein_entry_screen.dart';
import 'screens/search_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // return FutureBuilder(
    //     future: _initialization,
    //     builder: (context, snapshot) {
    //       // Checking for error
    //       if (snapshot.hasError) {
    //         return MaterialApp(
    //           home: Center(
    //             child: Text('Something went wrong: ${snapshot.error}'),
    //           ),
    //         );
    //       }
    //
    //       // Starting the application
    //       if (snapshot.connectionState == ConnectionState.done) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'NanumSquareRound',
      ),
      // home: StreamBuilder(
      //     stream: FirebaseAuth.instance.authStateChanges(),
      //     builder: (context, snapshot) {
      //       if (snapshot.connectionState == ConnectionState.waiting) {
      //         return SplashScreen();
      //       }
      //       if (snapshot.hasData) {
      // home: Stack(children: [HomeScreen()]),
      home: LandingScreen(),
      //   }
      //   return AuthScreen();
      // }),
      routes: {
        AuthScreen.routeName: (context) => AuthScreen(),
        HomeScreen.routeName: (context) => HomeScreen(),
        SearchScreen.routeName: (context) => SearchScreen(),
        CardioEntryScreen.routeName: (context) => CardioEntryScreen(),
        ProteinEntryScreen.routeName: (context) => ProteinEntryScreen(),
      },
    );
  }

// Splash screen for while loading...
//         return MaterialApp(
//           home: Center(
//             child: Text('Something went wrong: ${snapshot.error}'),
//           ),
//         );
//       });
// }
}
