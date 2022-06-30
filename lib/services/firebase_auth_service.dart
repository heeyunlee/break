import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/services/logging.dart';

/// Interacts with [FirebaseAuth]
class FirebaseAuthService {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Stream<auth.User?> authStateChanges() => _auth.authStateChanges();

  auth.User? get currentUser => _auth.currentUser;

  auth.User? _user;

  auth.User? getUser() {
    return _user;
  }

  void setUser(auth.User value) {
    _user = value;
  }

  /// Sign In Anonymously with Firebase
  Future<auth.User?> signInAnonymously() async {
    logger.d('signInAnonymously triggered in auth');

    try {
      final userCredential = await _auth.signInAnonymously();
      final user = userCredential.user;
      final currentUser = _auth.currentUser;

      assert(user!.uid == currentUser!.uid);

      setUser(user!);

      logger.d(user.toString());

      return user;
    } on auth.FirebaseAuthException catch (e) {
      logger.e('FirebaseAuthException caught $e');
      throw auth.FirebaseAuthException(
        code: S.current.errorOccuredMessage,
        message: e.toString(),
      );
    }
  }

  /// Sign In With Email and Password with Firebase
  Future<auth.User?> signInWithEmailWithPassword(
    String email,
    String password,
  ) async {
    logger.d('signInWithEmailWithPassword triggered in auth');

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      final currentUser = _auth.currentUser;

      assert(user!.uid == currentUser!.uid);

      setUser(user!);

      logger.d(user.toString());

      return user;
    } on auth.FirebaseAuthException catch (e) {
      throw auth.FirebaseAuthException(
        code: S.current.errorOccuredMessage,
        message: e.toString(),
      );
    }
  }

  ///////// Create User With Email And Password
  Future<auth.User?> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    logger.d('createUserWithEmailAndPassword triggered in auth');

    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      final currentUser = _auth.currentUser;

      assert(user!.uid == currentUser!.uid);
      setUser(user!);

      logger.d(user.toString());

      return user;
    } on auth.FirebaseAuthException catch (e) {
      throw auth.FirebaseAuthException(
        code: S.current.errorOccuredMessage,
        message: e.toString(),
      );
    }
  }

  /// SIGN IN WITH GOOGLE
  Future<auth.User?> signInWithGoogle() async {
    logger.d('signInWithGoogle triggered in auth');

    final googleSignInAccount = await _googleSignIn.signIn();

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

        logger.d(user.toString());

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
  Future<auth.User?> signInWithFacebook() async {
    logger.d('signInWithFacebook auth triggered in auth');

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

      logger.d(user.toString());

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
      throw auth.FirebaseAuthException(
        code: 'ERROR_FACEBOOK_LOGIN_CANCELLED',
        message: 'Sign in Failed',
      );
    }
  }

  // Sign In With Apple
  Future<auth.User?> signInWithApple() async {
    logger.d('signInWithApple triggered in auth');

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

      logger.d(user.toString());

      return user;
    } on SignInWithAppleException catch (e) {
      throw auth.FirebaseAuthException(
        code: S.current.errorOccuredMessage,
        message: '$e',
      );
    } on auth.FirebaseAuthException catch (e) {
      throw auth.FirebaseAuthException(
        code: S.current.errorOccuredMessage,
        message: '$e',
      );
    }
  }

  Future<auth.User?> signInWithKakao() async {
    logger.d('signInwithKakao triggered in auth');

    try {
      final accessToken = await _getToken();
      final authResult = await _auth.signInWithCustomToken(
        await _verifyToken(accessToken),
      );

      final user = authResult.user;

      final currentUser = _auth.currentUser;
      assert(user!.uid == currentUser!.uid);
      setUser(user!);

      logger.d(user.toString());

      return user;
    } on KakaoAuthException catch (e) {
      throw auth.FirebaseAuthException(
        code: S.current.errorOccuredMessage,
        message: '$e',
      );
    } on KakaoClientException catch (e) {
      throw auth.FirebaseAuthException(
        code: S.current.errorOccuredMessage,
        message: '$e',
      );
      //
    } catch (e) {
      throw auth.FirebaseAuthException(
        code: S.current.errorOccuredMessage,
        message: '$e',
      );
      //
    }
  }

  Future<String> _getToken() async {
    final installed = await isKakaoTalkInstalled();
    // final authCode = installed
    //     ? await AuthCodeClient.instance.requestWithTalk()
    //     : await AuthCodeClient.instance.request();

    final authCode = installed
        ? await UserApi.instance.loginWithKakaoTalk()
        : await UserApi.instance.loginWithKakaoAccount();
    // final token = await AuthApi.instance.issueAccessToken(authCode);
    return authCode.accessToken;
    // await TokenManager.instance.setToken(token);
    // return token.accessToken;
  }

  Future<String> _verifyToken(String kakaoToken) async {
    try {
      final FirebaseFunctions functions = FirebaseFunctions.instance;
      final HttpsCallable callable =
          functions.httpsCallable('verifyKakaoToken');

      final HttpsCallableResult result = await callable.call(
        <String, dynamic>{
          'token': kakaoToken,
        },
      );

      if (result.data['error'] != null) {
        return Future.error(result.data['error'] as Object);
      } else {
        return result.data['token'].toString();
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  // Sign Out
  Future<void> signOut() async {
    final signedInWithGiigle = await _googleSignIn.isSignedIn();

    if (_user?.isAnonymous ?? false) {
      await _auth.currentUser?.delete();
    }

    if (signedInWithGiigle) {
      await _googleSignIn.signOut();
    }

    final facebookLogin = FacebookAuth.instance;
    await facebookLogin.logOut();

    await _auth.signOut();
  }
}
