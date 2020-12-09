import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../constants.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  final void Function(User) onSignIn;

  const AuthScreen({Key key, @required this.onSignIn}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _pressedStart = false;

  Future<void> _signInAnonymously() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      widget.onSignIn(userCredential.user);
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                style: Headline1,
              )),
              Container(
                child: Center(
                    child: Text(
                  'Placeholder of app preview 2',
                  style: Headline1,
                )),
              ),
              Container(
                child: Center(
                    child: Text(
                  'Placeholder of app preview 3',
                  style: Headline1,
                )),
              ),
              Container(
                child: Center(
                    child: Text(
                  'Placeholder of app preview 4',
                  style: Headline1,
                )),
              ),
              Container(
                child: Center(
                    child: Text(
                  'Placeholder of app preview 5',
                  style: Headline1,
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Center(
              child: Image.asset(
                'images/app_icon.png',
                width: 200,
                height: 200,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: RaisedButton(
              color: Color(0xffFEE500),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onPressed: () {},
              child: Container(
                height: 48,
                width: 258,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Image.asset(
                      'images/kakao_logo.png',
                      height: 18,
                      width: 18,
                    ),
                    Center(
                      child: Text('카카오로 계속하기', style: GoogleSignIn),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: RaisedButton(
              color: Color(0xff1877F2),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onPressed: () {},
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
                      child: Text('페이스북으로 계속하기', style: GoogleSignInWhite),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: RaisedButton(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onPressed: () {},
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
                      child: Text('구글로 계속하기', style: GoogleSignIn),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Text('or', style: Caption),
          RaisedButton(
            elevation: 0,
            color: Colors.transparent,
            child: Text(
              '이메일로 가입하기',
              style: Caption,
            ),
            onPressed: _signInAnonymously,
          ),
          SizedBox(height: 38),
        ],
      ),
    );
  }
}
