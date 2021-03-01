import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
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
    auth.UserCredential userCredential =
        await auth.FirebaseAuth.instance.signInAnonymously();
    final auth.User user = userCredential.user;

    final auth.User currentUser = _auth.currentUser;
    assert(user.uid == currentUser.uid);
    setUser(user);

    return user;
  }

  // TODO: Add Sign up with Email

  /// SIGN IN WITH GOOGLE
  @override
  Future<auth.User> signInWithGoogle() async {
    // Trigger Authentication flow
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;
      print(googleAuth.accessToken);
      if (googleAuth.idToken != null) {
        final auth.GoogleAuthCredential credential =
            auth.GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        final auth.UserCredential authResult =
            await _auth.signInWithCredential(credential);
        final auth.User user = authResult.user;

        final auth.User currentUser = _auth.currentUser;
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
  Future<auth.User> signInWithFacebook() async {
    //Trigger the authentication flow
    final FacebookLogin facebookLogin = FacebookLogin();
    final FacebookLoginResult facebookLoginResult =
        await facebookLogin.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);

    switch (facebookLoginResult.status) {
      // LogIn Successful
      case FacebookLoginStatus.Success:
        // Create a new credential
        final accessToken = facebookLoginResult.accessToken;
        final auth.FacebookAuthCredential credential =
            auth.FacebookAuthProvider.credential(accessToken.token);

        // get the user
        final authResult = await _auth.signInWithCredential(credential);
        final auth.User user = authResult.user;

        final auth.User currentUser = _auth.currentUser;
        assert(user.uid == currentUser.uid);
        setUser(user);

        print(auth.AdditionalUserInfo().isNewUser);

        return user;

      // LogIn cancelled by User
      case FacebookLoginStatus.Cancel:
        throw auth.FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );

      // LogIn Error
      case FacebookLoginStatus.Error:
        throw auth.FirebaseAuthException(
          code: 'ERROR_FACEBOOK_LOGIN_FAILED',
          message: facebookLoginResult.error.developerMessage,
        );
      default:
        throw UnimplementedError();
    }
  }

  // Sign In With Apple
  Future<auth.User> signInWithApple() async {
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

      // Create a new credential
      final auth.OAuthProvider oAuthProvider = auth.OAuthProvider('apple.com');
      final auth.OAuthCredential credential = oAuthProvider.credential(
        accessToken: result.authorizationCode,
        idToken: result.identityToken,
      );

      // Using credential to get the user
      final auth.UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final auth.User user = authResult.user;

      final auth.User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);
      setUser(user);

      print(auth.AdditionalUserInfo().isNewUser);

      return user;
    } on auth.FirebaseAuthException catch (e) {
      logger.d(e);
      throw auth.FirebaseAuthException(
        code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
        message: '$e',
      );
    }
  }

  // Sign Out
  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final facebookLogin = FacebookLogin();
    await facebookLogin.logOut();
    await _auth.signOut();
  }
}
