import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/food_item.dart';
import 'package:workout_player/models/nutrition.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/view/widgets/widgets.dart';

import 'home_screen_model.dart';
import 'main_model.dart';

final nutritionsDetailScreenModelProvider = ChangeNotifierProvider(
  (ref) => NutritionsDetailScreenModel(),
);

class NutritionsDetailScreenModel with ChangeNotifier {
  Future<void> delete(
    BuildContext context, {
    required Database database,
    required Nutrition nutrition,
  }) async {
    try {
      final homeContext =
          HomeScreenModel.homeScreenNavigatorKey.currentContext!;

      await database.deleteNutrition(nutrition);

      Navigator.of(homeContext).pop();
      Navigator.of(context).pop();

      getSnackbarWidget(
        S.current.deleteNutritionSnackBarTitle,
        S.current.deleteNutritionSnackBarMessage,
      );
    } on FirebaseException catch (e) {
      _showSignInError(e, context);
    }
  }

  void _showSignInError(FirebaseException exception, BuildContext context) {
    logger.e(exception);

    showExceptionAlertDialog(
      context,
      title: S.current.operationFailed,
      exception: exception.message ?? S.current.operationFailed,
    );
  }

  /// VIEW MODEL
  static String title(Nutrition nutrition) {
    if (nutrition.description != null) {
      if (nutrition.description!.isNotEmpty) {
        return nutrition.description!;
      } else {
        return S.current.addDescription;
      }
    } else {
      return S.current.addDescription;
    }
  }

  static String foodItemProtein(FoodItem foodItem) {
    final protein = Formatter.numWithOrWithoutDecimal(foodItem.proteins);
    final unit = Formatter.unitOfMassGram(null, foodItem.unitOfMass);

    return '$protein $unit';
  }

  static String foodItemCalories(FoodItem foodItem) {
    final calorie = Formatter.numWithOrWithoutDecimal(foodItem.calories);

    return '$calorie Kcal';
  }

  static String merchantName(Nutrition nutrition) {
    final name = nutrition.merchantName;

    if (name != null) {
      return name;
    } else {
      return '';
    }
  }

  static String mealType(Nutrition nutrition) {
    final type = EnumToString.convertToString(nutrition.type, camelCase: true);

    return type;
  }

  static String totalCalories(Nutrition nutrition) {
    final calorie = Formatter.numWithOrWithoutDecimal(nutrition.calories);

    return '$calorie Kcal';
  }

  static String totalFat(Nutrition nutrition) {
    final fat = Formatter.numWithOrWithoutDecimal(nutrition.fat);
    final unit = Formatter.unitOfMassGram(null, nutrition.unitOfMass);

    return '$fat $unit';
  }

  static String totalCarbs(Nutrition nutrition) {
    final carbs = Formatter.numWithOrWithoutDecimal(nutrition.carbs);
    final unit = Formatter.unitOfMassGram(null, nutrition.unitOfMass);

    return '$carbs $unit';
  }

  static String totalProtein(Nutrition nutrition) {
    final protein = Formatter.numWithOrWithoutDecimal(nutrition.proteinAmount);
    final unit = Formatter.unitOfMassGram(null, nutrition.unitOfMass);

    return '$protein $unit';
  }

  static String notes(Nutrition nutrition) {
    if (nutrition.notes != null) {
      if (nutrition.notes!.isNotEmpty) {
        return nutrition.notes!;
      } else {
        return S.current.addNotes;
      }
    } else {
      return S.current.addNotes;
    }
  }
}
