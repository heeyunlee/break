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

final editNutritionEntryScreenModelProvider = ChangeNotifierProvider.autoDispose
    .family<EditNutritionEntryScreenModel, Nutrition>(
  (ref, nutrition) => EditNutritionEntryScreenModel(nutrition: nutrition),
);

class EditNutritionEntryScreenModel with ChangeNotifier {
  EditNutritionEntryScreenModel({required this.nutrition});

  Nutrition nutrition;

  // late TextEditingController _titleEditingController;
  // late FocusNode _titleFocusNode;
  // late String _loggedDate;
  // late Meal _meal;

  // TextEditingController get titleEditingController => _titleEditingController;
  // FocusNode get titleFocusNode => _titleFocusNode;
  // String get loggedDate => _loggedDate;
  // Meal get meal => _meal;

  // void init(Nutrition nutrition) {
  //   _titleEditingController = TextEditingController(
  //     text: 'Add Description',
  //   );

  //   _titleFocusNode = FocusNode();

  //   _loggedDate = Formatter.yMdjm(nutrition.loggedTime);
  //   _meal = nutrition.type;
  // }

  void onDateTimeChanged(DateTime date) {
    nutrition = nutrition.copyWith(
      loggedTime: Timestamp.fromDate(date),
      loggedDate: DateTime.utc(date.year, date.month, date.day),
    );

    notifyListeners();
  }

  Future<void> onDateTimeSaved(BuildContext context) async {
    try {
      final database = provider.Provider.of<Database>(context, listen: false);

      await database.updateNutrition(
        nutrition: nutrition,
        data: nutrition.toJson(),
      );

      Navigator.of(context).pop();

      getSnackbarWidget(
        S.current.updateNutritionDateTimeTitle,
        S.current.updateNutritionDateTimeMessage,
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

  void onMealTypeSelected(bool selected, Meal selectedMeal) {
    if (selected) {
      // _meal = selectedMeal;

      notifyListeners();
    }
  }

  static final formKey = GlobalKey<FormState>();
}
