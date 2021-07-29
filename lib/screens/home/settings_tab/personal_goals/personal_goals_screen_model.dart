import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/widgets/get_snackbar_widget.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';

final personalGoalsScreenModelProvider = ChangeNotifierProvider(
  (ref) => PersonalGoalsScreenModel(),
);

class PersonalGoalsScreenModel with ChangeNotifier {
  AuthService? auth;
  FirestoreDatabase? database;

  PersonalGoalsScreenModel({
    this.auth,
    this.database,
  }) {
    final container = ProviderContainer();
    auth = container.read(authServiceProvider);
    database = container.read(databaseProvider(auth!.currentUser?.uid));
  }

  num _proteinGoal = 150.0;
  num _liftingGoal = 20000.0;
  num _weightGoal = 70.0;
  num _bodyFatPercentageGoal = 15.0;
  bool _isButtonPressed = false;

  num get proteinGoal => _proteinGoal;
  num get liftingGoal => _liftingGoal;
  num get weightGoal => _weightGoal;
  num get bodyFatPercentageGoal => _bodyFatPercentageGoal;
  bool get isButtonPressed => _isButtonPressed;

  /// Protein Goal
  Future<void> initProteinGoal() async {
    final user = (await database!.getUserDocument(auth!.currentUser!.uid))!;
    _proteinGoal = user.dailyProteinGoal ?? 150;

    notifyListeners();
  }

  void incrementProteinGoal() {
    _proteinGoal++;
    HapticFeedback.mediumImpact();
    notifyListeners();
  }

  void decrementProteinGoal() {
    _proteinGoal--;
    HapticFeedback.mediumImpact();
    notifyListeners();
  }

