import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/services/main_provider.dart';
import 'package:workout_player/services/mixpanel_manager.dart';
import 'package:workout_player/widgets/get_snackbar_widget.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';

class SignInScreenNotifier extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  AuthService? auth;
  FirestoreDatabase? database;

  SignInScreenNotifier({
    this.auth,
    this.database,
  }) {
    final container = ProviderContainer();
    auth = container.read(authServiceProvider2);
    database = container.read(databaseProvider2(auth!.currentUser?.uid));
  }

  final locale = Intl.getCurrentLocale();

  void toggleIsLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

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
        final uniqueId = UniqueKey().toString();
        final id = 'Player $uniqueId';
        final currentTime = Timestamp.now();

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
          dailyWorkoutHistories: [],
          dailyNutritionHistories: [],
          savedRoutines: [],
          savedWorkouts: [],
          dailyProteinGoal: 0,
          dailyWeightsGoal: 0,
          backgroundImageIndex: 0,
        );
        await database!.setUser(userData);

        // TODO: add snackbar HERE

      } else {
        // Update Data if exist
        final currentTime = Timestamp.now();

        final updatedUserData = {
          'lastLoginDate': currentTime,
        };

        await database!.updateUser(
          auth!.currentUser!.uid,
          updatedUserData,
        );

        getSnackbarWidget(
          S.current.signInSuccessful,
          S.current.signInSnackbarMessage(user.displayName),
        );
      }
      Navigator.of(context).pop();
    } on FirebaseException catch (e) {
      logger.e(e);
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
        final uniqueId = UniqueKey().toString();
        final id = 'Player $uniqueId';
        final currentTime = Timestamp.now();

        final userData = User(
          userId: firebaseUser.uid,
          displayName: firebaseUser.providerData[0].displayName ?? id,
          userName: firebaseUser.providerData[0].displayName ?? id,
          userEmail: firebaseUser.providerData[0].email,
          signUpDate: currentTime,
          signUpProvider: firebaseUser.providerData[0].providerId,
          totalWeights: 0,
          totalNumberOfWorkouts: 0,
          unitOfMass: (locale == 'ko') ? 0 : 1,
          lastLoginDate: currentTime,
          dailyWorkoutHistories: [],
          dailyNutritionHistories: [],
          savedRoutines: [],
          savedWorkouts: [],
          backgroundImageIndex: 0,
        );
        await database!.setUser(userData);

        // TODO: add snackbar HERE

      } else {
        // Update Data if exist
        final currentTime = Timestamp.now();

        final updatedUserData = {
          'lastLoginDate': currentTime,
        };

        await database!.updateUser(
          auth!.currentUser!.uid,
          updatedUserData,
        );

        getSnackbarWidget(
          S.current.signInSuccessful,
          S.current.signInSnackbarMessage(user.displayName),
        );
      }
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseException catch (e) {
      logger.e(e);
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

      // Check if the user document exists in Cloud Firestore
      final User? user = await database!.getUserDocument(firebaseUser.uid);

      // Create new data do NOT exist
      if (user == null) {
        final uniqueId = UniqueKey().toString();
        final id = 'Player $uniqueId';
        final currentTime = Timestamp.now();

        final userData = User(
          userId: firebaseUser.uid,
          displayName: firebaseUser.providerData[0].displayName ?? id,
          userName: firebaseUser.providerData[0].displayName ?? id,
          userEmail: firebaseUser.providerData[0].email ?? firebaseUser.email,
          signUpDate: currentTime,
          signUpProvider: firebaseUser.providerData[0].providerId,
          totalWeights: 0,
          totalNumberOfWorkouts: 0,
          unitOfMass: (locale == 'ko') ? 0 : 1,
          lastLoginDate: currentTime,
          dailyWorkoutHistories: [],
          dailyNutritionHistories: [],
          savedRoutines: [],
          savedWorkouts: [],
          backgroundImageIndex: 0,
        );
        await database!.setUser(userData);

        // TODO: add snackbar HERE

        // getSnackbarWidget(
        //   title,
        //   S.current.signInSnackbarMessage(userData.displayName),
        // );
      } else {
        // Update Data if exist
        final currentTime = Timestamp.now();

        final updatedUserData = {
          'lastLoginDate': currentTime,
        };

        await database!.updateUser(
          auth!.currentUser!.uid,
          updatedUserData,
        );

        getSnackbarWidget(
          S.current.signInSuccessful,
          S.current.signInSnackbarMessage(user.displayName),
        );
      }
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseException catch (e) {
      logger.e(e);
      _showSignInError(e, context);
    }
    setIsLoading(false);
  }

  /// SIGN IN WITH APPLE
  Future<void> signInWithApple(BuildContext context) async {
    debugPrint('sign in with apple pressed');
    MixpanelManager.track('sign up with Apple pressed');

    setIsLoading(true);

    try {
      await auth!.signInWithApple();

      final firebaseUser = auth!.currentUser!;

      // Check if the user document exists in Cloud Firestore
      final User? user = await database!.getUserDocument(firebaseUser.uid);

      // Create new data do NOT exist
      if (user == null) {
        final uniqueId = UniqueKey().toString();
        final id = 'Player $uniqueId';
        final currentTime = Timestamp.now();

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
          dailyWorkoutHistories: [],
          dailyNutritionHistories: [],
          savedRoutines: [],
          savedWorkouts: [],
          backgroundImageIndex: 0,
        );
        await database!.setUser(userData);

        // TODO: add snackbar HERE

      } else {
        // Update Data if exist
        final currentTime = Timestamp.now();

        final updatedUserData = {
          'lastLoginDate': currentTime,
        };

        await database!.updateUser(auth!.currentUser!.uid, updatedUserData);

        getSnackbarWidget(
          S.current.signInSuccessful,
          S.current.signInSnackbarMessage(user.displayName),
        );
      }

      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseException catch (e) {
      logger.e(e);
      _showSignInError(e, context);
    }
    setIsLoading(false);
  }

  /// SIGN IN WITH Kakao
  Future<void> signInWithKakao(BuildContext context) async {
    debugPrint('sign in with Kakao triggered');
    MixpanelManager.track('sign up with Kakao pressed');

    setIsLoading(true);

    try {
      await auth!.signInWithKakao();

      final firebaseUser = auth!.currentUser!;

      // print(firebaseUser.toString());

      // GET User data to Firebase
      final User? user = await database!.getUserDocument(firebaseUser.uid);

      // Create new data do NOT exist
      if (user == null) {
        final uniqueId = UniqueKey().toString();
        final currentTime = Timestamp.now();
        final userData = User(
          userId: firebaseUser.uid,
          userName: firebaseUser.displayName ?? 'Player $uniqueId',
          displayName: firebaseUser.displayName ?? 'Player $uniqueId',
          userEmail: firebaseUser.email,
          signUpDate: currentTime,
          signUpProvider: 'kakaocorp.com',
          totalWeights: 0,
          totalNumberOfWorkouts: 0,
          unitOfMass: 1,
          lastLoginDate: currentTime,
          dailyWorkoutHistories: [],
          dailyNutritionHistories: [],
          savedRoutines: [],
          savedWorkouts: [],
          backgroundImageIndex: 0,
        );

        await database!.setUser(userData);

        // TODO: add snackbar HERE

      } else {
        // Update Data if exist
        final currentTime = Timestamp.now();

        final updatedUserData = {
          'lastLoginDate': currentTime,
        };

        await database!.updateUser(auth!.currentUser!.uid, updatedUserData);

        getSnackbarWidget(
          S.current.signInSuccessful,
          S.current.signInSnackbarMessage(user.displayName),
        );
      }

      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseException catch (e) {
      logger.e(e);
      _showSignInError(e, context);
    }
    setIsLoading(false);
  }

  void _showSignInError(Exception exception, BuildContext context) {
    showExceptionAlertDialog(
      context,
      title: S.current.signInFailed,
      exception: exception.toString(),
    );
  }
}

