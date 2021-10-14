import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/meal.dart';
import 'package:workout_player/models/nutrition.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/view/widgets/basic.dart';
import 'package:workout_player/view/widgets/dialogs.dart';

import 'main_model.dart';

final editNutritionModelProvider =
    ChangeNotifierProvider.autoDispose.family<EditNutritionModel, Nutrition>(
  (ref, nutrition) => EditNutritionModel(nutrition: nutrition),
);

class EditNutritionModel with ChangeNotifier {
  EditNutritionModel({required this.nutrition});

  Nutrition nutrition;

  TextEditingController? _caloriesEditingController;
  FocusNode? _caloriesFocusNode;
  int? _intValue;
  int? _decimalValue;

  TextEditingController? get caloriesEditingController =>
      _caloriesEditingController;
  FocusNode? get caloriesFocusNode => _caloriesFocusNode;
  int? get intValue => _intValue;
  int? get decimalValue => _decimalValue;

  void onDateTimeChanged(DateTime date) {
    nutrition = nutrition.copyWith(
      loggedTime: Timestamp.fromDate(date),
      loggedDate: DateTime.utc(date.year, date.month, date.day),
    );

    notifyListeners();
  }

  void onMealTypeSelected(bool selected, Meal selectedMeal) {
    if (selected) {
      nutrition = nutrition.copyWith(type: selectedMeal);

      notifyListeners();
    }
  }

  void initCaloriesController() {
    _caloriesEditingController = TextEditingController(
      text: nutrition.calories.toString(),
    );

    _caloriesFocusNode = FocusNode();
  }

  void caloriesOnChanged(String value) {
    final form = formKey.currentState!;
    final isValid = form.validate();

    if (isValid) {
      final calories = num.tryParse(value);

      nutrition = nutrition.copyWith(
        calories: calories,
      );
    }
  }

  void caloriesOnFieldSubmitted(String value) {
    final form = formKey.currentState!;
    final isValid = form.validate();

    if (isValid) {
      final calories = num.tryParse(value);

      nutrition = nutrition.copyWith(
        calories: calories,
      );
    }
  }

  void initFatEditor(num? value) {
    final numValue = value ?? 0;
    final intValue = numValue.truncate();
    final decimalValue =
        (num.parse((numValue - intValue).toStringAsFixed(1)) * 10).toInt();

    _intValue = intValue;
    _decimalValue = decimalValue;
  }

  void onFatIntChanged(int intValue) {
    _intValue = intValue;
    final fat = _intValue! + _decimalValue! * 0.1;

    nutrition = nutrition.copyWith(fat: fat);

    notifyListeners();
  }

  void onFatDecimalChanged(int decimalValue) {
    _decimalValue = decimalValue;
    final fat = _intValue! + _decimalValue! * 0.1;

    nutrition = nutrition.copyWith(fat: fat);

    notifyListeners();
  }

  void onCarbsIntChanged(int intValue) {
    _intValue = intValue;
    final carbs = _intValue! + _decimalValue! * 0.1;

    nutrition = nutrition.copyWith(carbs: carbs);

    notifyListeners();
  }

  void onCarbsDecimalChanged(int decimalValue) {
    _decimalValue = decimalValue;
    final carbs = _intValue! + _decimalValue! * 0.1;

    nutrition = nutrition.copyWith(carbs: carbs);

    notifyListeners();
  }

  void onProteinsIntChanged(int intValue) {
    _intValue = intValue;
    final protein = _intValue! + _decimalValue! * 0.1;

    nutrition = nutrition.copyWith(proteinAmount: protein);

    notifyListeners();
  }

  void onProteinsDecimalChanged(int decimalValue) {
    _decimalValue = decimalValue;
    final protein = _intValue! + _decimalValue! * 0.1;

    nutrition = nutrition.copyWith(proteinAmount: protein);

    notifyListeners();
  }

  Future<void> onPressSave(BuildContext context) async {
    try {
      final database = provider.Provider.of<Database>(context, listen: false);

      await database.updateNutrition(
        nutrition: nutrition,
        data: nutrition.toJson(),
      );

      Navigator.of(context).pop();

      getSnackbarWidget(
        S.current.updateNutritionTitle,
        S.current.updateNutritionMessage,
      );
    } on FirebaseException catch (e) {
      logger.e(e);
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }
  }

  static final formKey = GlobalKey<FormState>();
}
