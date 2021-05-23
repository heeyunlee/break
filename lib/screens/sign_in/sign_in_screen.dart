import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/screens/sign_in/preview_screen.dart';
import 'package:workout_player/screens/sign_in/sign_in_bloc.dart';
import 'package:workout_player/screens/sign_in/widgets/social_sign_in_button.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/services/main_provider.dart';
import 'package:workout_player/services/mixpanel_manager.dart';

import '../../widgets/show_exception_alert_dialog.dart';
import '../../constants.dart';
import 'log_in_with_email_scree.dart';
import 'email_signup/email_sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  final SignInBloc signInBloc;
  final Database database;
  final bool isLoading;

  const SignInScreen({
    Key? key,
    required this.signInBloc,
    required this.isLoading,
    required this.database,
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
  late Mixpanel mixpanel;

  bool _showPreview = true;
  final locale = Intl.getCurrentLocale();

  set setBool(bool value) => setState(() => _showPreview = value);

  /// SIGN IN WITH GOOGLE
  Future<void> _signInWithGoogle(BuildContext context) async {
    debugPrint('sign in with google pressed');
    mixpanel.track('sign up with Google pressed');

    try {
      await widget.signInBloc.signInWithGoogle();

      final firebaseUser = widget.signInBloc.auth.currentUser!;

      // Check if the user document exists in Cloud Firestore
      final User? user =
          await widget.database.getUserDocument(firebaseUser.uid);

      // Create new data if it does NOT exist
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
    } on FirebaseException catch (e) {
      logger.d(e);
      _showSignInError(e, context);
    }
  }

  /// SIGN IN WITH FACEBOOK
  void _signInWithFacebook(BuildContext context) async {
    debugPrint('sign in with facebook pressed');
    mixpanel.track('sign up with Facebook pressed');

    try {
      await widget.signInBloc.signInWithFacebook();

      final firebaseUser = widget.signInBloc.auth.currentUser!;

      // Check if the user document exists in Cloud Firestore
      final User? user =
          await widget.database.getUserDocument(firebaseUser.uid);

      // Create new data do NOT exist
      if (user == null) {
        final uniqueId = UniqueKey().toString();
        final id = 'Player $uniqueId';
        final currentTime = Timestamp.now();

        final userData = User(
          userId: firebaseUser.uid,
          displayName: firebaseUser.providerData[0].displayName ?? id,
          userName: firebaseUser.providerData[0].displayName ?? id,
          userEmail: firebaseUser.providerData[0].email ?? firebaseUser.email,
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
    } on FirebaseException catch (e) {
      logger.d(e);
      _showSignInError(e, context);
    }
  }

  /// SIGN IN WITH APPLE
  void _signInWithApple(BuildContext context) async {
    debugPrint('sign in with apple pressed');
    mixpanel.track('sign up with Apple pressed');

    try {
      await widget.signInBloc.signInWithApple();

      final firebaseUser = widget.signInBloc.auth.currentUser!;

      // Check if the user document exists in Cloud Firestore
      final User? user =
          await widget.database.getUserDocument(firebaseUser.uid);

      // Create new data do NOT exist
      if (user == null) {
        final uniqueId = UniqueKey().toString();
        final id = 'Player $uniqueId';
        final currentTime = Timestamp.now();

        final userData = User(
          userId: firebaseUser.uid,
          displayName: firebaseUser.providerData[0].displayName ??
              firebaseUser.displayName ??
              id,
          userName: firebaseUser.providerData[0].displayName ??
              firebaseUser.displayName ??
              id,
          userEmail: firebaseUser.providerData[0].email ?? firebaseUser.email,
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
    } on FirebaseException catch (e) {
      logger.d(e);
      _showSignInError(e, context);
    }
  }

  /// SIGN IN WITH Kakao
  void _signInWithKakao(BuildContext context) async {
    debugPrint('sign in with Kakao triggered');
    mixpanel.track('sign up with Kakao pressed');

    try {
      await widget.signInBloc.signInWithKakao();

      final firebaseUser = widget.signInBloc.auth.currentUser!;

      print(firebaseUser.toString());

      // GET User data to Firebase
      final User? user =
          await widget.database.getUserDocument(firebaseUser.uid);

      // Create new data do NOT exist
      if (user == null) {
        final uniqueId = UniqueKey().toString();
        final currentTime = Timestamp.now();
        final userData = User(
          userId: firebaseUser.uid,
          userName: firebaseUser.displayName ?? 'Player $uniqueId',
          displayName: firebaseUser.displayName ?? 'Player $uniqueId',
          userEmail: firebaseUser.email,
          signUpDate: currentTime,
          signUpProvider: 'kakaocorp.com',
          totalWeights: 0,
          totalNumberOfWorkouts: 0,
          unitOfMass: 1,
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
    } on FirebaseException catch (e) {
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

  Future<void> initMixPanel() async {
    mixpanel = await MixpanelManager.init();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('sign in screen scaffold building...');
    initMixPanel();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: (_showPreview)
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: widget.isLoading
                    ? null
                    : () => setState(() {
                          _showPreview = true;
                        }),
              ),
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: kBackgroundColor,

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
      child: SafeArea(
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
                                AlwaysStoppedAnimation<Color>(kPrimaryColor),
                          ),
                          const SizedBox(height: 24),
                          Text(S.current.signingIn, style: kBodyText2),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('HēraKless', style: kHeadline3Menlo),
                          const SizedBox(height: 8),
                          const Text(
                            'wokrout. record. and share.',
                            style: kSubtitle2Menlo,
                          ),
                        ],
                      ),
              ),
            ),

            /// Sign In With Email
            SocialSignInButton(
              kButtonText: S.current.signUp,
              iconData: Icons.email_rounded,
              color: kPrimary600Color,
              kDisabledColor: kPrimary600Color.withOpacity(0.85),
              textColor: Colors.white,
              onPressed: widget.isLoading
                  ? null
                  : () => EmailSignUpScreen.show(context),
            ),

            // SIGN IN WITH GOOGLE
            SocialSignInButton(
              kButtonText: S.current.continueWithGoogle,
              color: Colors.white,
              kDisabledColor: Colors.white.withOpacity(0.85),
              textColor: Colors.black.withOpacity(0.85),
              logo: 'assets/logos/google_logo.png',
              onPressed:
                  widget.isLoading ? null : () => _signInWithGoogle(context),
            ),

            // SIGN IN WITH FACEBOOK
            SocialSignInButton(
              kButtonText: S.current.continueWithFacebook,
              color: Color(0xff1877F2),
              kDisabledColor: Color(0xff1877F2).withOpacity(0.85),
              textColor: Colors.white.withOpacity(0.85),
              logo: 'assets/logos/facebook_logo.png',
              onPressed:
                  widget.isLoading ? null : () => _signInWithFacebook(context),
            ),

            // SIGN IN WITH APPLE
            if (Platform.isIOS)
              SocialSignInButton(
                kButtonText: S.current.continueWithApple,
                color: Colors.white,
                textColor: Colors.black.withOpacity(0.85),
                kDisabledColor: Colors.white.withOpacity(0.85),
                logo: 'assets/logos/apple_logo.png',
                onPressed:
                    widget.isLoading ? null : () => _signInWithApple(context),
              ),

            // SIGN IN WITH KAKAO
            SocialSignInButton(
              kButtonText: S.current.continueWithKakao,
              color: Color(0xffFEE500),
              kDisabledColor: Color(0xffFEE500).withOpacity(0.85),
              logo: 'assets/logos/kakao_logo.png',
              textColor: Colors.black.withOpacity(0.85),
              onPressed:
                  widget.isLoading ? null : () => _signInWithKakao(context),
            ),

            TextButton(
              onPressed: widget.isLoading
                  ? null
                  : () => LogInWithEmailScreen.show(context),
              child: Text(
                S.current.logIn,
                style: kGoogleSignInStyleWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
