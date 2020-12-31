import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/models/user.dart';

import 'database.dart';

Logger logger = Logger();

abstract class AuthBase {
  Stream<User> get authStateChanges;
  Future<User> currentUser();
  Future<User> signInWithGoogle(BuildContext context);
}

class AuthService implements AuthBase {
  // Firebase authentication instance
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FacebookLogin facebookLogin = FacebookLogin();

  // Firebase user
  User _userFromFirebase(auth.User user) {
    if (user == null) {
      return null;
    }
    return User(userId: user.uid);
  }

  @override
  Stream<User> get authStateChanges {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  @override
  Future<User> currentUser() async {
    final user = await _auth.currentUser;
    return _userFromFirebase(user);
  }

  // TODO: Add Sign up with Email

  // Sign in with Google
  @override
  Future<User> signInWithGoogle(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);

    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount == null) {
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final auth.GoogleAuthCredential credential =
            auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final auth.UserCredential authResult =
            await _auth.signInWithCredential(credential);
        final auth.User user = authResult.user;

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

        return _userFromFirebase(authResult.user);
      } else {
        throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'Missing Google Auth Token',
        );
      }
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  // // Sign In with Facebook
  // Future<bool> signInWithFacebook(BuildContext context) async {
  //   final database = Provider.of<Database>(context, listen: false);
  //
  //   try {
  //     //Trigger the authentication flow
  //     final FacebookLoginResult facebookLoginResult =
  //         await facebookLogin.logIn(permissions: [
  //       FacebookPermission.publicProfile,
  //       FacebookPermission.email,
  //     ]);
  //
  //     // Create a new credential
  //     final accessToken = facebookLoginResult.accessToken;
  //     final auth.FacebookAuthCredential credential =
  //         auth.FacebookAuthProvider.credential(accessToken.token);
  //
  //     // get the user
  //     final authResult = await _auth.signInWithCredential(credential);
  //     final auth.User user = authResult.user;
  //
  //     // assert user data
  //     assert(user.email != null);
  //     assert(user.displayName != null);
  //     assert(!user.isAnonymous);
  //     assert(await user.getIdToken() != null);
  //
  //     final auth.User currentUser = _auth.currentUser;
  //     assert(user.uid == currentUser.uid);
  //     setUser(user);
  //
  //     // Create new user data on Firebase if Signing up for the first time
  //     final currentTime = Timestamp.now();
  //     final userData = User(
  //       userId: user.uid,
  //       userName: user.displayName,
  //       userEmail: user.email,
  //       signUpDate: currentTime,
  //       signUpProvider: 'Facebook',
  //     );
  //     await database.setUser(userData);
  //     print(userData);
  //
  //     return true;
  //   } on auth.FirebaseAuthException catch (e) {
  //     // for debugging purpose
  //     logger.e(e.toString());
  //     List<String> result = e.toString().split(", ");
  //     setLastFBMessage(result[1]);
  //
  //     // for users
  //     ShowExceptionAlertDialog(
  //       context,
  //       title: 'Sign in Failed',
  //       exception: e,
  //     );
  //   }
  //   return false;
  // }
  //
  // // Sign In With Apple
  // Future<bool> signInWithApple(BuildContext context) async {
  //   final database = Provider.of<Database>(context, listen: false);
  //
  //   //Trigger the authentication flow
  //   try {
  //     final result = await SignInWithApple.getAppleIDCredential(
  //       scopes: [
  //         AppleIDAuthorizationScopes.email,
  //         AppleIDAuthorizationScopes.fullName,
  //       ],
  //       webAuthenticationOptions: WebAuthenticationOptions(
  //         clientId: 'com.healtine.workoutPlayer',
  //         redirectUri: Uri.parse(
  //           'https://workout-player.firebaseapp.com/__/auth/handler',
  //         ),
  //       ),
  //     );
  //     print('1$result');
  //
  //     // Create a new credential
  //     final auth.OAuthProvider oAuthProvider = auth.OAuthProvider('apple.com');
  //     final auth.OAuthCredential credential = oAuthProvider.credential(
  //       accessToken: result.authorizationCode,
  //       idToken: result.identityToken,
  //     );
  //     print('2$credential');
  //
  //     // Using credential to get the user
  //     final auth.UserCredential authResult =
  //         await _auth.signInWithCredential(credential);
  //     final auth.User user = authResult.user;
  //     print('3$authResult');
  //
  //     // assert user data
  //     assert(user.email != null);
  //     assert(user.displayName != null);
  //     assert(!user.isAnonymous);
  //     assert(await user.getIdToken() != null);
  //
  //     final auth.User currentUser = _auth.currentUser;
  //     assert(user.uid == currentUser.uid);
  //     setUser(user);
  //
  //     // Create new user data on Firebase if Signing up for the first time
  //     final currentTime = Timestamp.now();
  //     final userData = User(
  //       userId: user.uid,
  //       userName: user.displayName,
  //       userEmail: user.email,
  //       signUpDate: currentTime,
  //       signUpProvider: 'Apple',
  //     );
  //     database.setUser(userData);
  //     print(userData);
  //
  //     return true;
  //   } on auth.FirebaseAuthException catch (e) {
  //     // for debugging purpose
  //     logger.e(e.toString());
  //     List<String> result = e.toString().split(", ");
  //     setLastFBMessage(result[1]);
  //
  //     // for users
  //     ShowExceptionAlertDialog(
  //       context,
  //       title: 'Sign in Failed',
  //       exception: e,
  //     );
  //   }
  //   return false;
  // }
  //
  // // TODO: Create Sign In with Kakao here
  //
  // // Firebase로부터 수신한 메시지 설정
  // setLastFBMessage(String msg) {
  //   _lastFirebaseResponse = msg;
  // }
  //
  // // Firebase로부터 수신한 메시지를 반환하고 삭제
  // getLastFBMessage() {
  //   String returnValue = _lastFirebaseResponse;
  //   _lastFirebaseResponse = null;
  //   return returnValue;
  // }
  //
  // // Sign Out
  // @override
  // Future<void> signOut() async {
  //   await _auth.signOut();
  //   await googleSignIn.signOut();
  //   await facebookLogin.logOut();
  // }
}
