import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/view/widgets/widgets.dart';

import 'main_model.dart';

class PersonalGoalsScreenModel with ChangeNotifier {
  PersonalGoalsScreenModel({
    required this.user,
    required this.database,
  });

  final User user;
  final Database database;

  num _proteinGoal = 150.0;
  num _liftingGoal = 20000.0;
  num _weightGoal = 70.0;
  num _bodyFatPercentageGoal = 15.0;
  bool _isButtonPressed = false;
  String _gramUnit = 'g';
  String _kilogramUnit = 'kg';
  num _carbsGoal = 200.0;
  num _fatGoal = 50;
  num _calorieConsumptionGoal = 2000;
  int _intValue = 1000;
  int _doubleValue = 0;
  double _currentlyEditingValue = 1000;

  num get proteinGoal => _proteinGoal;
  num get liftingGoal => _liftingGoal;
  num get weightGoal => _weightGoal;
  num get bodyFatPercentageGoal => _bodyFatPercentageGoal;
  bool get isButtonPressed => _isButtonPressed;
  String get kilogramUnit => _kilogramUnit;
  String get gramUnit => _gramUnit;
  num get carbsGoal => _carbsGoal;
  num get fatGoal => _fatGoal;
  num get calorieConsumptionGoal => _calorieConsumptionGoal;
  int get intValue => _intValue;
  int get doubleValue => _doubleValue;

  void setInitialValue(num value) {
    final parsed = value.toDouble().toStringAsFixed(1).split('.');

    _intValue = int.parse(parsed[0]);
    _doubleValue = int.parse(parsed[1]);
    _currentlyEditingValue = _intValue + _doubleValue / 10;
  }

  void onIntChanged(int value) {
    HapticFeedback.mediumImpact();

    _intValue = value;
    _currentlyEditingValue = _intValue + _doubleValue / 10;

    notifyListeners();
  }

  void onDoubleChanged(int value) {
    HapticFeedback.mediumImpact();

    _doubleValue = value;
    _currentlyEditingValue = _intValue + _doubleValue / 10;

    notifyListeners();
  }

  void init() {
    logger.d('PersonalGoalsScreenModel INIT function called');

    _liftingGoal =
        user.dailyWeightsGoal ?? ((user.unitOfMass == 0) ? 10000 : 15000);

    _weightGoal = user.weightGoal ?? ((user.unitOfMass == 0) ? 70 : 150);
    _bodyFatPercentageGoal = user.bodyFatPercentageGoal ?? 15.0;

    _proteinGoal =
        user.dailyProteinGoal ?? ((user.unitOfMass == 0) ? 120 : 200);
    _carbsGoal = user.dailyCarbsGoal ?? ((user.unitOfMass == 0) ? 100 : 200);
    _fatGoal = user.dailyFatGoal ?? ((user.unitOfMass == 0) ? 50 : 100);
    _calorieConsumptionGoal = user.dailyCalorieConsumptionGoal ?? 2000;

    _kilogramUnit = Formatter.unitOfMass(
      user.unitOfMass,
      user.unitOfMassEnum,
    );

    _gramUnit = Formatter.unitOfMassGram(
      user.unitOfMass,
      user.unitOfMassEnum,
    );
  }

  /// Lifting
  String getLiftingGoalPreview() {
    final formatted = Formatter.numWithOrWithoutDecimal(_liftingGoal);

    return '$formatted $_kilogramUnit';
  }

  Future<void> setLiftingGoal(BuildContext context) async {
    try {
      final userData = {
        'dailyWeightsGoal': _currentlyEditingValue,
      };

      await database.updateUser(database.uid!, userData);

      Navigator.of(context).popUntil((route) => route.isFirst);

      getSnackbarWidget(
        S.current.setLiftingGoalSnackbarTitle,
        S.current.setLiftingGoalSnackbarBody,
      );
    } on FirebaseException catch (e) {
      _showErrorDialog(e, context);
    }
  }

  /// Body Weight
  String getBodyWeightGoalPreview() {
    final formatted = Formatter.numWithDecimal(_weightGoal);

    return '$formatted $_kilogramUnit';
  }

  Future<void> setWeightGoal(BuildContext context) async {
    try {
      final userData = {
        'weightGoal': _currentlyEditingValue,
      };

      await database.updateUser(database.uid!, userData);

      Navigator.of(context).popUntil((route) => route.isFirst);

      getSnackbarWidget(
        S.current.setWeightGoalSnackbarTitle,
        S.current.setWeightGoalSnackbarMessage,
      );
    } on FirebaseException catch (e) {
      _showErrorDialog(e, context);
    }
  }

  /// BodyFat
  String getBodyFatGoalsPreview() {
    final formatted = Formatter.numWithOrWithoutDecimal(_bodyFatPercentageGoal);

    return '$formatted %';
  }

  // void incrementBodyFatGoal() {
  //   _bodyFatPercentageGoal += 0.1;
  //   HapticFeedback.mediumImpact();
  //   notifyListeners();
  // }

  // void decrementBodyFatGoal() {
  //   _bodyFatPercentageGoal -= 0.1;
  //   HapticFeedback.mediumImpact();
  //   notifyListeners();
  // }

  // Future<void> onLongPressStartDecrementBodyFat(_) async {
  //   _isButtonPressed = true;

  //   while (_isButtonPressed) {
  //     decrementBodyFatGoal();
  //     await Future.delayed(Duration(milliseconds: 100));
  //   }
  // }

  // Future<void> onLongPressEndDecrementBodyFat(_) async {
  //   _isButtonPressed = false;

