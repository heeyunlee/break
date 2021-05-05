import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/screens/sign_in/preview_screen.dart';
import 'package:workout_player/screens/sign_in/sign_in_bloc.dart';
import 'package:workout_player/screens/sign_in/social_sign_in_button.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../widgets/show_exception_alert_dialog.dart';
import '../../constants.dart';
import 'log_in_with_email_scree.dart';
import 'sign_up_outlined_button.dart';
import 'email_signup/email_sign_up_screen.dart';

Logger logger = Logger();

class SignInScreen extends StatefulWidget {
  final SignInBloc signInBloc;
  final Database database;
  final bool isLoading;

  const SignInScreen({
    Key key,
    @required this.signInBloc,
    @required this.isLoading,
    @required this.database,
  }) : super(key: key);

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final database = Provider.of<Database>(context, listen: false);

    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInBloc>(
          create: (_) => SignInBloc(auth: auth, isLoading: isLoading),
          child: Consumer<SignInBloc>(
            builder: (_, signInBloc, __) => SignInScreen(
              signInBloc: signInBloc,
              isLoading: isLoading.value,
              database: database,
            ),
          ),
        ),
      ),
    );
  }

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _showPreview = true;

  set setBool(bool value) => setState(() => _showPreview = value);

  // /// SIGN IN ANONYMOUSLY
  // Future<void> _signInAnonymously(BuildContext context) async {
  //   try {
  //     await widget.signInBloc.signInAnonymously();

  //     final firebaseUser = widget.signInBloc.auth.currentUser;
  //     final uniqueId = UniqueKey().toString();
  //     final id = 'Player $uniqueId';
  //     final currentTime = Timestamp.now();
  //     final locale = Intl.getCurrentLocale();

  //     final userData = User(
  //       userId: firebaseUser.uid,
  //       displayName: firebaseUser.providerData[0].displayName ?? id,
  //       userName: firebaseUser.providerData[0].displayName ?? id,
  //       userEmail: firebaseUser.providerData[0].email,
  //       signUpDate: currentTime,
  //       signUpProvider: firebaseUser.providerData[0].providerId,
  //       totalWeights: 0,
  //       totalNumberOfWorkouts: 0,
  //       unitOfMass: (locale == 'ko') ? 0 : 1,
  //       lastLoginDate: currentTime,
  //       dailyWorkoutHistories: [],
  //       dailyNutritionHistories: [],
  //       savedRoutines: [],
  //       savedWorkouts: [],
  //     );
  //     await widget.database.setUser(userData);
  //   } on Exception catch (e) {
  //     print(e);

  //     logger.d(e);
  //     _showSignInError(e, context);
  //   }
  // }

  /// SIGN IN WITH GOOGLE
  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await widget.signInBloc.signInWithGoogle();

      // Write User data to Firebase
      final user = await widget.database.userDocument(
        widget.signInBloc.auth.currentUser.uid,
      );
      final firebaseUser = widget.signInBloc.auth.currentUser;

      final locale = Intl.getCurrentLocale();

      // Create new data do NOT exist
      if (user == null) {
        final uniqueId = UniqueKey().toString();
        final id = 'Player $uniqueId';
        final currentTime = Timestamp.now();
        final userData = User(
          userId: firebaseUser.uid,
          displayName: firebaseUser.providerData[0].displayName ?? id,
          userName: firebaseUser.providerData[0].displayName ?? id,
          userEmail: firebaseUser.providerData[0].email,
          signUpDate: currentTime,
          signUpProvider: firebaseUser.providerData[0].providerId,
          totalWeights: 0,
          totalNumberOfWorkouts: 0,
          unitOfMass: (locale == 'ko') ? 0 : 1,
          lastLoginDate: currentTime,
          dailyWorkoutHistories: [],
          dailyNutritionHistories: [],
          savedRoutines: [],
          savedWorkouts: [],
        );
        await widget.database.setUser(userData);
      } else {
        // Update Data if exist
        final currentTime = Timestamp.now();

        final updatedUserData = {
          'lastLoginDate': currentTime,
        };
        await widget.database.updateUser(firebaseUser.uid, updatedUserData);
      }
    } on Exception catch (e) {
      logger.d(e);
      _showSignInError(e, context);
    }
  }

  /// SIGN IN WITH FACEBOOK
  void _signInWithFacebook(BuildContext context) async {
    debugPrint('sign in with facebook pressed');
    try {
      await widget.signInBloc.signInWithFacebook();

      // Write User data to Firebase
      final user = await widget.database.userDocument(
        widget.signInBloc.auth.currentUser.uid,
      );
      final firebaseUser = widget.signInBloc.auth.currentUser;

      final locale = Intl.getCurrentLocale();

      // Create new data do NOT exist
      if (user == null) {
        final uniqueId = UniqueKey().toString();
        final id = 'Player $uniqueId';
        final currentTime = Timestamp.now();

        final userData = User(
          userId: firebaseUser.uid,
          displayName: firebaseUser.providerData[0].displayName ?? id,
          userName: firebaseUser.providerData[0].displayName ?? id,
          userEmail: firebaseUser.providerData[0].email,
          signUpDate: currentTime,
          signUpProvider: firebaseUser.providerData[0].providerId,
          totalWeights: 0,
          totalNumberOfWorkouts: 0,
          unitOfMass: (locale == 'ko') ? 0 : 1,
          lastLoginDate: currentTime,
          dailyWorkoutHistories: [],
          dailyNutritionHistories: [],
          savedRoutines: [],
          savedWorkouts: [],
        );
        await widget.database.setUser(userData);
      } else {
        // Update Data if exist
        final currentTime = Timestamp.now();

        final updatedUserData = {
          'lastLoginDate': currentTime,
        };
        await widget.database.updateUser(firebaseUser.uid, updatedUserData);
      }
    } on Exception catch (e) {
      logger.d(e);
      _showSignInError(e, context);
    }
  }

  /// SIGN IN WITH APPLE
  void _signInWithApple(BuildContext context) async {
    try {
      await widget.signInBloc.signInWithApple();

      // Write User data to Firebase
      final user = await widget.database.userDocument(
        widget.signInBloc.auth.currentUser.uid,
      );
      final firebaseUser = widget.signInBloc.auth.currentUser;
      final locale = Intl.getCurrentLocale();

      // Create new data do NOT exist
      if (user == null) {
        final uniqueId = UniqueKey().toString();
        final id = 'Player $uniqueId';
        final currentTime = Timestamp.now();

        final userData = User(
          userId: firebaseUser.uid,
          displayName: firebaseUser.providerData[0].displayName ?? id,
          userName: firebaseUser.providerData[0].displayName ?? id,
          userEmail: firebaseUser.providerData[0].email,
          signUpDate: currentTime,
          signUpProvider: firebaseUser.providerData[0].providerId,
          totalWeights: 0,
          totalNumberOfWorkouts: 0,
          unitOfMass: (locale == 'ko') ? 0 : 1,
          lastLoginDate: currentTime,
          dailyWorkoutHistories: [],
          dailyNutritionHistories: [],
          savedRoutines: [],
          savedWorkouts: [],
        );
        await widget.database.setUser(userData);
      } else {
        // Update Data if exist
        final currentTime = Timestamp.now();

        final updatedUserData = {
          'lastLoginDate': currentTime,
        };
        await widget.database.updateUser(firebaseUser.uid, updatedUserData);
      }
    } on Exception catch (e) {
      logger.d(e);
      _showSignInError(e, context);
    }
  }

  // TODO: CONFIGURE SIGN IN WITH KAKAO
  /// SIGN IN WITH Kakao
  void _signInWithKakao(BuildContext context) async {
    debugPrint('sign in with Kakao triggered');
    try {
      await widget.signInBloc.signInWithKakao();

      // // Write User data to Firebase
      // final user = await widget.database.userDocument(
      //   widget.signInBloc.auth.currentUser.uid,
      // );
      // final firebaseUser = widget.signInBloc.auth.currentUser;

      // // Create new data do NOT exist
      // if (user == null) {
      //   final uniqueId = UniqueKey().toString();
      //   final currentTime = Timestamp.now();
      //   final userData = User(
      //     userId: firebaseUser.uid,
      //     userName: firebaseUser.displayName ?? 'Player $uniqueId',
      //     userEmail: firebaseUser.email,
      //     signUpDate: currentTime,
      //     signUpProvider: 'Kakao',
      //     totalWeights: 0,
      //     totalNumberOfWorkouts: 0,
      //     unitOfMass: 1,
      //     lastLoginDate: currentTime,
      //     dailyWorkoutHistories: [],
      //   );

      //   await widget.database.setUser(userData);
      // } else {
      //   // Update Data if exist
      //   final currentTime = Timestamp.now();

      //   final updatedUserData = {
      //     'lastLoginDate': currentTime,
      //   };

      //   await widget.database.updateUser(firebaseUser.uid, updatedUserData);
      // }
    } on Exception catch (e) {
      print(e);
      logger.d(e);
      _showSignInError(e, context);
    }
  }

  void _showSignInError(Exception exception, BuildContext context) {
    showExceptionAlertDialog(
      context,
      title: S.current.signInFailed,
      exception: exception.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('scaffold building...');

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: (_showPreview)
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => setState(() {
                  _showPreview = true;
                }),
              ),
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: BackgroundColor,

      // For smooth transition between PreviewScreen and SignUpScreen
      body: AnimatedCrossFade(
        crossFadeState: (_showPreview)
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
        duration: const Duration(milliseconds: 400),
        firstChild: PreviewScreen(
          callback: (value) => setState(() {
            _showPreview = value;
          }),
        ),
        secondChild: _buildSignInScreen(context),
      ),
    );
  }

  Widget _buildSignInScreen(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      child: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: widget.isLoading
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(PrimaryColor),
                        ),
                        const SizedBox(height: 24),
                        Text(S.current.signingIn, style: BodyText2),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('HēraKless', style: Headline3Menlo),
                        const SizedBox(height: 8),
                        const Text(
                          'wokrout. record. and share.',
                          style: Subtitle2Menlo,
                        ),
                      ],
                    ),
            ),
          ),

          /// Sign In With Email
          SocialSignInButton(
            buttonText: S.current.signUp,
            iconData: Icons.email_rounded,
            color: Primary600Color,
            textColor: Colors.white,
            onPressed: () => EmailSignUpScreen.show(context),
          ),

          // SIGN IN WITH GOOGLE
          SignUpOutlinedButton(
            buttonText: S.current.continueWithGoogle,
            logo: 'assets/logos/google_logo.png',
            logoSize: 18,
            isLogoSVG: false,
            onPressed:
                widget.isLoading ? null : () => _signInWithGoogle(context),
          ),

          // SIGN IN WITH FACEBOOK
          SignUpOutlinedButton(
            buttonText: S.current.continueWithFacebook,
            logo: 'assets/logos/facebook_logo.svg',
            logoSize: 20,
            isLogoSVG: true,
            onPressed:
                widget.isLoading ? null : () => _signInWithFacebook(context),
          ),

          // SIGN IN WITH GOOGLE
          if (Platform.isIOS)
            SignUpOutlinedButton(
              buttonText: S.current.continueWithApple,
              logo: 'assets/logos/apple_logo.png',
              logoSize: 18,
              isLogoSVG: false,
              logoColor: Colors.white,
              onPressed:
                  widget.isLoading ? null : () => _signInWithApple(context),
            ),

          const SizedBox(height: 8),

          // TODO: Add Sign In with Kakao
          if (Platform.isIOS)
            SignUpOutlinedButton(
              onPressed:
                  widget.isLoading ? null : () => _signInWithKakao(context),
              logo: 'assets/logos/kakao_logo.png',
              buttonText: S.current.continueWithKakao,
            ),

          // TextButton(
          //   onPressed: widget.isLoading
          //       ? null
          //       : () async {
          //           await _signInAnonymously(context);
          //         },
          //   child: Text(S.current.continueAnonymously, style: ButtonTextGrey),
          // ),

          TextButton(
            onPressed: () => LogInWithEmailScreen.show(context),
            child: Text(
              S.current.logIn,
              style: GoogleSignInStyleWhite,
            ),
          ),

          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
