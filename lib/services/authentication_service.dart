import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:workout_player/models/user.dart';

import '../common_widgets/show_alert_dialog.dart';
import '../common_widgets/show_exception_alert_dialog.dart';
import 'database.dart';

Logger logger = Logger();

class AuthServiceProvider with ChangeNotifier {
  // Firebase authentication instance
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookLogin facebookLogin = FacebookLogin();

  // Firebase user
  auth.User _user;

  // For error handlings
  String _lastFirebaseResponse = "";

  FirebaseProvider() {
    logger.d("init FirebaseProvider");
    _prepareUser();
  }

  auth.User getUser() {
    return _user;
  }

  void setUser(auth.User value) {
    _user = value;
    notifyListeners();
  }

  // Get info of the user
  _prepareUser() {
    final auth.User currentUser = _auth.currentUser;
    setUser(currentUser);
  }

  // TODO: Add Sign up with Email

  // Sign in with Google
  Future<bool> signInWithGoogle(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);

    try {
      //Trigger the authentication flow
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount == null) {
        return showAlertDialog(
          context,
          title: 'CANCELLED_SIGN_IN',
          content: 'Sign in was cancelled by user',
          defaultActionText: 'OK',
        );
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;

      // Create a new credential
      final auth.GoogleAuthCredential credential =
          auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, get the user
      final auth.UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final auth.User user = authResult.user;

      // assert user data
      assert(user.email != null);
      assert(user.displayName != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final auth.User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);
      setUser(user);

      // Create new user data on Firebase if Signing up for the first time
      final currentTime = Timestamp.now();
      final userData = User(
        userId: user.uid,
        userName: user.displayName,
        userEmail: user.email,
        signUpDate: currentTime,
        signUpProvider: 'Google',
      );
      await database.setUser(userData);
      print(userData);

      return true;
    } on auth.FirebaseAuthException catch (e) {
      // for debugging purpose
      logger.e(e.toString());
      List<String> result = e.toString().split(", ");
      setLastFBMessage(result[1]);

      // for users
      ShowExceptionAlertDialog(
        context,
        title: 'Sign in Failed',
        exception: e,
      );
    }
    return false;
  }

  // Sign In with Facebook
  Future<bool> signInWithFacebook(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);

    try {
      //Trigger the authentication flow
      final FacebookLoginResult facebookLoginResult =
          await facebookLogin.logIn(permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email,
      ]);

      // Create a new credential
      final accessToken = facebookLoginResult.accessToken;
      final auth.FacebookAuthCredential credential =
          auth.FacebookAuthProvider.credential(accessToken.token);

      // get the user
      final authResult = await _auth.signInWithCredential(credential);
      final auth.User user = authResult.user;

      // assert user data
      assert(user.email != null);
      assert(user.displayName != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final auth.User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);
      setUser(user);

      // Create new user data on Firebase if Signing up for the first time
      final currentTime = Timestamp.now();
      final userData = User(
        userId: user.uid,
        userName: user.displayName,
        userEmail: user.email,
        signUpDate: currentTime,
        signUpProvider: 'Facebook',
      );
      await database.setUser(userData);
      print(userData);

      return true;
    } on auth.FirebaseAuthException catch (e) {
      // for debugging purpose
      logger.e(e.toString());
      List<String> result = e.toString().split(", ");
      setLastFBMessage(result[1]);

      // for users
      ShowExceptionAlertDialog(
        context,
        title: 'Sign in Failed',
        exception: e,
      );
    }
    return false;
  }

  // Sign In With Apple
  Future<bool> signInWithApple(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);

    //Trigger the authentication flow
    try {
      final result = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'com.healtine.workoutPlayer',
          redirectUri: Uri.parse(
            'https://workout-player.firebaseapp.com/__/auth/handler',
          ),
        ),
      );
      print('1$result');

      // Create a new credential
      final auth.OAuthProvider oAuthProvider = auth.OAuthProvider('apple.com');
      final auth.OAuthCredential credential = oAuthProvider.credential(
        accessToken: result.authorizationCode,
        idToken: result.identityToken,
      );
      print('2$credential');

      // Using credential to get the user
      final auth.UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final auth.User user = authResult.user;
      print('3$authResult');

      // assert user data
      assert(user.email != null);
      assert(user.displayName != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final auth.User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);
      setUser(user);

      // Create new user data on Firebase if Signing up for the first time
      final currentTime = Timestamp.now();
      final userData = User(
        userId: user.uid,
        userName: user.displayName,
        userEmail: user.email,
        signUpDate: currentTime,
        signUpProvider: 'Apple',
      );
      database.setUser(userData);
      print(userData);

      return true;
    } on auth.FirebaseAuthException catch (e) {
      // for debugging purpose
      logger.e(e.toString());
      List<String> result = e.toString().split(", ");
      setLastFBMessage(result[1]);

      // for users
      ShowExceptionAlertDialog(
        context,
        title: 'Sign in Failed',
        exception: e,
      );
    }
    return false;
  }

  // TODO: Create Sign In with Kakao here

  // Firebase로부터 수신한 메시지 설정
  setLastFBMessage(String msg) {
    _lastFirebaseResponse = msg;
  }

  // Firebase로부터 수신한 메시지를 반환하고 삭제
  getLastFBMessage() {
    String returnValue = _lastFirebaseResponse;
    _lastFirebaseResponse = null;
    return returnValue;
  }

  // Sign Out
  @override
  Future<void> signOut() async {
    await _auth.signOut();
    await googleSignIn.signOut();
    await facebookLogin.logOut();
  }
}
