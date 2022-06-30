import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:workout_player/models/enum/meal.dart';
import 'package:workout_player/models/enum/unit_of_mass.dart';
import 'package:workout_player/models/nutrition.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/services/firebase_auth_service.dart';
import 'package:workout_player/features/widgets/widgets.dart';
import 'package:workout_player/view_models/home_screen_model.dart';

class AddNutritionScreenModel with ChangeNotifier {
  AddNutritionScreenModel({required this.auth, required this.database});

  final FirebaseAuthService auth;
  final Database database;

  Timestamp _loggedTime = Timestamp.now();
  int _intValue = 25;
  int _decimalValue = 0;
  double _proteinAmount = 25.0;
  int? _selectedIndex;
  Meal? _mealType;

  late TextEditingController _descriptionController;
  late TextEditingController _caloriesController;
  late TextEditingController _carbsController;
  late TextEditingController _fatController;
  late TextEditingController _notesController;

  late FocusNode _descriptionFocusNode;
  late FocusNode _caloriesFocusNode;
  late FocusNode _carbsFocusNode;
  late FocusNode _fatFocusNode;
  late FocusNode _notesFocusNode;

  Timestamp get loggedTime => _loggedTime;
  int get intValue => _intValue;
  int get decimalValue => _decimalValue;
  double get proteinAmount => _proteinAmount;
  int? get selectedIndex => _selectedIndex;
  Meal? get mealType => _mealType;

  TextEditingController get descriptionController => _descriptionController;
  TextEditingController get caloriesController => _caloriesController;
  TextEditingController get carbsController => _carbsController;
  TextEditingController get fatController => _fatController;
  TextEditingController get notesController => _notesController;

  FocusNode get descriptionFocusNode => _descriptionFocusNode;
  FocusNode get caloriesFocusNode => _caloriesFocusNode;
  FocusNode get carbsFocusNode => _carbsFocusNode;
  FocusNode get fatFocusNode => _fatFocusNode;
  FocusNode get notesFocusNode => _notesFocusNode;
  List<FocusNode> get focusNodes => [
        _descriptionFocusNode,
        _caloriesFocusNode,
        _carbsFocusNode,
        _fatFocusNode,
        _notesFocusNode,
      ];

  void init() {
    _descriptionController = TextEditingController();
    _caloriesController = TextEditingController();
    _carbsController = TextEditingController();
    _fatController = TextEditingController();
    _notesController = TextEditingController();

    _descriptionFocusNode = FocusNode();
    _caloriesFocusNode = FocusNode();
    _carbsFocusNode = FocusNode();
    _fatFocusNode = FocusNode();
    _notesFocusNode = FocusNode();
  }

  void disposeController() {
    _descriptionController.dispose();
    _caloriesController.dispose();
    _carbsController.dispose();
    _fatController.dispose();
    _notesController.dispose();

    _descriptionFocusNode.dispose();
    _caloriesFocusNode.dispose();
    _carbsFocusNode.dispose();
    _fatFocusNode.dispose();
    _notesFocusNode.dispose();
  }

  bool hasFocus() {
    return _descriptionFocusNode.hasFocus ||
        _caloriesFocusNode.hasFocus ||
        _carbsFocusNode.hasFocus ||
        _fatFocusNode.hasFocus ||
        _notesFocusNode.hasFocus;
  }

  bool validate() {
    return _mealType != null;
  }

  void onDateTimeChanged(DateTime date) {
    _loggedTime = Timestamp.fromDate(date);

    notifyListeners();
  }

  void onIntValueChanged(int value) {
    HapticFeedback.mediumImpact();
    _intValue = value;
    _proteinAmount = _intValue + _decimalValue * 0.1;

    notifyListeners();
  }

  void onDecimalValueChanged(int value) {
    HapticFeedback.mediumImpact();
    _decimalValue = value;
    _proteinAmount = _intValue + _decimalValue * 0.1;

    notifyListeners();
  }

  void onChipSelected(bool selected, Meal meal) {
    if (selected) {
      _mealType = meal;

      notifyListeners();
    }
  }

  bool _validateAndSaveForm() {
    final form = formKey.currentState;

    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Submit data to Firestore
  Future<void> submit(BuildContext context) async {
    if (_mealType != null) {
      if (_validateAndSaveForm()) {
        try {
          final user = await database.getUserDocument(auth.currentUser!.uid);
          if (user != null) {
            final id = 'NUT${const Uuid().v1()}';
            final timeInDate = _loggedTime.toDate();
            final loggedDate = DateTime.utc(
              timeInDate.year,
              timeInDate.month,
              timeInDate.day,
            );

            final nutrition = Nutrition(
              nutritionId: id,
              userId: user.userId,
              username: user.userName,
              loggedTime: _loggedTime,
              loggedDate: loggedDate,
              proteinAmount: _proteinAmount,
              type: _mealType!,
              notes: _notesController.text,
              calories: num.tryParse(_caloriesController.text),
              carbs: num.tryParse(_carbsController.text),
              fat: num.tryParse(_fatController.text),
              description: _descriptionController.text,
              isCreditCardTransaction: false,
              unitOfMass: user.unitOfMassEnum ?? UnitOfMass.kilograms,
            );

            await database.setNutrition(nutrition);

            Navigator.of(HomeScreenModel.homeScreenNavigatorKey.currentContext!)
                .pop();

            // getSnackbarWidget(
            //   S.current.addProteinEntrySnackbarTitle,
            //   S.current.addProteinEntrySnackbar,
            // );
          }
        } on FirebaseException catch (e) {
          await showExceptionAlertDialog(
            context,
            title: S.current.operationFailed,
            exception: e.toString(),
          );
        }
      }
    } else {
      await showAlertDialog(
        context,
        title: S.current.selectMealTypeAlertTitle,
        content: S.current.selectMeapTypeAlertContent,
        defaultActionText: S.current.ok,
      );
    }
  }

  /// STATIC
  // FORM KEY
  static final formKey = GlobalKey<FormState>();
}
