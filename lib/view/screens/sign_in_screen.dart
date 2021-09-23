import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/button_styles.dart';
import 'package:workout_player/styles/theme_colors.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/main_model.dart';
import 'package:workout_player/view_models/sign_in_screen_model.dart';
import 'package:workout_player/view_models/sign_in_with_email_screen_model.dart';

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
                SignInLogoWidget(model: model),
                AnimatedListViewBuilder(
                  beginOffset: const Offset(0.25, 0),
                  offsetInitialDelayTime: 0.25,
                  offsetStaggerTime: 0.05,
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
        style: ButtonStyles.text1Google,
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
        color: ThemeColors.primary600,
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
        color: const Color(0xff1877F2),
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
        color: const Color(0xffFEE500),
        logo: 'assets/logos/kakao_logo.png',
        textColor: Colors.black.withOpacity(0.85),
        onPressed:
            model.isLoading ? null : () => model.signInWithKakao(context),
      ),
      TextButton(
        style: ButtonStyles.text1Google,
        onPressed: model.isLoading
            ? null
            : () => SignInWithEmailModel.showSignInScreen(context),
        child: Text(S.current.logIn),
      ),
    ];
  }
}
