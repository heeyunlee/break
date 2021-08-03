import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/screens/preview/widgets/blurred_background_preview_widget.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/button_styles.dart';
import 'package:workout_player/styles/constants.dart';

import 'sign_in_screen_model.dart';
import 'widgets/logo_widget.dart';
import 'widgets/social_sign_in_button.dart';
import 'with_email/email_sign_up_screen.dart';
import 'with_email/log_in_with_email_screen.dart';

class SignInScreen extends ConsumerWidget {
  final Database database;
  final AuthBase auth;

  const SignInScreen({
    Key? key,
    required this.database,
    required this.auth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final model = watch(signInScreenProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        elevation: 0,
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
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: model.isLoading ? Colors.white30 : Colors.white,
          ),
          onPressed: model.isLoading
              ? null
              : () {
                  HapticFeedback.mediumImpact();
                  Navigator.of(context).pop();
                },
        ),
      ),
      body: _buildBody(context, model),
    );
  }

  Widget _buildBody(BuildContext context, SignInScreenModel model) {
    return Stack(
      children: [
        const BlurredBackgroundPreviewWidget(),
        SafeArea(
          child: Column(
            children: <Widget>[
              LogoWidget(model: model),

              /// Sign In With Email
              SocialSignInButton(
                beginOffset: Offset(0, 0.5),
                beginInterval: 0.0,
                endInterval: 0.3,
                kButtonText: S.current.signUp,
                iconData: Icons.email_rounded,
                color: kPrimary600Color,
                textColor: Colors.white,
                onPressed: model.isLoading
                    ? null
                    : () => EmailSignUpScreen.show(context),
              ),

              /// SIGN IN WITH GOOGLE
              SocialSignInButton(
                beginOffset: Offset(0, 0.5),
                beginInterval: 0.1,
                endInterval: 0.4,
                kButtonText: S.current.continueWithGoogle,
                color: Colors.white,
                textColor: Colors.black.withOpacity(0.85),
                logo: 'assets/logos/google_logo.png',
                onPressed: model.isLoading
                    ? null
                    : () => model.signInWithGoogle(context),
              ),

              /// SIGN IN WITH FACEBOOK
              SocialSignInButton(
                beginOffset: Offset(0, 0.5),
                beginInterval: 0.2,
                endInterval: 0.5,
                kButtonText: S.current.continueWithFacebook,
                color: Color(0xff1877F2),
                textColor: Colors.white.withOpacity(0.85),
                logo: 'assets/logos/facebook_logo.png',
                onPressed: model.isLoading
                    ? null
                    : () => model.signInWithFacebook(context),
              ),

              /// SIGN IN WITH APPLE
              if (Platform.isIOS)
                SocialSignInButton(
                  beginOffset: Offset(0, 0.5),
                  beginInterval: 0.3,
                  endInterval: 0.6,
                  kButtonText: S.current.continueWithApple,
                  color: Colors.white,
                  textColor: Colors.black.withOpacity(0.85),
                  logo: 'assets/logos/apple_logo.png',
                  onPressed: model.isLoading
                      ? null
                      : () => model.signInWithApple(context),
                ),

              /// SIGN IN WITH KAKAO
              SocialSignInButton(
                beginOffset: Offset(0, 0.5),
                beginInterval: (Platform.isIOS) ? 0.4 : 0.3,
                endInterval: (Platform.isIOS) ? 0.7 : 0.6,
                kButtonText: S.current.continueWithKakao,
                color: Color(0xffFEE500),
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
      ],
    );
  }
}
