import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as FireAuth;
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

import '../common_widgets/show_alert_dialog.dart';
import '../common_widgets/show_exception_alert_dialog.dart';

Logger logger = Logger();

class FirebaseProvider with ChangeNotifier {
  // Firebase authentication instance
  final FireAuth.FirebaseAuth _auth = FireAuth.FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookLogin facebookLogin = FacebookLogin();

  // Firebase user
  FireAuth.User _user;

  // For error handlings
  String _lastFirebaseResponse = "";

  FirebaseProvider() {
    logger.d("init FirebaseProvider");
    _prepareUser();
  }

  FireAuth.User getUser() {
    return _user;
  }

  void setUser(FireAuth.User value) {
    _user = value;
    notifyListeners();
  }

  // Get info of the user
  _prepareUser() {
    final FireAuth.User currentUser = _auth.currentUser;
    setUser(currentUser);
  }

  // Sign in with Google
  Future<bool> signInWithGoogle(BuildContext context) async {
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
      final FireAuth.GoogleAuthCredential credential =
          FireAuth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, get the user
      final FireAuth.UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final FireAuth.User user = authResult.user;

      // assert user data
      assert(user.email != null);
      assert(user.displayName != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FireAuth.User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);
      setUser(user);
      return true;
    } on FireAuth.FirebaseAuthException catch (e) {
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
  }

  // Sign In with Facebook
  Future<bool> signInWithFacebook(BuildContext context) async {
    try {
      //Trigger the authentication flow
      final FacebookLoginResult facebookLoginResult =
          await facebookLogin.logIn(permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email,
      ]);

      // Create a new credential
      final accessToken = facebookLoginResult.accessToken;
      final FireAuth.FacebookAuthCredential credential =
          FireAuth.FacebookAuthProvider.credential(accessToken.token);

      // get the user
      final authResult = await _auth.signInWithCredential(credential);
      final FireAuth.User user = authResult.user;

      // assert user data
      assert(user.email != null);
      assert(user.displayName != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FireAuth.User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);
      setUser(user);
      return true;
    } on FireAuth.FirebaseAuthException catch (e) {
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
  }

  // Sign In With Apple
  Future<bool> signInWithApple(BuildContext context,
      {List<Scope> scopes = const []}) async {
    // 1. perform the sign-in request
    final result = await AppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);

    // 2. check the result
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential;
        final oAuthProvider = FireAuth.OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode),
        );

        // get the user
        final authResult = await _auth.signInWithCredential(credential);
        final FireAuth.User user = authResult.user;

        if (scopes.contains(Scope.fullName)) {
          final displayName =
              '${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}';
          await user.updateProfile(displayName: displayName);
        }
        // assert user data
        assert(user.email != null);
        assert(user.displayName != null);
        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);

        final FireAuth.User currentUser = _auth.currentUser;
        assert(user.uid == currentUser.uid);
        setUser(user);
        return true;
      case AuthorizationStatus.error:
        throw showAlertDialog(
          context,
          title: 'ERROR_AUTHORIZATION_DENIED',
          content: result.error.toString(),
          defaultActionText: 'OK',
        );

      case AuthorizationStatus.cancelled:
        throw showAlertDialog(
          context,
          title: 'ERROR_ABORTED_BY_USER',
          content: result.error.toString(),
          defaultActionText: 'OK',
        );
      default:
        throw UnimplementedError();
    }
  }

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
