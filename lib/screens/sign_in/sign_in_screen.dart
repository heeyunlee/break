import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:workout_player/screens/sign_in/sign_in_bloc.dart';
import 'package:workout_player/screens/sign_in/social_sign_in_button.dart';
import 'package:workout_player/services/auth.dart';

import '../../common_widgets/show_exception_alert_dialog.dart';
import '../../constants.dart';
import 'app_preview_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({
    Key key,
    @required this.signInBloc,
    @required this.isLoading,
  }) : super(key: key);
  final SignInBloc signInBloc;
  final bool isLoading;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInBloc>(
          create: (_) => SignInBloc(auth: auth, isLoading: isLoading),
          child: Consumer<SignInBloc>(
            builder: (_, signInBloc, __) => SignInScreen(
                signInBloc: signInBloc, isLoading: isLoading.value),
          ),
        ),
      ),
    );
  }

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isPressStart = false;

  /// SIGN IN WITH GOOGLE
  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await widget.signInBloc.signInWithGoogle();
    } on Exception catch (e) {
      print(e);
      _showSignInError(e, context);
    }
  }

  /// SIGN IN WITH FACEBOOK
  void _signInWithFacebook(BuildContext context) async {
    try {
      await widget.signInBloc.signInWithFacebook();
    } on Exception catch (e) {
      _showSignInError(e, context);
    }
  }

  /// SIGN IN WITH APPLE
  void _signInWithApple(BuildContext context) async {
    try {
      await widget.signInBloc.signInWithApple();
    } on Exception catch (e) {
      _showSignInError(e, context);
    }
  }

  void _showSignInError(Exception exception, BuildContext context) {
    ShowExceptionAlertDialog(
      context,
      title: 'Sign In Failed',
      exception: exception,
    );
  }

  @override
  Widget build(BuildContext context) {
    // fp = Provider.of<AuthServiceProvider>(context);

    // logger.d(fp.getUser());

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // leading: (_isPressStart = true)
        //     ? IconButton(
        //         icon: Icon(Icons.arrow_back_rounded),
        //         onPressed: () {
        //           setState(() {
        //             _isPressStart = false;
        //           });
        //         },
        //       )
        //     : null,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: BackgroundColor,
      // For smooth transition between PreviewScreen and SignUpScreen
      body: AnimatedCrossFade(
        crossFadeState: (_isPressStart == false)
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
        duration: const Duration(milliseconds: 400),
        firstChild: _buildPreviewScreen(),
        secondChild: _buildSignInScreen(context),
      ),
      // body: _buildSignInScreen(context),
    );
  }

  Widget _buildPreviewScreen() {
    final controller = PageController();

    return Stack(
      fit: StackFit.expand,
      children: [
        PageView(
          controller: controller,
          children: <Widget>[
            // TODO: Add previews of the app
            AppPreviewWidget(),
            AppPreviewWidget(),
            AppPreviewWidget(),
            AppPreviewWidget(),
          ],
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SmoothPageIndicator(
                controller: controller,
                count: 4,
                effect: ScrollingDotsEffect(
                  activeDotColor: PrimaryColor,
                  activeDotScale: 1.5,
                  dotHeight: 8,
                  dotWidth: 8,
                  spacing: 10,
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Tooltip(
                  message: '시작하기',
                  child: RaisedButton(
                    color: PrimaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      height: 48,
                      width: 258,
                      child: Center(
                        child: Text(
                          '시작하기',
                          style: BodyText2,
                        ),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _isPressStart = true;
                      });
                    },
                    // onPressed: () {
                    //   return SignInScreen.create(context);
                    // },
                  ),
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSignInScreen(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Center(
              child: widget.isLoading
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(PrimaryColor),
                        ),
                        SizedBox(height: 24),
                        Text('Signing in...', style: BodyText2),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/logos/playerh_logo.png',
                          width: 200,
                          height: 200,
                        ),
                        SizedBox(height: 24),
                        Text('All About That Health', style: Headline5),
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
            logo: 'images/logos/google_logo.png',
            buttonText: '구글로 계속하기',
          ),

          /// Sign In With Facebook Button
          SocialSignInButton(
            color: Color(0xff1877F2),
            disabledColor: Color(0xff1877F2).withOpacity(0.38),
            onPressed:
                widget.isLoading ? null : () => _signInWithFacebook(context),
            logo: 'images/logos/facebook_logo.png',
            buttonText: '페이스북으로 계속하기',
          ),

          // TODO: Add Sign In with Kakao
          // SignInWithKakao(),

          /// Sign In With Apple Button
          if (Platform.isIOS)
            SocialSignInButton(
              color: Colors.white,
              disabledColor: Colors.white.withOpacity(0.38),
              onPressed:
                  widget.isLoading ? null : () => _signInWithApple(context),
              logo: 'images/logos/apple_logo.png',
              buttonText: '애플ID로 계속하기',
            ),
          SizedBox(height: 38),
        ],
      ),
    );
  }
}
