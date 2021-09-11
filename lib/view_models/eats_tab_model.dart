import 'package:easy_localization/easy_localization.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/models/combined/eats_tab_class.dart';
import 'package:workout_player/models/nutrition.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/view_models/main_model.dart';

class EatsTabModel with ChangeNotifier {
  // VIEW MODELS
  /// todaysTotalCalories
  static String todaysTotalCalories(EatsTabClass data) {
    final now = DateTime.now();
    final today = DateTime.utc(now.year, now.month, now.day);

    logger.d('today is $today');

    data.thisWeeksNutritions.forEach((element) {
      logger.d(element.loggedDate);
    });

    final todaysData = data.thisWeeksNutritions.where(
      (element) => element.loggedDate == today,
    );
    logger.d(todaysData.toString());

    final calories = todaysData.map((e) => e.calories ?? 0);
    final total = (calories.isEmpty) ? 0 : calories.reduce((a, b) => a + b);
    final formatted = Formatter.numWithOrWithoutDecimal(total);

    return '$formatted Kcal';
  }

  static String todaysCarbs(EatsTabClass data) {
    final now = DateTime.now();
    final today = DateTime.utc(now.year, now.month, now.day);
    final todaysData = data.thisWeeksNutritions.where(
      (element) => element.loggedDate == today,
    );

    final carbs = todaysData.map((e) => e.carbs ?? 0);
    final total = (carbs.isEmpty) ? 0 : carbs.reduce((a, b) => a + b);
    final formatted = Formatter.numWithOrWithoutDecimal(total);
    final unit = Formatter.unitOfMassGram(
      data.user.unitOfMass,
      data.user.unitOfMassEnum,
    );

    return '$formatted $unit';
  }

  static String todaysProtein(EatsTabClass data) {
    final now = DateTime.now();
    final today = DateTime.utc(now.year, now.month, now.day);
    final todaysData = data.thisWeeksNutritions.where(
      (element) => element.loggedDate == today,
    );

    final proteins = todaysData.map((e) => e.proteinAmount);
    final total = (proteins.isEmpty) ? 0 : proteins.reduce((a, b) => a + b);
    final formatted = Formatter.numWithOrWithoutDecimal(total);
    final unit = Formatter.unitOfMassGram(
      data.user.unitOfMass,
      data.user.unitOfMassEnum,
    );

    return '$formatted $unit';
  }

  static String loggedDate(Nutrition nutrition) {
    final formatter = DateFormat('MM.dd');
    final date = formatter.format(nutrition.loggedDate);

    return date;
  }

  static String description(Nutrition nutrition) {
    final numToString = EnumToString.convertToString(
      nutrition.type,
      camelCase: true,
    );

    if (nutrition.description?.isEmpty ?? true) {
      return numToString;
    } else {
      return nutrition.description!;
    }
  }

  static String calorie(Nutrition nutrition) {
    final calorie = Formatter.numWithOrWithoutDecimal(nutrition.calories);

    return '$calorie Kcal';
  }
}