final signInScreenProvider =
    ChangeNotifierProvider((ref) => SignInScreenNotifier());

final Map<String, List<String>> previewImages = {
  'iosko': _iOSKorean,
  'iosen': _iOSEnglish,
  'androidko': _androidKorean,
  'androiden': _androidEnglish,
};

final List<String> _iOSEnglish = [
  'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2FiOS_english%2Fios_en_1%403x.png?alt=media&token=af9cf15c-97fb-4690-acae-d78aa23fbb79',
  'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2FiOS_english%2Fios_en_2%403x.png?alt=media&token=ef831774-ea03-4132-ab65-0146f7a3123c',
  'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2FiOS_english%2Fios_en_3%403x.png?alt=media&token=bdeef957-91e3-4407-8203-0d6668f4cc1e',
  'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2FiOS_english%2Fios_en_4%403x.png?alt=media&token=31f90817-effc-4c7e-9d43-b8864a12ce63',
];

final List<String> _iOSKorean = [
  'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2FiOS_korean%2Fios_ko_1%403x.png?alt=media&token=73460737-5833-469d-88e1-36ec4247b32d',
  'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2FiOS_korean%2Fios_ko_2%403x.png?alt=media&token=eed6edfa-9b39-43ef-916f-13421e24872d',
  'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2FiOS_korean%2Fios_ko_3%403x.png?alt=media&token=e40ee477-cc78-42b8-a0cb-5808d5d59b67',
  'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2FiOS_korean%2Fios_ko_4%403x.png?alt=media&token=74e8cf69-2b08-41a8-be70-4ba1356f8428',
];

final List<String> _androidEnglish = [
  'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2Fandroid_english%2Fandroid_en_1%403x.png?alt=media&token=270ae586-3336-4d95-bf73-a3cbedfdbd8e',
  'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2Fandroid_english%2Fandroid_en_2%403x.png?alt=media&token=e2ebbbe2-6950-4153-8d08-db88de1b9f11',
  'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2Fandroid_english%2Fandroid_en_3%403x.png?alt=media&token=941f93a7-7157-4e5a-aa95-7f1bfc2e4fd9',
  'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2Fandroid_english%2Fandroid_en_4%404x.png?alt=media&token=3c15d880-b5b6-49b0-b430-a431b82a5b13',
];

final List<String> _androidKorean = [
  'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2Fandroid_korean%2Fandroid_ko_1%403x.png?alt=media&token=4d24b967-7397-462c-b29a-c332d43f0c7d',
  'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2Fandroid_korean%2Fandroid_ko_2%403x.png?alt=media&token=07fb8b0a-3796-415f-baca-6fb8f2a5c024',
  'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2Fandroid_korean%2Fandroid_ko_3%403x.png?alt=media&token=9291c32b-16ea-423b-a944-d4f18fed9658',
  'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/app_preview%2Fandroid_korean%2Fandroid_ko_4%403x.png?alt=media&token=cc92c485-b807-43da-9612-b71b8f18f930',
];
