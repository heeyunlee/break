import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:workout_player/screens/sign_in/social_sign_in_button.dart';

import '../../common_widgets/show_exception_alert_dialog.dart';
import '../../constants.dart';
import '../../services/authentication_service.dart';
import 'app_preview_widget.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool doRemember = false;
  bool _isPressStart = true;
  bool _isLoading = false;

  // final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  AuthServiceProvider fp;

  void _showSignInError(Exception exception) {
    ShowExceptionAlertDialog(
      context,
      title: 'Sign In Failed',
      exception: exception,
    );
  }

  @override
  Widget build(BuildContext context) {
    fp = Provider.of<AuthServiceProvider>(context);

    // logger.d(fp.getUser());

    return Scaffold(
      // key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: (_isPressStart == true)
            ? IconButton(
                icon: Icon(Icons.arrow_back_rounded),
                onPressed: () {
                  setState(() {
                    _isPressStart = false;
                  });
                },
              )
            : null,
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
    );
  }

  Widget _buildPreviewScreen() {
    final controller = PageController();

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: PageView(
            controller: controller,
            children: <Widget>[
              // TODO: Add previews of the app
              AppPreviewWidget(),
              AppPreviewWidget(),
              AppPreviewWidget(),
              AppPreviewWidget(),
            ],
          ),
        ),
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
                  _isPressStart = !_isPressStart;
                });
              },
            ),
          ),
        ),
        SizedBox(height: 40),
      ],
    );
  }

  Widget _buildSignInScreen(BuildContext context) {
    // final bloc = Provider.of<SignInBloc>(context);

    // return StreamBuilder<bool>(
    //   stream: bloc.isLoadingStream,
    //   initialData: false,
    //   builder: (context, snapshot) {
    //     return _buildContext(context, snapshot.data);
    //   },
    // );
    return _buildContext(context);
  }

  Widget _buildContext(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Center(
              child: (_isLoading)
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
            onPressed: _isLoading ? null : () => _signInWithGoogle(context),
            logo: 'images/logos/google_logo.png',
            buttonText: '구글로 계속하기',
          ),

          /// Sign In With Facebook Button
          SocialSignInButton(
            color: Color(0xff1877F2),
            disabledColor: Color(0xff1877F2).withOpacity(0.38),
            onPressed: _isLoading ? null : () => _signInWithFacebook(context),
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
              onPressed: _isLoading ? null : () => _signInWithApple(context),
              logo: 'images/logos/apple_logo.png',
              buttonText: '애플ID로 계속하기',
            ),
          SizedBox(height: 38),
        ],
      ),
    );
  }

  /// SIGN IN WITH GOOGLE
  void _signInWithGoogle(BuildContext context) async {
    try {
      setState(() {
        _isLoading = !_isLoading;
      });
      await fp.signInWithGoogle(context);
      // await widget.bloc.signInWithGoogle();
    } on Exception catch (e) {
      print(e);
      _showSignInError(e);
    }
  }

  /// SIGN IN WITH FACEBOOK
  void _signInWithFacebook(BuildContext context) async {
    try {
      setState(() {
        _isLoading = !_isLoading;
      });
      await fp.signInWithFacebook(context);
    } on Exception catch (e) {
      _showSignInError(e);
    }
  }

  void _signInWithApple(BuildContext context) async {
    try {
      setState(() {
        _isLoading = !_isLoading;
      });
      await fp.signInWithApple(context);
    } on Exception catch (e) {
      _showSignInError(e);
    }
  }
}
