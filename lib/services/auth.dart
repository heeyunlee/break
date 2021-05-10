import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/auth.dart';
import 'package:logger/logger.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

Logger logger = Logger();

abstract class AuthBase {
  auth.User? get currentUser;
  Stream<auth.User?> authStateChanges();
  Stream<auth.User?> idTokenChanges();
  Future<auth.User?> signInAnonymously();
  Future<auth.User?> signInWithEmailWithPassword(String email, String password);
  Future<auth.User?> createUserWithEmailAndPassword(
    String email,
    String password,
  );
  Future<auth.User?> signInWithGoogle();
  Future<auth.User?> signInWithFacebook();
  Future<auth.User?> signInWithApple();
  Future<auth.User?> signInWithKakao();

  Future<void> signOut();
}

class AuthService implements AuthBase {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  @override
  Stream<auth.User?> authStateChanges() => _auth.authStateChanges();

  @override
  Stream<auth.User?> idTokenChanges() => _auth.idTokenChanges();

  @override
  auth.User? get currentUser => _auth.currentUser;

  // Firebase user
  auth.User? _user;

  auth.User? getUser() {
    return _user;
  }

  void setUser(auth.User value) {
    _user = value;
  }

  ///////// Sign In Anonymously
  @override
  Future<auth.User?> signInAnonymously() async {
    debugPrint('signInAnonymously triggered in auth');
    var userCredential = await auth.FirebaseAuth.instance.signInAnonymously();
    final user = userCredential.user;

    final currentUser = _auth.currentUser;
    assert(user!.uid == currentUser!.uid);
    setUser(user!);

    return user;
  }

  ///////// Sign In With Email and Password
  @override
  Future<auth.User?> signInWithEmailWithPassword(
    String email,
    String password,
  ) async {
    debugPrint('signInWithEmailWithPassword triggered in auth');

    var userCredential =
        await auth.FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;

    final currentUser = _auth.currentUser;
    assert(user!.uid == currentUser!.uid);
    setUser(user!);

    return user;
  }

  ///////// Create User With Email And Password
  @override
  Future<auth.User?> createUserWithEmailAndPassword(
      String email, String password) async {
    debugPrint('createUserWithEmailAndPassword triggered in auth');

    var userCredential =
        await auth.FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;

    final currentUser = _auth.currentUser;
    assert(user!.uid == currentUser!.uid);
    setUser(user!);

    return user;
  }

