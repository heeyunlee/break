import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:flutter_kakao_login/flutter_kakao_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

Logger logger = Logger();

abstract class AuthBase {
  auth.User get currentUser;
  Stream<auth.User> authStateChanges();
  Future<auth.User> signInAnonymously();
  Future<auth.User> signInWithGoogle();
  Future<auth.User> signInWithFacebook();
  Future<auth.User> signInWithApple();
  // Future<auth.User> signInWithKakao();

  Future<void> signOut();
}

class AuthService implements AuthBase {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  @override
  Stream<auth.User> authStateChanges() => _auth.authStateChanges();

  @override
  auth.User get currentUser => _auth.currentUser;

  // Firebase user
  auth.User _user;

  auth.User getUser() {
    return _user;
  }

  void setUser(auth.User value) {
    _user = value;
  }

  @override
  Future<auth.User> signInAnonymously() async {
    var userCredential = await auth.FirebaseAuth.instance.signInAnonymously();
    final user = userCredential.user;

    final currentUser = _auth.currentUser;
    assert(user.uid == currentUser.uid);
    setUser(user);

    return user;
  }

  // TODO: Add Sign up with Email

  /// SIGN IN WITH GOOGLE
  @override
  Future<auth.User> signInWithGoogle() async {
    // Trigger Authentication flow
    final googleSignIn = GoogleSignIn();
    final googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      // Obtain the auth details from the request
      final googleAuth = await googleSignInAccount.authentication;
      print(googleAuth.accessToken);
      if (googleAuth.idToken != null) {
        final auth.GoogleAuthCredential credential =
            auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final authResult = await _auth.signInWithCredential(credential);
        final user = authResult.user;

        final currentUser = _auth.currentUser;
        assert(user.uid == currentUser.uid);
        setUser(user);

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
  Future<auth.User> signInWithFacebook() async {
    // //Trigger the authentication flow
    try {
      final facebookLogin = await FacebookAuth.instance.login();
      final credential = auth.FacebookAuthProvider.credential(
        facebookLogin.token,
      );
      final authResult = await _auth.signInWithCredential(credential);
      final user = authResult.user;
      final currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);
      setUser(user);

      return user;
    } on FacebookAuthException catch (e) {
      switch (e.errorCode) {
        case FacebookAuthErrorCode.OPERATION_IN_PROGRESS:
          logger.d(e.errorCode);
          throw auth.FirebaseAuthException(
            code: 'ERROR_FACEBOOK_LOGIN_CANCELLED',
            message: 'You have a previous login operation in progress',
          );
        case FacebookAuthErrorCode.CANCELLED:
          logger.d(e.errorCode);

          throw auth.FirebaseAuthException(
            code: 'ERROR_FACEBOOK_LOGIN_CANCELLED',
            message: 'Login Cancelled',
          );
        case FacebookAuthErrorCode.FAILED:
          logger.d(e.errorCode);

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
  Future<auth.User> signInWithApple() async {
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
      assert(user.uid == currentUser.uid);
      setUser(user);

      print(auth.AdditionalUserInfo(isNewUser: true).isNewUser);

      return user;
    } on auth.FirebaseAuthException catch (e) {
      logger.d(e);
      throw auth.FirebaseAuthException(
        code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
        message: '$e',
      );
    }
  }

  // /// SIGN IN WITH Kakao
  // @override
  // Future<auth.User> signInWithKakao() async {
  //   // ignore: omit_local_variable_types
  //   final FlutterKakaoLogin kakaoSignIn = FlutterKakaoLogin();
  //   await kakaoSignIn.init('c17f0f1bc6e039d488fb5264fdf93a10');
  //   final result = await kakaoSignIn.logIn();
  //   final token = await (kakaoSignIn.currentToken);
  //   final accessToken = token.accessToken;
  //   print(accessToken);
  //   // print('sd');
  //   // final oAuthProvider = auth.OAuthProvider('kakao.com');
  //   // final credential = oAuthProvider.credential(
  //   //   accessToken: result.token.accessToken,
  //   // );
  //   // print(credential);
  // }

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