  //   notifyListeners();
  // }

  // Future<void> onLongPressStartIncrementBodyFat(_) async {
  //   _isButtonPressed = true;

  //   while (_isButtonPressed) {
  //     incrementBodyFatGoal();
  //     await Future.delayed(Duration(milliseconds: 100));
  //   }
  // }

  // Future<void> onLongPressEndIncrementBodyFat(_) async {
  //   _isButtonPressed = false;

  //   notifyListeners();
  // }

  Future<void> setBodyFatPercentageGoal(BuildContext context) async {
    try {
      final userData = {
        'bodyFatPercentageGoal': _currentlyEditingValue,
      };

      await database.updateUser(database.uid!, userData);

      Navigator.of(context).popUntil((route) => route.isFirst);

      getSnackbarWidget(
        S.current.setBodyFatPercentageGoalSnackbarTitle,
        S.current.setBodyFatPercentageGoalSnackbarMessage,
      );
    } on FirebaseException catch (e) {
      _showErrorDialog(e, context);
    }
  }

  /// PROTEINS
  String getProteinGoalPreview() {
    final formatted = Formatter.numWithOrWithoutDecimal(_proteinGoal);

    return '$formatted $_gramUnit';
  }

  Future<void> setProteinGoal(BuildContext context) async {
    try {
      final userData = {
        'dailyProteinGoal': _currentlyEditingValue,
      };

      await database.updateUser(database.uid!, userData);

      Navigator.of(context).popUntil((route) => route.isFirst);

      getSnackbarWidget(
        S.current.setProteinGoalSnackbarTitle,
        S.current.setProteinGoalSnackbarBody,
      );
    } on FirebaseException catch (e) {
      _showErrorDialog(e, context);
    }
  }

  /// Carbs
  String getCarbsGoalPreview() {
    final formatted = Formatter.numWithOrWithoutDecimal(_carbsGoal);

    return '$formatted $_gramUnit';
  }

  Future<void> setCarbsGoal(BuildContext context) async {
    try {
      final userData = {
        'dailyCarbsGoal': _currentlyEditingValue,
      };

      await database.updateUser(database.uid!, userData);

      Navigator.of(context).popUntil((route) => route.isFirst);

      getSnackbarWidget(
        S.current.setCarbsGoalSnackbarTitle,
        S.current.setCarbsGoalSnackbarBody,
      );
    } on FirebaseException catch (e) {
      _showErrorDialog(e, context);
    }
  }

  /// Fat
  String getFatsGoalPreview() {
    final formatted = Formatter.numWithOrWithoutDecimal(_fatGoal);

    return '$formatted $_gramUnit';
  }

  Future<void> setFatGoal(BuildContext context) async {
    try {
      final userData = {
        'dailyFatGoal': _currentlyEditingValue,
      };

      await database.updateUser(database.uid!, userData);

      Navigator.of(context).popUntil((route) => route.isFirst);

      getSnackbarWidget(
        S.current.setFatGoalSnackbarTitle,
        S.current.setFatGoalSnackbarBody,
      );
    } on FirebaseException catch (e) {
      _showErrorDialog(e, context);
    }
  }

  /// Calories
  String getCalorieGoalPreview() {
    final formatted = Formatter.numWithOrWithoutDecimal(
      _calorieConsumptionGoal,
    );

    return '$formatted Cal';
  }

  Future<void> setCalorieGoal(BuildContext context) async {
    try {
      final userData = {
        'dailyCalorieConsumptionGoal': _currentlyEditingValue,
      };

      await database.updateUser(database.uid!, userData);

      Navigator.of(context).popUntil((route) => route.isFirst);

      getSnackbarWidget(
        S.current.setCalorieGoalSnackbarTitle,
        S.current.setCalorieGoalSnackbarBody,
      );
    } on FirebaseException catch (e) {
      _showErrorDialog(e, context);
    }
  }

  /// IS BUTTON PRESSED
  void setIsButtonPressed({required bool pressed}) {
    _isButtonPressed = pressed;
    notifyListeners();
  }

  void _showErrorDialog(FirebaseException exception, BuildContext context) {
    logger.e(exception);

    showExceptionAlertDialog(
      context,
      title: S.current.operationFailed,
      exception: exception.message ?? S.current.errorOccuredMessage,
    );
  }

  // void incrementCalorieGoal() {
  //   _calorieConsumptionGoal += 100;
  //   HapticFeedback.mediumImpact();
  //   notifyListeners();
  // }

  // void decrementCalorieGoal() {
  //   _calorieConsumptionGoal -= 100;
  //   HapticFeedback.mediumImpact();
  //   notifyListeners();
  // }

  // Future<void> onLongPressStartDecrementCalorie(_) async {
  //   _isButtonPressed = true;

  //   while (_isButtonPressed) {
  //     decrementCalorieGoal();

  //     await Future.delayed(Duration(milliseconds: 100));
  //   }
  // }

  // Future<void> onLongPressEndDecrementCalorie(_) async {
  //   _isButtonPressed = false;

  //   notifyListeners();
  // }

  // Future<void> onLongPressStartIncrementCalorie(_) async {
  //   _isButtonPressed = true;

  //   while (_isButtonPressed) {
  //     incrementCalorieGoal();

  //     await Future.delayed(Duration(milliseconds: 100));
  //   }
  // }

  // Future<void> onLongPressEndIncrementCalorie(_) async {
  //   _isButtonPressed = false;

  //   notifyListeners();
  // }
}