  /// SIGN IN WITH GOOGLE
  @override
  Future<auth.User?> signInWithGoogle() async {
    debugPrint('signInWithGoogle triggered in auth');

    // Trigger Authentication flow
    final googleSignIn = GoogleSignIn();
    final googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      // Obtain the auth details from the request
      final googleAuth = await googleSignInAccount.authentication;
      if (googleAuth.idToken != null) {
        final auth.OAuthCredential credential =
            auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final authResult = await _auth.signInWithCredential(credential);
        final user = authResult.user;

        final currentUser = _auth.currentUser;
        assert(user!.uid == currentUser!.uid);
        setUser(user!);

        return user;
      } else {
        throw auth.FirebaseAuthException(
          code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
          message: 'Missing Google ID Token',
        );
      }
    } else {
      throw auth.FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  // Sign In with Facebook
  @override
  Future<auth.User?> signInWithFacebook() async {
    // Trigger the authentication flow
    debugPrint('signInWithFacebook auth triggered in auth');
    try {
      final facebookLogin = await FacebookAuth.instance.login();
      if (facebookLogin.status == LoginStatus.success) {
        final credential = auth.FacebookAuthProvider.credential(
          facebookLogin.accessToken!.token,
        );

        final authResult = await _auth.signInWithCredential(credential);
        final user = authResult.user;

        final currentUser = _auth.currentUser;
        assert(user!.uid == currentUser!.uid);
        setUser(user!);

        return user;
      } else if (facebookLogin.status == LoginStatus.cancelled) {
        throw auth.FirebaseAuthException(
          code: 'ERROR_FACEBOOK_LOGIN_CANCELLED',
          message: 'Sign in aborted by user',
        );
      } else if (facebookLogin.status == LoginStatus.failed) {
        throw auth.FirebaseAuthException(
          code: 'ERROR_FACEBOOK_LOGIN_CANCELLED',
          message: 'Sign in Failed',
        );
      } else {
        return null;
      }
    } on auth.FirebaseAuthException catch (e) {
      switch (e.message) {
        case FacebookAuthErrorCode.OPERATION_IN_PROGRESS:
          logger.d(e.message);
          throw auth.FirebaseAuthException(
            code: 'ERROR_FACEBOOK_LOGIN_CANCELLED',
            message: 'You have a previous login operation in progress',
          );
        case FacebookAuthErrorCode.CANCELLED:
          logger.d(e.message);

          throw auth.FirebaseAuthException(
            code: 'ERROR_FACEBOOK_LOGIN_CANCELLED',
            message: 'Login Cancelled',
          );
        case FacebookAuthErrorCode.FAILED:
          logger.d(e.message);

          throw auth.FirebaseAuthException(
            code: 'ERROR_FACEBOOK_LOGIN_FAILED',
            message: 'Login Failed',
          );
        default:
          throw UnimplementedError();
      }
    }
  }

  // Sign In With Apple
  @override
  Future<auth.User?> signInWithApple() async {
    debugPrint('signInWithApple triggered in auth');

    //Trigger the authentication flow
    try {
      final result = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: 'com.healtine.playerh',
          redirectUri: Uri.parse(
            'https://player-h.firebaseapp.com/__/auth/handler',
          ),
        ),
      );

      // Create a new credential
      final oAuthProvider = auth.OAuthProvider('apple.com');
      final credential = oAuthProvider.credential(
        accessToken: result.authorizationCode,
        idToken: result.identityToken,
      );

      // Using credential to get the user
      final authResult = await _auth.signInWithCredential(credential);
      final user = authResult.user;

      final currentUser = _auth.currentUser;
      assert(user!.uid == currentUser!.uid);
      setUser(user!);

      return user;
    } on auth.FirebaseAuthException catch (e) {
      logger.d(e);
      throw auth.FirebaseAuthException(
        code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
        message: '$e',
      );
    }
  }

  @override
  Future<auth.User?> signInWithKakao() async {
    debugPrint('signInwithKakao triggered in auth');
    try {
      final accessToken = await _getToken();
      final authResult = await _auth.signInWithCustomToken(
        await _verifyToken(accessToken),
      );

      final user = authResult.user;

      final currentUser = _auth.currentUser;
      assert(user!.uid == currentUser!.uid);
      setUser(user!);

      return user;
    } on KakaoAuthException catch (e) {
      throw auth.FirebaseAuthException(
        code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
        message: '$e',
      );
      // some error happened during the course of user login... deal with it.
    } on KakaoClientException catch (e) {
      throw auth.FirebaseAuthException(
        code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
        message: '$e',
      );
      //
    } catch (e) {
      throw auth.FirebaseAuthException(
        code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
        message: '$e',
      );
      //
    }
  }

  Future<String> _getToken() async {
    debugPrint('get token function triggered');
    final installed = await isKakaoTalkInstalled();
    final authCode = installed
        ? await AuthCodeClient.instance.requestWithTalk()
        : await AuthCodeClient.instance.request();
    final token = await AuthApi.instance.issueAccessToken(authCode);

    await AccessTokenStore.instance.toStore(token);
    return token.accessToken;
  }

  Future<String> _verifyToken(String kakaoToken) async {
    debugPrint('_verifyToken function triggered in auth');

    try {
      FirebaseFunctions functions = FirebaseFunctions.instance;
      HttpsCallable callable = functions.httpsCallable('verifyKakaoToken');

      final HttpsCallableResult result = await callable.call(
        <String, dynamic>{
          'token': kakaoToken,
        },
      );

      if (result.data['error'] != null) {
        return Future.error(result.data['error']);
      } else {
        return result.data['token'];
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  // Sign Out
  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();

    final facebookLogin = FacebookAuth.instance;
    await facebookLogin.logOut();

    await _auth.signOut();
  }
}
