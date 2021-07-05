import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart' as provider;

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/services/main_provider.dart';
import 'package:workout_player/styles/button_styles.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

import 'email_signup/email_sign_up_screen.dart';
import 'log_in_with_email_screen.dart';
import 'sign_in_screen_model.dart';
import 'widgets/social_sign_in_button.dart';

class SignInScreen extends ConsumerWidget {
  final Database database;
  final AuthBase auth;

  const SignInScreen({
    Key? key,
    required this.database,
    required this.auth,
  }) : super(key: key);

  static void show(BuildContext context) {
    final auth = provider.Provider.of<AuthBase>(context, listen: false);
    final database = provider.Provider.of<Database>(context, listen: false);

    HapticFeedback.mediumImpact();

    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => SignInScreen(
          auth: auth,
          database: database,
        ),
        transitionsBuilder: (context, animation1, animation2, child) =>
            FadeTransition(opacity: animation1, child: child),
        transitionDuration: Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    logger.d('SignInScreen building...');

    final model = ref.watch(signInScreenProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: [
          TextButton(
            style: ButtonStyles.text1_google,
            onPressed:
                model.isLoading ? null : () => model.signInAnonymously(context),
            child: Text(S.current.takeALook),
          ),
          const SizedBox(width: 16),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: model.isLoading ? null : () => Navigator.of(context).pop(),
        ),
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: kBackgroundColor,
      body: _buildSignInScreen(context, model),
    );
  }

  Widget _buildSignInScreen(BuildContext context, SignInScreenModel model) {
    final size = MediaQuery.of(context).size;
    final locale = Intl.getCurrentLocale();

    return Container(
      height: size.height,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                child: model.isLoading
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(kPrimaryColor),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            S.current.signingIn,
                            style: TextStyles.body2,
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/logos/icon.png',
                            width: size.width / 2,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Herakles: Workout Player',
                            style: kSubtitle1Menlo,
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
              onPressed: model.isLoading
                  ? null
                  : () => EmailSignUpScreen.show(context),
            ),

            /// SIGN IN WITH GOOGLE
            SocialSignInButton(
              kButtonText: S.current.continueWithGoogle,
              color: Colors.white,
              kDisabledColor: Colors.white.withOpacity(0.85),
              textColor: Colors.black.withOpacity(0.85),
              logo: 'assets/logos/google_logo.png',
              onPressed: model.isLoading
                  ? null
                  : () => model.signInWithGoogle(context),
            ),

            /// SIGN IN WITH FACEBOOK
            SocialSignInButton(
              kButtonText: S.current.continueWithFacebook,
              color: Color(0xff1877F2),
              kDisabledColor: Color(0xff1877F2).withOpacity(0.85),
              textColor: Colors.white.withOpacity(0.85),
              logo: 'assets/logos/facebook_logo.png',
              onPressed: model.isLoading
                  ? null
                  : () => model.signInWithFacebook(context),
            ),

            /// SIGN IN WITH APPLE
            if (Platform.isIOS)
              SocialSignInButton(
                kButtonText: S.current.continueWithApple,
                color: Colors.white,
                textColor: Colors.black.withOpacity(0.85),
                kDisabledColor: Colors.white.withOpacity(0.85),
                logo: 'assets/logos/apple_logo.png',
                onPressed: model.isLoading
                    ? null
                    : () => model.signInWithApple(context),
              ),

            /// SIGN IN WITH KAKAO
            if (locale == 'ko')
              SocialSignInButton(
                kButtonText: S.current.continueWithKakao,
                color: Color(0xffFEE500),
                kDisabledColor: Color(0xffFEE500).withOpacity(0.85),
                logo: 'assets/logos/kakao_logo.png',
                textColor: Colors.black.withOpacity(0.85),
                onPressed: model.isLoading
                    ? null
                    : () => model.signInWithKakao(context),
              ),

            /// LOG IN BUTTON
            TextButton(
              style: ButtonStyles.text1_google,
              onPressed: model.isLoading
                  ? null
                  : () => LogInWithEmailScreen.show(context),
              child: Text(S.current.logIn),
            ),
          ],
        ),
      ),
    );
  }
}
