import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/routes/app_routes.dart';
import 'package:workout_player/routes/nav_tab_item.dart';
import 'package:workout_player/styles/button_styles.dart';
import 'package:workout_player/styles/theme_colors.dart';
import 'package:workout_player/utils/assets.dart';
import 'package:workout_player/features/widgets/widgets.dart';

import 'package:workout_player/features/sign_in/sign_in_model.dart';
import 'package:workout_player/widgets/widgets.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key, required this.animation});

  final Animation<double> animation;

  @override
  ConsumerState<SignInScreen> createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    final model = ref.watch(signInScreenProvider);

    return Scaffold(
      extendBody: true,
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
          BlurredImage(
            imageProvider: AdaptiveCachedNetworkImage.provider(
              context,
              imageUrl: Assets.bgURL[2],
            ),
            bgBlurSigma: 15,
          ),
          SafeArea(
            child: Column(
              children: <Widget>[
                SignInLogoWidget(model: model),
                AnimatedListViewBuilder(
                  animation: widget.animation,
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
        style: ButtonStyles.text1Google(context),
        onPressed: model.isLoading
            ? null
            : () async {
                final status = await model.signInAnonymously();

                if (!mounted) return;

                if (status.statusCode == 200) {
                  context.goNamed(
                    AppRoutes.app.name,
                    extra: NavTabItem.move,
                    params: {
                      'navTab': NavTabItem.move.name,
                    },
                  );
                } else {
                  _showSignInError(
                    status.exception as FirebaseException?,
                    context,
                  );
                }
              },
        child: Text(S.current.takeALook),
      ),
      const SizedBox(width: 16),
    ];
  }

  VoidCallback? onButtonTap() {
    return null;
  }

  List<Widget> _signInButtons(BuildContext context, SignInScreenModel model) {
    return [
      SocialSignInButton(
        kButtonText: S.current.signUp,
        iconData: Icons.email_rounded,
        color: ThemeColors.primary500,
        textColor: Colors.white,
        onPressed: model.isLoading
            ? null
            : () => context.goNamed(AppRoutes.signUpWithEmail.name),
      ),
      SocialSignInButton(
        kButtonText: S.current.continueWithGoogle,
        color: Colors.white,
        textColor: Colors.black.withOpacity(0.85),
        logo: 'assets/logos/google_logo.png',
        onPressed: model.isLoading
            ? null
            : () async {
                final status = await model.signInWithGoogle();

                if (!mounted) return;

                if (status.statusCode == 200) {
                  Navigator.of(context).popUntil((route) => route.isFirst);

                  // getSnackbarWidget(
                  //   S.current.signInSuccessful,
                  //   S.current.firstSignInSnackbarMessage(userData.displayName),
                  //   duration: 4,
                  // );
                }
              },
      ),
      SocialSignInButton(
        kButtonText: S.current.continueWithFacebook,
        color: const Color(0xff1877F2),
        textColor: Colors.white.withOpacity(0.85),
        logo: 'assets/logos/facebook_logo.png',
        onPressed: model.isLoading ? null : () => model.signInWithFacebook(),
      ),
      if (Platform.isIOS)
        SocialSignInButton(
          kButtonText: S.current.continueWithApple,
          color: Colors.white,
          textColor: Colors.black.withOpacity(0.85),
          logo: 'assets/logos/apple_logo.png',
          onPressed: model.isLoading ? null : () => model.signInWithApple(),
        ),
      SocialSignInButton(
        kButtonText: S.current.continueWithKakao,
        color: const Color(0xffFEE500),
        logo: 'assets/logos/kakao_logo.png',
        textColor: Colors.black.withOpacity(0.85),
        onPressed: model.isLoading ? null : () => model.signInWithKakao(),
      ),
      TextButton(
        style: ButtonStyles.text1Google(context),
        onPressed: model.isLoading
            ? null
            : () {
                context.goNamed(AppRoutes.signInWithEmail.name);
              },
        // : () => SignInWithEmailModel.showSignInScreen(context),
        child: Text(S.current.logIn),
      ),
    ];
  }
}

void _showSignInError(FirebaseException? exception, BuildContext context) {
  showExceptionAlertDialog(
    context,
    title: S.current.signInFailed,
    exception: _getExceptionMessage(exception),
  );
}

String _getExceptionMessage(FirebaseException? exception) {
  switch (exception?.code) {
    case 'ERROR_ABORTED_BY_USER':
      return S.current.errorAbortedByUser;
    default:
      return S.current.signInFailed;
  }
}
