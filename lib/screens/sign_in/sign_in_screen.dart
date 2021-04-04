import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/screens/sign_in/preview_screen.dart';
import 'package:workout_player/screens/sign_in/sign_in_bloc.dart';
import 'package:workout_player/screens/sign_in/social_sign_in_button.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../common_widgets/show_exception_alert_dialog.dart';
import '../../constants.dart';

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

  /// SIGN IN ANONYMOUSLY
  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await widget.signInBloc.signInAnonymously();

      final firebaseUser = widget.signInBloc.auth.currentUser;
      final uniqueId = UniqueKey().toString();

      final currentTime = Timestamp.now();
      final userData = User(
        userId: firebaseUser.uid,
        userName: 'Player $uniqueId',
        userEmail: firebaseUser.email,
        signUpDate: currentTime,
        signUpProvider: 'Anon',
        totalWeights: 0,
        totalNumberOfWorkouts: 0,
        unitOfMass: 1,
        lastLoginDate: currentTime,
        dailyWorkoutHistories: [],
      );
      await widget.database.setUser(userData);
    } on Exception catch (e) {
      print(e);

      logger.d(e);
      _showSignInError(e, context);
    }
  }

  /// SIGN IN WITH GOOGLE
  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await widget.signInBloc.signInWithGoogle();

      // Write User data to Firebase
      final user = await widget.database.userDocument(
        widget.signInBloc.auth.currentUser.uid,
      );
      final firebaseUser = widget.signInBloc.auth.currentUser;

      // Create new data do NOT exist
      if (user == null) {
        final currentTime = Timestamp.now();
        final userData = User(
          userId: firebaseUser.uid,
          userName: firebaseUser.displayName,
          userEmail: firebaseUser.email,
          signUpDate: currentTime,
          signUpProvider: 'Google',
          totalWeights: 0,
          totalNumberOfWorkouts: 0,
          unitOfMass: 1,
          lastLoginDate: currentTime,
          dailyWorkoutHistories: [],
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
      print(e);
      logger.d(e);
      _showSignInError(e, context);
    }
  }

  /// SIGN IN WITH FACEBOOK
  void _signInWithFacebook(BuildContext context) async {
    try {
      await widget.signInBloc.signInWithFacebook();

      // Write User data to Firebase
      final user = await widget.database.userDocument(
        widget.signInBloc.auth.currentUser.uid,
      );
      final firebaseUser = widget.signInBloc.auth.currentUser;

      // Create new data do NOT exist
      if (user == null) {
        final currentTime = Timestamp.now();
        final userData = User(
          userId: firebaseUser.uid,
          userName: firebaseUser.displayName,
          userEmail: firebaseUser.email,
          signUpDate: currentTime,
          signUpProvider: 'Facebook',
          totalWeights: 0,
          totalNumberOfWorkouts: 0,
          unitOfMass: 1,
          lastLoginDate: currentTime,
          dailyWorkoutHistories: [],
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
      print(e);
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

      // Create new data do NOT exist
      if (user == null) {
        final uniqueId = UniqueKey().toString();
        final currentTime = Timestamp.now();
        final userData = User(
          userId: firebaseUser.uid,
          userName: firebaseUser.displayName ?? 'Player $uniqueId',
          userEmail: firebaseUser.email,
          signUpDate: currentTime,
          signUpProvider: 'Apple',
          totalWeights: 0,
          totalNumberOfWorkouts: 0,
          unitOfMass: 1,
          lastLoginDate: currentTime,
          dailyWorkoutHistories: [],
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
      print(e);
      logger.d(e);
      _showSignInError(e, context);
    }
  }

  // /// SIGN IN WITH Kakao
  // void _signInWithKakao(BuildContext context) async {
  //   try {
  //     await widget.signInBloc.signInWithKakao();

  //     // // Write User data to Firebase
  //     // final user = await widget.database.userDocument(
  //     //   widget.signInBloc.auth.currentUser.uid,
  //     // );
  //     // final firebaseUser = widget.signInBloc.auth.currentUser;

  //     // // Create new data do NOT exist
  //     // if (user == null) {
  //     //   final uniqueId = UniqueKey().toString();
  //     //   final currentTime = Timestamp.now();
  //     //   final userData = User(
  //     //     userId: firebaseUser.uid,
  //     //     userName: firebaseUser.displayName ?? 'Player $uniqueId',
  //     //     userEmail: firebaseUser.email,
  //     //     signUpDate: currentTime,
  //     //     signUpProvider: 'Kakao',
  //     //     totalWeights: 0,
  //     //     totalNumberOfWorkouts: 0,
  //     //     unitOfMass: 1,
  //     //     lastLoginDate: currentTime,
  //     //     dailyWorkoutHistories: [],
  //     //   );

  //     //   await widget.database.setUser(userData);
  //     // } else {
  //     //   // Update Data if exist
  //     //   final currentTime = Timestamp.now();

  //     //   final updatedUserData = {
  //     //     'lastLoginDate': currentTime,
  //     //   };

  //     //   await widget.database.updateUser(firebaseUser.uid, updatedUserData);
  //     // }
  //   } on Exception catch (e) {
  //     print(e);
  //     logger.d(e);
  //     _showSignInError(e, context);
  //   }
  // }

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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/logos/playerh_logo.png',
                          width: 120,
                          height: 120,
                        ),
                        const SizedBox(height: 24),
                        // const Text('All About That Health', style: Headline5),
                      ],
                    ),
            ),
          ),

          /// Sign In With Google Button
          SocialSignInButton(
            color: Colors.white,
            disabledColor: Colors.white.withOpacity(0.38),
            onPressed:
                widget.isLoading ? null : () => _signInWithGoogle(context),
            logo: 'assets/logos/google_logo.png',
            buttonText: S.current.continueWithGoogle,
          ),

          /// Sign In With Facebook Button
          SocialSignInButton(
            color: const Color(0xff1877F2),
            disabledColor: Color(0xff1877F2).withOpacity(0.38),
            textColor: Colors.white,
            onPressed:
                widget.isLoading ? null : () => _signInWithFacebook(context),
            logo: 'assets/logos/facebook_logo.png',
            buttonText: S.current.continueWithFacebook,
          ),

          /// Sign In With Apple Button
          if (Platform.isIOS)
            SocialSignInButton(
              color: Colors.white,
              disabledColor: Colors.white.withOpacity(0.38),
              onPressed:
                  widget.isLoading ? null : () => _signInWithApple(context),
              logo: 'assets/logos/apple_logo.png',
              buttonText: S.current.continueWithApple,
            ),

          // // TODO: Add Sign In with Kakao
          // if (Platform.isIOS)
          //   SocialSignInButton(
          //     color: Color(0xfffee500),
          //     disabledColor: Colors.white.withOpacity(0.38),
          //     onPressed:
          //         widget.isLoading ? null : () => _signInWithKakao(context),
          //     logo: 'assets/logos/kakao_logo.png',
          //     buttonText: S.current.continueWithKakao,
          //   ),
          const SizedBox(height: 48),
          TextButton(
            onPressed: widget.isLoading
                ? null
                : () async {
                    await _signInAnonymously(context);
                  },
            child: Text(S.current.continueAnonymously, style: ButtonTextGrey),
          ),
          const SizedBox(height: 38),
        ],
      ),
    );
  }
}
