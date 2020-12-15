import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../common_widgets/show_exception_alert_dialog.dart';
import '../../constants.dart';
import '../../services/apple_signin_available.dart';
import '../../services/auth.dart';

AuthScreenState pageState;

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  @override
  AuthScreenState createState() {
    pageState = AuthScreenState();
    return pageState;
  }
}

class AuthScreenState extends State<AuthScreen> {
  TextEditingController _mailCon = TextEditingController();
  TextEditingController _pwCon = TextEditingController();
  bool doRemember = false;
  bool isLoading = false;

  var _pressedStart = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  FirebaseProvider fp;

  @override
  void initState() {
    super.initState();
    getRememberInfo();
  }

  @override
  void dispose() {
    print('dispose called');
    setRememberInfo();
    _mailCon.dispose();
    _pwCon.dispose();
    super.dispose();
  }

  void _showSignInError(Exception exception) {
    ShowExceptionAlertDialog(
      context,
      title: 'Sign In Failed',
      exception: exception,
    );
  }

  @override
  Widget build(BuildContext context) {
    fp = Provider.of<FirebaseProvider>(context);

    logger.d(fp.getUser());

    return Scaffold(
      key: _scaffoldKey,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: BackgroundColor,
      body: (!_pressedStart) ? PreviewScreen() : SignUpScreen(),
    );
  }

  Widget PreviewScreen() {
    final controller = PageController();

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(
          child: PageView(
            controller: controller,
            children: <Widget>[
              Center(
                  child: Text(
                'Placeholder of app preview 1',
                style: Headline3,
              )),
              Container(
                child: Center(
                    child: Text(
                  'Placeholder of app preview 2',
                  style: Headline3,
                )),
              ),
              Container(
                child: Center(
                    child: Text(
                  'Placeholder of app preview 3',
                  style: Headline3,
                )),
              ),
              Container(
                child: Center(
                    child: Text(
                  'Placeholder of app preview 4',
                  style: Headline3,
                )),
              ),
              Container(
                child: Center(
                    child: Text(
                  'Placeholder of app preview 5',
                  style: Headline3,
                )),
              ),
            ],
          ),
        ),
        SmoothPageIndicator(
          controller: controller,
          count: 5,
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
          child: RaisedButton(
            color: PrimaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                _pressedStart = !_pressedStart;
                print(_pressedStart);
              });
            },
          ),
        ),
        SizedBox(height: 40),
      ],
    );
  }

  Widget SignUpScreen() {
    final appleSignInAvailable =
        Provider.of<AppleSignInAvailable>(context, listen: false);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Center(
              child: (isLoading)
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
                  : Image.asset(
                      'images/app_icon.png',
                      width: 200,
                      height: 200,
                    ),
            ),
          ),
          SignInWithGoogleWidget(),
          // SignInWithKakao(),
          SignInWithFacebookWidget(),
          if (appleSignInAvailable.isAvailable) SignInWithAppleWidget(),
          SizedBox(height: 38),
        ],
      ),
    );
  }

  Widget SignInWithGoogleWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: RaisedButton(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _signInWithGoogle();
        },
        child: Container(
          height: 48,
          width: 258,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Image.asset(
                'images/google_logo.png',
                height: 18,
                width: 18,
              ),
              Center(
                child: Text('구글로 계속하기', style: GoogleSignInStyle),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signInWithGoogle() async {
    try {
      setState(() {
        isLoading = true;
      });
      // // snackbar showing signing in...
      // _scaffoldKey.currentState
      //   ..hideCurrentSnackBar()
      //   ..showSnackBar(SnackBar(
      //     duration: Duration(seconds: 10),
      //     content: Row(
      //       children: <Widget>[
      //         CupertinoActivityIndicator(),
      //         Text("   Signing-In...", style: Caption1),
      //       ],
      //     ),
      //   ));
      await fp.signInWithGoogle(context);
      // _scaffoldKey.currentState.hideCurrentSnackBar();
    } on Exception catch (e) {
      _showSignInError(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  Widget SignInWithFacebookWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: RaisedButton(
        color: Color(0xff1877F2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          _signInWithFacebook();
        },
        child: Container(
          height: 48,
          width: 258,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Image.asset(
                'images/facebook_logo.png',
                height: 18,
                width: 18,
              ),
              Center(
                child: Text('페이스북으로 계속하기', style: GoogleSignInStyleWhite),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signInWithFacebook() async {
    try {
      setState(() {
        isLoading = true;
      });
      // // snackbar showing signing in...
      // _scaffoldKey.currentState
      //   ..hideCurrentSnackBar()
      //   ..showSnackBar(SnackBar(
      //     duration: Duration(seconds: 10),
      //     content: Row(
      //       children: <Widget>[
      //         CupertinoActivityIndicator(),
      //         Text("   Signing-In...", style: Caption1),
      //       ],
      //     ),
      //   ));
      await fp.signInWithFacebook(context);
      _scaffoldKey.currentState.hideCurrentSnackBar();
    } on Exception catch (e) {
      _showSignInError(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  // Widget SignInWithKakao() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
  //     child: RaisedButton(
  //       color: Color(0xffFEE500),
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  //       onPressed: () {},
  //       child: Container(
  //         height: 48,
  //         width: 258,
  //         child: Stack(
  //           alignment: Alignment.centerLeft,
  //           children: [
  //             Image.asset(
  //               'images/kakao_logo.png',
  //               height: 18,
  //               width: 18,
  //             ),
  //             Center(
  //               child: Text('카카오로 계속하기', style: GoogleSignInStyle),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget SignInWithAppleWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: RaisedButton(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: () => _signInWithApple(context),
        child: Container(
          height: 48,
          width: 258,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              SvgPicture.asset(
                'images/apple_logo.svg',
                height: 18,
                width: 18,
              ),
              Center(
                child: Text('애플ID로 계속하기', style: GoogleSignInStyle),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signInWithApple(BuildContext context) async {
    try {
      setState(() {
        isLoading = true;
      });
      // // snackbar showing signing in...
      // _scaffoldKey.currentState
      //   ..hideCurrentSnackBar()
      //   ..showSnackBar(SnackBar(
      //     duration: Duration(seconds: 10),
      //     content: Row(
      //       children: <Widget>[
      //         CupertinoActivityIndicator(),
      //         Text("   Signing-In...", style: Caption1),
      //       ],
      //     ),
      //   ));
      await fp.signInWithApple(context);
      _scaffoldKey.currentState.hideCurrentSnackBar();
    } on Exception catch (e) {
      _showSignInError(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  getRememberInfo() async {
    logger.d(doRemember);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      doRemember = (prefs.getBool("doRemember") ?? false);
    });
    if (doRemember) {
      setState(() {
        _mailCon.text = (prefs.getString("userEmail") ?? "");
        _pwCon.text = (prefs.getString("userPasswd") ?? "");
      });
    }
  }

  setRememberInfo() async {
    logger.d(doRemember);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("doRemember", doRemember);
    if (doRemember) {
      prefs.setString("userEmail", _mailCon.text);
      prefs.setString("userPasswd", _pwCon.text);
    }
  }
}
