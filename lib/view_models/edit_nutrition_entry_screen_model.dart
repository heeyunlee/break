import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/models/enum/meal.dart';
import 'package:workout_player/models/nutrition.dart';
import 'package:workout_player/models/status.dart';
import 'package:workout_player/services/database.dart';

class EditNutritionModel with ChangeNotifier {
  EditNutritionModel({
    required this.database,
    required this.nutrition,
  });

  final Database database;
  Nutrition nutrition;

  TextEditingController? _descriptionEditingController;
  FocusNode? _descriptionFocusNode;
  TextEditingController? _caloriesEditingController;
  FocusNode? _caloriesFocusNode;
  int? _intValue;
  int? _decimalValue;
  TextEditingController? _notesEditingController;
  FocusNode? _notesFocusNode;

  TextEditingController? get descriptionEditingController =>
      _descriptionEditingController;
  FocusNode? get descriptionFocusNode => _descriptionFocusNode;
  TextEditingController? get caloriesEditingController =>
      _caloriesEditingController;
  FocusNode? get caloriesFocusNode => _caloriesFocusNode;
  int? get intValue => _intValue;
  int? get decimalValue => _decimalValue;
  TextEditingController? get notesEditingController => _notesEditingController;
  FocusNode? get notesFocusNode => _notesFocusNode;

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

  void initNotesEditor() {
    _notesEditingController = TextEditingController(text: nutrition.notes);
    _notesFocusNode = FocusNode();
  }

  void notesOnChanged(String value) {
    final form = formKey.currentState!;
    final isValid = form.validate();

    if (isValid) {
      nutrition = nutrition.copyWith(notes: value);
    }
  }

  void notesOnFieldSubmitted(String value) {
    final form = formKey.currentState!;
    final isValid = form.validate();

    if (isValid) {
      nutrition = nutrition.copyWith(notes: value);
    }
  }

  void initDescriptionEditor() {
    final isCreditCard = nutrition.isCreditCardTransaction ?? false;

    _descriptionEditingController = TextEditingController(
      text: isCreditCard ? nutrition.merchantName : nutrition.description,
    );
    _descriptionFocusNode = FocusNode();
  }

  void descriptionOnChanged(String value) {
    final isCreditCard = nutrition.isCreditCardTransaction ?? false;

    final form = formKey.currentState!;
    final isValid = form.validate();

    if (isValid) {
      if (isCreditCard) {
        nutrition = nutrition.copyWith(merchantName: value);
      } else {
        nutrition = nutrition.copyWith(description: value);
      }
    }
  }

  void descriptionOnFieldSubmitted(String value) {
    final isCreditCard = nutrition.isCreditCardTransaction ?? false;

    final form = formKey.currentState!;
    final isValid = form.validate();

    if (isValid) {
      if (isCreditCard) {
        nutrition = nutrition.copyWith(merchantName: value);
      } else {
        nutrition = nutrition.copyWith(description: value);
      }
    }
  }

  Future<Status> onPressSave() async {
    try {
      await database.updateNutrition(
        nutrition: nutrition,
        data: nutrition.toJson(),
      );

      // Navigator.of(context).pop();

      // getSnackbarWidget(
      //   S.current.updateNutritionTitle,
      //   S.current.updateNutritionMessage,
      // );

      return Status(statusCode: 200);
    } on FirebaseException catch (e) {
      return Status(statusCode: 404, exception: e);
      // await showExceptionAlertDialog(
      //   context,
      //   title: S.current.operationFailed,
      //   exception: e.toString(),
      // );
    }
  }

  static final formKey = GlobalKey<FormState>();
}