  Future<void> onLongPressStartDecrementProtein(_) async {
    _isButtonPressed = true;

    while (_isButtonPressed) {
      decrementProteinGoal();

      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  Future<void> onLongPressEndDecrementProtein(_) async {
    _isButtonPressed = false;

    notifyListeners();
  }

  Future<void> onLongPressStartIncrementProtein(_) async {
    _isButtonPressed = true;

    while (_isButtonPressed) {
      incrementProteinGoal();

      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  Future<void> onLongPressEndIncrementProtein(_) async {
    _isButtonPressed = false;

    notifyListeners();
  }

  Future<void> setProteinGoal(BuildContext context) async {
    try {
      final userData = {
        'dailyProteinGoal': _proteinGoal,
      };

      await database!.updateUser(auth!.currentUser!.uid, userData);

      Navigator.of(context).popUntil((route) => route.isFirst);

      getSnackbarWidget(
        S.current.setProteinGoalSnackbarTitle,
        S.current.setProteinGoalSnackbarBody,
      );
    } on FirebaseException catch (e) {
      _showSignInError(e, context);
    }
  }

  /// Lifting Goal
  Future<void> initLiftingGoal() async {
    final user = (await database!.getUserDocument(auth!.currentUser!.uid))!;
    _liftingGoal = (user.dailyWeightsGoal != null)
        ? user.dailyWeightsGoal!
        : (user.unitOfMass == 0)
            ? 10000
            : 20000;

    notifyListeners();
  }

  void incrementLiftingGoal() {
    _liftingGoal += 100;
    HapticFeedback.mediumImpact();
    notifyListeners();
  }

  void decrementLiftingGoal() {
    _liftingGoal -= 100;
    HapticFeedback.mediumImpact();
    notifyListeners();
  }

  Future<void> onLongPressStartDecrementLifting(_) async {
    _isButtonPressed = true;

    while (_isButtonPressed) {
      decrementLiftingGoal();

      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  Future<void> onLongPressEndDecrementLifting(_) async {
    _isButtonPressed = false;

    notifyListeners();
  }

  Future<void> onLongPressStartIncrementLifting(_) async {
    _isButtonPressed = true;

    while (_isButtonPressed) {
      incrementLiftingGoal();

      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  Future<void> onLongPressEndIncrementLifting(_) async {
    _isButtonPressed = false;

    notifyListeners();
  }

  Future<void> setLiftingGoal(BuildContext context) async {
    try {
      final userData = {
        'dailyWeightsGoal': _liftingGoal,
      };

      await database!.updateUser(auth!.currentUser!.uid, userData);

      Navigator.of(context).popUntil((route) => route.isFirst);

      getSnackbarWidget(
        S.current.setLiftingGoalSnackbarTitle,
        S.current.setLiftingGoalSnackbarBody,
      );
    } on FirebaseException catch (e) {
      _showSignInError(e, context);
    }
  }

  /// WEIGHT
  Future<void> initWeightGoal(BuildContext context) async {
    final user = (await database!.getUserDocument(auth!.currentUser!.uid))!;

    _weightGoal = (user.weightGoal != null)
        ? user.weightGoal!
        : (user.unitOfMass == 0)
            ? 70
            : 150;

    notifyListeners();
  }

  void incrementWeightGoal() {
    _weightGoal += 0.1;
    HapticFeedback.mediumImpact();
    notifyListeners();
  }

  void decrementWeightGoal() {
    _weightGoal -= 0.1;
    HapticFeedback.mediumImpact();
    notifyListeners();
  }

  Future<void> onLongPressStartDecrementWeight(_) async {
    _isButtonPressed = true;

    while (_isButtonPressed) {
      decrementWeightGoal();
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  Future<void> onLongPressEndDecrementWeight(_) async {
    _isButtonPressed = false;

    notifyListeners();
  }

  Future<void> onLongPressStartIncrementWeight(_) async {
    _isButtonPressed = true;

    while (_isButtonPressed) {
      incrementWeightGoal();
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  Future<void> onLongPressEndIncrementWeight(_) async {
    _isButtonPressed = false;

    notifyListeners();
  }

  Future<void> setWeightGoal(BuildContext context) async {
    try {
      final userData = {
        'weightGoal': _weightGoal,
      };

      await database!.updateUser(auth!.currentUser!.uid, userData);

      Navigator.of(context).popUntil((route) => route.isFirst);

      getSnackbarWidget(
        S.current.setWeightGoalSnackbarTitle,
        S.current.setWeightGoalSnackbarMessage,
      );
    } on FirebaseException catch (e) {
      _showSignInError(e, context);
    }
  }

  // BODY FAT PERCENTAGE GOAL
  Future<void> initBodyFatPercentageGoal(BuildContext context) async {
    final user = (await database!.getUserDocument(auth!.currentUser!.uid))!;

    _weightGoal = user.bodyFatPercentageGoal ?? 15.0;

    notifyListeners();
  }

  void incrementBodyFatGoall() {
    _bodyFatPercentageGoal += 0.1;
    HapticFeedback.mediumImpact();
    notifyListeners();
  }

  void decrementBodyFatGoal() {
    _bodyFatPercentageGoal -= 0.1;
    HapticFeedback.mediumImpact();
    notifyListeners();
  }

  Future<void> onLongPressStartDecrementBodyFat(_) async {
    _isButtonPressed = true;

    while (_isButtonPressed) {
      decrementBodyFatGoal();
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  Future<void> onLongPressEndDecrementBodyFat(_) async {
    _isButtonPressed = false;

    notifyListeners();
  }

  Future<void> onLongPressStartIncrementBodyFat(_) async {
    _isButtonPressed = true;

    while (_isButtonPressed) {
      incrementBodyFatGoall();
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  Future<void> onLongPressEndIncrementBodyFat(_) async {
    _isButtonPressed = false;

    notifyListeners();
  }

  Future<void> setBodyFatPercentageGoal(BuildContext context) async {
    try {
      final userData = {
        'bodyFatPercentageGoal': _bodyFatPercentageGoal,
      };

      await database!.updateUser(auth!.currentUser!.uid, userData);

      Navigator.of(context).popUntil((route) => route.isFirst);

      getSnackbarWidget(
        S.current.setBodyFatPercentageGoalSnackbarTitle,
        S.current.setBodyFatPercentageGoalSnackbarMessage,
      );
    } on FirebaseException catch (e) {
      _showSignInError(e, context);
    }
  }

  // IS BUTTON PRESSED
  void setIsButtonPressed(bool value) {
    _isButtonPressed = value;
    notifyListeners();
  }

  void _showSignInError(FirebaseException exception, BuildContext context) {
    logger.e(exception);

    showExceptionAlertDialog(
      context,
      title: S.current.operationFailed,
      exception: exception.message ?? S.current.errorOccuredMessage,
    );
  }
}
