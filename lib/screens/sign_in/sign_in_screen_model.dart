import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/classes/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/services/mixpanel_manager.dart';
import 'package:workout_player/widgets/get_snackbar_widget.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';

final signInScreenProvider =
    ChangeNotifierProvider((ref) => SignInScreenModel());

class SignInScreenModel extends ChangeNotifier {
  AuthService? auth;
  FirestoreDatabase? database;

  SignInScreenModel({
    this.auth,
    this.database,
  }) {
    final container = ProviderContainer();
    auth = container.read(authServiceProvider2);
    database = container.read(databaseProvider2(auth!.currentUser?.uid));
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  final locale = Intl.getCurrentLocale();

  void toggleIsLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  final randomNumber = Random().nextInt(6);

  // SIGN IN ANONYMOUSLY
  Future<void> signInAnonymously(BuildContext context) async {
    logger.d('sign in with Anonymously pressed');
    MixpanelManager.track('signed up Anonymously');

    setIsLoading(true);

    try {
      await auth!.signInAnonymously();

      final firebaseUser = auth!.currentUser!;
      final User? user = await database!.getUserDocument(firebaseUser.uid);
      final deviceInfo = await _getDeviceInfo();
      final currentTime = Timestamp.now();

      // Create new data if it does NOT exist
      if (user == null) {
        final uniqueId = UniqueKey().toString();
        final id = 'Herakles $uniqueId';

        final userData = User(
          userId: firebaseUser.uid,
          displayName: id,
          userName: id,
          userEmail: null,
          signUpDate: currentTime,
          signUpProvider: 'Anonymous',
          totalWeights: 0,
          totalNumberOfWorkouts: 0,
          unitOfMass: (locale == 'ko') ? 0 : 1,
          lastLoginDate: currentTime,
          savedRoutines: [],
          savedWorkouts: [],
          backgroundImageIndex: randomNumber,
          deviceInfo: deviceInfo,
          creationTime: firebaseUser.metadata.creationTime,
        );
        await database!.setUser(userData);

        Navigator.of(context).popUntil((route) => route.isFirst);

        getSnackbarWidget(
          S.current.signInSuccessful,
          S.current.firstSignInSnackbarMessage(userData.displayName),
          duration: 4,
        );
      } else {
        // Update Data if exist
        final Map<String, dynamic> updatedUserData = {
          'lastLoginDate': currentTime,
        };

        if (user.deviceInfo == null) {
          updatedUserData['deviceInfo'] = deviceInfo;
        }

        if (user.creationTime == null) {
          updatedUserData['creationTime'] = firebaseUser.metadata.creationTime;
        }

        await database!.updateUser(
          auth!.currentUser!.uid,
          updatedUserData,
        );

        Navigator.of(context).popUntil((route) => route.isFirst);

        getSnackbarWidget(
          S.current.signInSuccessful,
          S.current.signInSnackbarMessage(user.displayName),
          duration: 4,
        );
      }
    } on FirebaseException catch (e) {
      _showSignInError(e, context);
    }
    setIsLoading(false);
  }

  /// SIGN IN WITH GOOGLE
  Future<void> signInWithGoogle(BuildContext context) async {
    logger.d('sign in with google pressed');
    MixpanelManager.track('sign up with Google Used');

    setIsLoading(true);

    try {
      await auth!.signInWithGoogle();

      final firebaseUser = auth!.currentUser!;
      final User? user = await database!.getUserDocument(firebaseUser.uid);
      final deviceInfo = await _getDeviceInfo();
      final currentTime = Timestamp.now();

      // Create new data if it does NOT exist
      if (user == null) {
        final uniqueId = UniqueKey().toString();
        final displayName = firebaseUser.providerData[0].displayName ??
            firebaseUser.displayName ??
            'Herakles $uniqueId';

        final email = firebaseUser.providerData[0].email ?? firebaseUser.email;

        final userData = User(
          userId: firebaseUser.uid,
          displayName: displayName,
          userName: displayName,
          userEmail: email,
          signUpDate: currentTime,
          signUpProvider: firebaseUser.providerData[0].providerId,
          totalWeights: 0,
          totalNumberOfWorkouts: 0,
          unitOfMass: (locale == 'ko') ? 0 : 1,
          lastLoginDate: currentTime,
          savedRoutines: [],
          savedWorkouts: [],
          backgroundImageIndex: randomNumber,
          deviceInfo: deviceInfo,
        );
        await database!.setUser(userData);
        Navigator.of(context).popUntil((route) => route.isFirst);

        getSnackbarWidget(
          S.current.signInSuccessful,
          S.current.firstSignInSnackbarMessage(userData.displayName),
          duration: 4,
        );
      } else {
        // Update Data if exist
        final Map<String, dynamic> updatedUserData = {
          'lastLoginDate': currentTime,
        };

        if (user.deviceInfo == null) {
          print('device info is NULL');

          updatedUserData['deviceInfo'] = deviceInfo;
        }

        if (user.creationTime == null) {
          updatedUserData['creationTime'] = firebaseUser.metadata.creationTime;
        }

        await database!.updateUser(
          auth!.currentUser!.uid,
          updatedUserData,
        );
        Navigator.of(context).popUntil((route) => route.isFirst);

        getSnackbarWidget(
          S.current.signInSuccessful,
          S.current.signInSnackbarMessage(user.displayName),
          duration: 4,
        );
      }
    } on FirebaseException catch (e) {
      _showSignInError(e, context);
    }

    setIsLoading(false);
  }

  /// SIGN IN WITH FACEBOOK
  Future<void> signInWithFacebook(BuildContext context) async {
    logger.d('sign in with facebook pressed');
    MixpanelManager.track('sign up with Facebook pressed');

    setIsLoading(true);

    try {
      await auth!.signInWithFacebook();

      final firebaseUser = auth!.currentUser!;
      final User? user = await database!.getUserDocument(firebaseUser.uid);
      final deviceInfo = await _getDeviceInfo();
      final currentTime = Timestamp.now();

      print('user data is ${firebaseUser.toString()}');

      // Create new data do NOT exist
      if (user == null) {
        final uniqueId = UniqueKey().toString();
        final displayName = firebaseUser.providerData[0].displayName ??
            firebaseUser.displayName ??
            'Herakles $uniqueId';

        final email = firebaseUser.providerData[0].email ?? firebaseUser.email;

        final userData = User(
          userId: firebaseUser.uid,
          displayName: displayName,
          userName: displayName,
          userEmail: email,
          signUpDate: currentTime,
          signUpProvider: firebaseUser.providerData[0].providerId,
          totalWeights: 0,
          totalNumberOfWorkouts: 0,
          unitOfMass: (locale == 'ko') ? 0 : 1,
          lastLoginDate: currentTime,
          savedRoutines: [],
          savedWorkouts: [],
          backgroundImageIndex: randomNumber,
          deviceInfo: deviceInfo,
          creationTime: firebaseUser.metadata.creationTime,
          profileUrl: firebaseUser.photoURL,
        );
        await database!.setUser(userData);

        Navigator.of(context).popUntil((route) => route.isFirst);

        getSnackbarWidget(
          S.current.signInSuccessful,
          S.current.firstSignInSnackbarMessage(userData.displayName),
          duration: 4,
        );
      } else {
        // Update Data if exist
        final Map<String, dynamic> updatedUserData = {
          'lastLoginDate': currentTime,
        };

        if (user.deviceInfo == null) {
          updatedUserData['deviceInfo'] = deviceInfo;
        }

        if (user.creationTime == null) {
          updatedUserData['creationTime'] = firebaseUser.metadata.creationTime;
        }

        await database!.updateUser(
          auth!.currentUser!.uid,
          updatedUserData,
        );

        Navigator.of(context).popUntil((route) => route.isFirst);

        getSnackbarWidget(
          S.current.signInSuccessful,
          S.current.signInSnackbarMessage(user.displayName),
          duration: 4,
        );
      }
    } on FirebaseException catch (e) {
      _showSignInError(e, context);
    }
    setIsLoading(false);
  }

  /// SIGN IN WITH APPLE
  Future<void> signInWithApple(BuildContext context) async {
    logger.d('sign in with Apple pressed');
    MixpanelManager.track('sign up with Apple pressed');

    setIsLoading(true);

    try {
      await auth!.signInWithApple();

      final firebaseUser = auth!.currentUser!;
      final User? user = await database!.getUserDocument(firebaseUser.uid);
      final deviceInfo = await _getDeviceInfo();
      final currentTime = Timestamp.now();

      // Create new data do NOT exist
      if (user == null) {
        final uniqueId = UniqueKey().toString();
        final id = 'Herakles $uniqueId';

        final userData = User(
          userId: firebaseUser.uid,
          displayName: firebaseUser.providerData[0].displayName ??
              firebaseUser.displayName ??
              id,
          userName: firebaseUser.providerData[0].displayName ??
              firebaseUser.displayName ??
              id,
          userEmail: firebaseUser.providerData[0].email ?? firebaseUser.email,
          signUpDate: currentTime,
          signUpProvider: firebaseUser.providerData[0].providerId,
          totalWeights: 0,
          totalNumberOfWorkouts: 0,
          unitOfMass: (locale == 'ko') ? 0 : 1,
          lastLoginDate: currentTime,
          savedRoutines: [],
          savedWorkouts: [],
          backgroundImageIndex: randomNumber,
          deviceInfo: deviceInfo,
        );

        await database!.setUser(userData);

        Navigator.of(context).popUntil((route) => route.isFirst);

        getSnackbarWidget(
          S.current.signInSuccessful,
          S.current.firstSignInSnackbarMessage(userData.displayName),
          duration: 4,
        );
      } else {
        // Update Data if exist
        final Map<String, dynamic> updatedUserData = {
          'lastLoginDate': currentTime,
        };

        if (user.deviceInfo == null) {
          updatedUserData['deviceInfo'] = deviceInfo;
        }

        if (user.creationTime == null) {
          updatedUserData['creationTime'] = firebaseUser.metadata.creationTime;
        }

        await database!.updateUser(auth!.currentUser!.uid, updatedUserData);

        Navigator.of(context).popUntil((route) => route.isFirst);

        getSnackbarWidget(
          S.current.signInSuccessful,
          S.current.signInSnackbarMessage(user.displayName),
          duration: 4,
        );
      }
    } on FirebaseException catch (e) {
      _showSignInError(e, context);
    }
    setIsLoading(false);
  }

  /// SIGN IN WITH Kakao
  Future<void> signInWithKakao(BuildContext context) async {
    logger.d('sign in with Kakao pressed');
    MixpanelManager.track('sign up with Kakao pressed');

    setIsLoading(true);

    try {
      await auth!.signInWithKakao();

      final firebaseUser = auth!.currentUser!;
      final User? user = await database!.getUserDocument(firebaseUser.uid);
      final deviceInfo = await _getDeviceInfo();
      final currentTime = Timestamp.now();

      // Create new data do NOT exist
      if (user == null) {
        final uniqueId = UniqueKey().toString();

        final userData = User(
          userId: firebaseUser.uid,
          userName: firebaseUser.displayName ?? 'Herakles $uniqueId',
          displayName: firebaseUser.displayName ?? 'Herakles $uniqueId',
          userEmail: firebaseUser.email,
          signUpDate: currentTime,
          signUpProvider: 'kakao',
          totalWeights: 0,
          totalNumberOfWorkouts: 0,
          unitOfMass: 1,
          lastLoginDate: currentTime,
          savedRoutines: [],
          savedWorkouts: [],
          backgroundImageIndex: randomNumber,
          deviceInfo: deviceInfo,
        );

        await database!.setUser(userData);

        Navigator.of(context).popUntil((route) => route.isFirst);

        getSnackbarWidget(
          S.current.signInSuccessful,
          S.current.firstSignInSnackbarMessage(userData.displayName),
          duration: 4,
        );
      } else {
        // Update Data if exist
        final Map<String, dynamic> updatedUserData = {
          'lastLoginDate': currentTime,
        };

        if (user.deviceInfo == null) {
          updatedUserData['deviceInfo'] = deviceInfo;
        }

        if (user.creationTime == null) {
          updatedUserData['creationTime'] = firebaseUser.metadata.creationTime;
        }

        await database!.updateUser(auth!.currentUser!.uid, updatedUserData);

        Navigator.of(context).popUntil((route) => route.isFirst);

        getSnackbarWidget(
          S.current.signInSuccessful,
          S.current.signInSnackbarMessage(user.displayName),
        );
      }
    } on FirebaseException catch (e) {
      _showSignInError(e, context);
    }
    setIsLoading(false);
  }

  void _showSignInError(FirebaseException exception, BuildContext context) {
    logger.e(exception);

    showExceptionAlertDialog(
      context,
      title: S.current.signInFailed,
      exception: _getExceptionMessage(exception),
    );
  }

  String _getExceptionMessage(FirebaseException exception) {
    switch (exception.code) {
      case 'ERROR_ABORTED_BY_USER':
        return 'Sign In Was Aborted by User';
      default:
        return 'Sign In Failed';
    }
  }

  Future<Map<String, dynamic>?> _getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      return androidInfo.toMap();
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

      return iosInfo.toMap();
    }
  }
}
