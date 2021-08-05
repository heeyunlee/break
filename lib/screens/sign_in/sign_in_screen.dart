import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/screens/preview/widgets/blurred_background_preview_widget.dart';
import 'package:workout_player/screens/sign_in/with_email/sign_in_with_email_model.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/button_styles.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/widgets/animated_list_view_builder.dart';
import 'package:workout_player/widgets/appbar_back_button.dart';

import 'sign_in_screen_model.dart';
import 'widgets/logo_widget.dart';
import 'widgets/social_sign_in_button.dart';

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
    logger.d('[SignInScreen] building...');

    final model = watch(signInScreenProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        actions: _appBarActionWidgets(context, model),
        leading: AppBarBackButton(pressed: model.isLoading),
      ),
      body: Stack(
        children: [
          const BlurredBackgroundPreviewWidget(blur: 15),
          SafeArea(
            child: Column(
              children: <Widget>[
                LogoWidget(model: model),
                AnimatedListViewBuilder(
                  beginOffset: Offset(0.25, 0),
                  offsetStartInterval: 0.25,
                  offsetDelay: 0.05,
                  offsetDuration: 0.5,
                  items: _signInButtons(context, model),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _appBarActionWidgets(
    BuildContext context,
    SignInScreenModel model,
  ) {
    return [
      TextButton(
        style: ButtonStyles.text1_google,
        onPressed:
            model.isLoading ? null : () => model.signInAnonymously(context),
        child: Text(S.current.takeALook),
      ),
      const SizedBox(width: 16),
    ];
  }

  List<Widget> _signInButtons(BuildContext context, SignInScreenModel model) {
    return [
      SocialSignInButton(
        kButtonText: S.current.signUp,
        iconData: Icons.email_rounded,
        color: kPrimary600Color,
        textColor: Colors.white,
        onPressed: model.isLoading
            ? null
            : () => SignInWithEmailModel.showSignUpScreen(context),
      ),
      SocialSignInButton(
        kButtonText: S.current.continueWithGoogle,
        color: Colors.white,
        textColor: Colors.black.withOpacity(0.85),
        logo: 'assets/logos/google_logo.png',
        onPressed:
            model.isLoading ? null : () => model.signInWithGoogle(context),
      ),
      SocialSignInButton(
        kButtonText: S.current.continueWithFacebook,
        color: Color(0xff1877F2),
        textColor: Colors.white.withOpacity(0.85),
        logo: 'assets/logos/facebook_logo.png',
        onPressed:
            model.isLoading ? null : () => model.signInWithFacebook(context),
      ),
      if (Platform.isIOS)
        SocialSignInButton(
          kButtonText: S.current.continueWithApple,
          color: Colors.white,
          textColor: Colors.black.withOpacity(0.85),
          logo: 'assets/logos/apple_logo.png',
          onPressed:
              model.isLoading ? null : () => model.signInWithApple(context),
        ),
      SocialSignInButton(
        kButtonText: S.current.continueWithKakao,
        color: Color(0xffFEE500),
        logo: 'assets/logos/kakao_logo.png',
        textColor: Colors.black.withOpacity(0.85),
        onPressed:
            model.isLoading ? null : () => model.signInWithKakao(context),
      ),
      TextButton(
        style: ButtonStyles.text1_google,
        onPressed: model.isLoading
            ? null
            : () => SignInWithEmailModel.showSignInScreen(context),
        child: Text(S.current.logIn),
      ),
    ];
  }
}
