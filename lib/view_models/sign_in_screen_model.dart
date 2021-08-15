import 'dart:io';
import 'dart:math';

import 'package:provider/provider.dart' as provider;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/models/enum/unit_of_mass.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'main_model.dart';
import 'package:workout_player/services/mixpanel_manager.dart';
import 'package:workout_player/view/widgets/custom_fade_transition.dart';
import 'package:workout_player/view/widgets/get_snackbar_widget.dart';
import 'package:workout_player/view/widgets/show_exception_alert_dialog.dart';

import '../view/screens/sign_in_screen.dart';

final signInScreenProvider = ChangeNotifierProvider(
  (ref) => SignInScreenModel(),
);

class SignInScreenModel extends ChangeNotifier {
  AuthService? auth;
  FirestoreDatabase? database;

  SignInScreenModel({
    this.auth,
    this.database,
  }) {
    final container = ProviderContainer();
    auth = container.read(authServiceProvider);
    database = container.read(databaseProvider(auth!.currentUser?.uid));
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  final locale = Intl.getCurrentLocale();
  final randomNumber = Random().nextInt(6);
  final now = Timestamp.now();

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // SIGN IN ANONYMOUSLY
  Future<void> signInAnonymously(BuildContext context) async {
    logger.d('sign in with Anonymously pressed');
    MixpanelManager.track('signed up Anonymously');

    setIsLoading(true);

    try {
      await auth!.signInAnonymously();

      final firebaseUser = auth!.currentUser!;
      final User? user = await database!.getUserDocument(firebaseUser.uid);

      // Create new data if it does NOT exist
      if (user == null) {
        // User userData = await _fetchBaseUserData();
        // userData = userData.copyWith(
        //   signUpProvider: 'Anonymous',
        // );

        final deviceInfo = await _getDeviceInfo();
        final uniqueId = UniqueKey().toString();

        String? displayName = firebaseUser.displayName ?? 'Herakles $uniqueId';
        String? email = firebaseUser.email;

        if (firebaseUser.providerData.isNotEmpty) {
          displayName =
              firebaseUser.providerData[0].displayName ?? 'Herakles $uniqueId';
          email = firebaseUser.providerData[0].email;
        }

        final unitOfMassEnum =
            (locale == 'ko') ? UnitOfMass.kilograms : UnitOfMass.pounds;

        final userData = User(
          userId: firebaseUser.uid,
          userName: displayName,
          displayName: displayName,
          userEmail: email,
          signUpDate: now,
          signUpProvider: '',
          savedWorkouts: [],
          savedRoutines: [],
          totalWeights: 0,
          totalNumberOfWorkouts: 0,
          lastLoginDate: now,
          backgroundImageIndex: randomNumber,
          unitOfMassEnum: unitOfMassEnum,
          deviceInfo: deviceInfo,
          lastAppOpenedTime: now,
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
        await _updateUserData(context, user);
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

      // Create new data if it does NOT exist
      if (user == null) {
        final deviceInfo = await _getDeviceInfo();
        final uniqueId = UniqueKey().toString();
        final displayName = firebaseUser.providerData[0].displayName ??
            firebaseUser.displayName ??
            'Herakles $uniqueId';
        final email = firebaseUser.providerData[0].email ?? firebaseUser.email;
        final unitOfMassEnum =
            (locale == 'ko') ? UnitOfMass.kilograms : UnitOfMass.pounds;

        final userData = User(
          userId: firebaseUser.uid,
          displayName: displayName,
          userName: displayName,
          userEmail: email,
          signUpDate: now,
          signUpProvider: firebaseUser.providerData[0].providerId,
          totalWeights: 0,
          totalNumberOfWorkouts: 0,
          unitOfMass: (locale == 'ko') ? 0 : 1,
          lastLoginDate: now,
          savedRoutines: [],
          savedWorkouts: [],
          backgroundImageIndex: randomNumber,
          deviceInfo: deviceInfo,
          unitOfMassEnum: unitOfMassEnum,
          creationTime: firebaseUser.metadata.creationTime,
          lastAppOpenedTime: now,
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
        await _updateUserData(context, user);
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

      // Create new data do NOT exist
      if (user == null) {
        final deviceInfo = await _getDeviceInfo();
        final uniqueId = UniqueKey().toString();
        final displayName = firebaseUser.providerData[0].displayName ??
            firebaseUser.displayName ??
            'Herakles $uniqueId';
        final email = firebaseUser.providerData[0].email ?? firebaseUser.email;
        final unitOfEnum =
            (locale == 'ko') ? UnitOfMass.kilograms : UnitOfMass.pounds;

        final userData = User(
          userId: firebaseUser.uid,
          displayName: displayName,
          userName: displayName,
          userEmail: email,
          signUpDate: now,
          signUpProvider: firebaseUser.providerData[0].providerId,
          totalWeights: 0,
          totalNumberOfWorkouts: 0,
          unitOfMass: (locale == 'ko') ? 0 : 1,
          lastLoginDate: now,
          savedRoutines: [],
          savedWorkouts: [],
          backgroundImageIndex: randomNumber,
          deviceInfo: deviceInfo,
          creationTime: firebaseUser.metadata.creationTime,
          profileUrl: firebaseUser.photoURL,
          unitOfMassEnum: unitOfEnum,
          lastAppOpenedTime: now,
        );
        await database!.setUser(userData);

        Navigator.of(context).popUntil((route) => route.isFirst);

        getSnackbarWidget(
          S.current.signInSuccessful,
          S.current.firstSignInSnackbarMessage(userData.displayName),
          duration: 4,
        );
      } else {
        await _updateUserData(context, user);
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

      // Create new data do NOT exist
      if (user == null) {
        final deviceInfo = await _getDeviceInfo();
        final uniqueId = UniqueKey().toString();
        final id = 'Herakles $uniqueId';
        final unitOfEnum =
            (locale == 'ko') ? UnitOfMass.kilograms : UnitOfMass.pounds;
        final username = firebaseUser.providerData[0].displayName ??
            firebaseUser.displayName ??
            id;

        final userData = User(
          userId: firebaseUser.uid,
          displayName: firebaseUser.providerData[0].displayName ??
              firebaseUser.displayName ??
              id,
          userName: username,
          userEmail: firebaseUser.providerData[0].email ?? firebaseUser.email,
          signUpDate: now,
          signUpProvider: firebaseUser.providerData[0].providerId,
          totalWeights: 0,
          totalNumberOfWorkouts: 0,
          unitOfMass: (locale == 'ko') ? 0 : 1,
          lastLoginDate: now,
          savedRoutines: [],
          savedWorkouts: [],
          backgroundImageIndex: randomNumber,
          creationTime: firebaseUser.metadata.creationTime,
          profileUrl: firebaseUser.photoURL,
          unitOfMassEnum: unitOfEnum,
          lastAppOpenedTime: now,
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
        await _updateUserData(context, user);
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

      // Create new data do NOT exist
      if (user == null) {
        final deviceInfo = await _getDeviceInfo();
        final uniqueId = UniqueKey().toString();

        final userData = User(
          userId: firebaseUser.uid,
          userName: firebaseUser.displayName ?? 'Herakles $uniqueId',
          displayName: firebaseUser.displayName ?? 'Herakles $uniqueId',
          userEmail: firebaseUser.email,
          signUpDate: now,
          signUpProvider: 'kakao',
          totalWeights: 0,
          totalNumberOfWorkouts: 0,
          unitOfMass: 1,
          lastLoginDate: now,
          savedRoutines: [],
          savedWorkouts: [],
          backgroundImageIndex: randomNumber,
          deviceInfo: deviceInfo,
          unitOfMassEnum:
              (locale == 'ko') ? UnitOfMass.kilograms : UnitOfMass.pounds,
        );

        await database!.setUser(userData);

        Navigator.of(context).popUntil((route) => route.isFirst);

        getSnackbarWidget(
          S.current.signInSuccessful,
          S.current.firstSignInSnackbarMessage(userData.displayName),
          duration: 4,
        );
      } else {
        await _updateUserData(context, user);
      }
    } on FirebaseException catch (e) {
      _showSignInError(e, context);
    }
    setIsLoading(false);
  }

  // /// Return Base user data
  // Future<User> _fetchBaseUserData() async {
  //   final firebaseUser = auth!.currentUser!;

  //   final deviceInfo = await _getDeviceInfo();
  //   final uniqueId = UniqueKey().toString();

  //   String? displayName = firebaseUser.displayName ?? 'Herakles $uniqueId';
  //   String? email = firebaseUser.email;

  //   if (firebaseUser.providerData.isNotEmpty) {
  //     displayName =
  //         firebaseUser.providerData[0].displayName ?? 'Herakles $uniqueId';
  //     email = firebaseUser.providerData[0].email;
  //   }

  //   final unitOfMassEnum =
  //       (locale == 'ko') ? UnitOfMass.kilograms : UnitOfMass.pounds;

  //   final user = User(
  //     userId: firebaseUser.uid,
  //     userName: displayName,
  //     displayName: displayName,
  //     userEmail: email,
  //     signUpDate: now,
  //     signUpProvider: '',
  //     savedWorkouts: [],
  //     savedRoutines: [],
  //     totalWeights: 0,
  //     totalNumberOfWorkouts: 0,
  //     lastLoginDate: now,
  //     backgroundImageIndex: randomNumber,
  //     unitOfMassEnum: unitOfMassEnum,
  //     deviceInfo: deviceInfo,
  //     lastAppOpenedTime: now,
  //     creationTime: firebaseUser.metadata.creationTime,
  //     profileUrl: firebaseUser.photoURL,
  //   );

  //   return user;
  // }

  Future<void> _updateUserData(BuildContext context, User user) async {
    final firebaseUser = auth!.currentUser!;
    final deviceInfo = await _getDeviceInfo();

    User updatedUserData = user.copyWith(
      lastLoginDate: now,
    );

    if (updatedUserData.deviceInfo == null) {
      updatedUserData = updatedUserData.copyWith(
        deviceInfo: deviceInfo,
      );
    }

    if (updatedUserData.unitOfMassEnum == null) {
      updatedUserData = updatedUserData.copyWith(
        unitOfMassEnum: (updatedUserData.unitOfMass == 0)
            ? UnitOfMass.kilograms
            : UnitOfMass.pounds,
      );
    }

    if (updatedUserData.creationTime == null) {
      updatedUserData = updatedUserData.copyWith(
        creationTime: firebaseUser.metadata.creationTime,
      );
    }

    if (updatedUserData.profileUrl == null) {
      updatedUserData = updatedUserData.copyWith(
        profileUrl: firebaseUser.photoURL,
      );
    }

    await database!.updateUser(
      auth!.currentUser!.uid,
      updatedUserData.toJson(),
    );

    Navigator.of(context).popUntil((route) => route.isFirst);

    getSnackbarWidget(
      S.current.signInSuccessful,
      S.current.signInSnackbarMessage(user.displayName),
      duration: 4,
    );
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
        return S.current.errorAbortedByUser;
      default:
        return S.current.signInFailed;
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

  /// STATIC
  // Navigation
  static void show(BuildContext context) {
    final auth = provider.Provider.of<AuthBase>(context, listen: false);
    final database = provider.Provider.of<Database>(context, listen: false);

    HapticFeedback.mediumImpact();

    custmFadeTransition(
      context,
      duration: 500,
      screen: SignInScreen(auth: auth, database: database),
    );
  }
}
