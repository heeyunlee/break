import 'package:workout_player/generated/l10n.dart';
import 'package:json_annotation/json_annotation.dart';

enum Meal {
  @JsonValue('Breakfast')
  breakfast,

  @JsonValue('Lunch')
  lunch,

  @JsonValue('Dinner')
  dinner,

  @JsonValue('Snack')
  snack,

  @JsonValue('Supplement')
  supplement,

  @JsonValue('Before Workout')
  beforeWorkout,

  @JsonValue('After Workout')
  afterWorkout,
}

extension MealLabelExtension on Meal {
  String? get label {
    switch (this) {
      case Meal.beforeWorkout:
        return 'Before Workout';
      case Meal.afterWorkout:
        return 'After Workout';
      case Meal.breakfast:
        return 'Breakfast';
      case Meal.lunch:
        return 'Lunch';
      case Meal.dinner:
        return 'Dinner';
      case Meal.snack:
        return 'Snack';
      case Meal.supplement:
        return 'Supplement';
      default:
        return null;
    }
  }
}

extension MealListExtension on Meal {
  List<String> get list {
    final List<String> _mealsList = [];
    for (var i = 0; i < Meal.values.length; i++) {
      final value = Meal.values[i].label;
      _mealsList.add(value!);
    }
    return _mealsList;
  }
}

extension MealTranslationExtension on Meal {
  String? get translation {
    switch (this) {
      case Meal.beforeWorkout:
        return S.current.beforeWorkout;
      case Meal.afterWorkout:
        return S.current.afterWorkout;
      case Meal.breakfast:
        return S.current.breakfast;
      case Meal.lunch:
        return S.current.lunch;
      case Meal.dinner:
        return S.current.dinner;
      case Meal.snack:
        return S.current.snack;
      case Meal.supplement:
        return S.current.others;
      default:
        return null;
    }
  }
}

extension MealTranslatedList on Meal {
  List<String> get translatedList {
    final List<String> _mealsList = [];
    for (var i = 0; i < Meal.values.length; i++) {
      final value = Meal.values[i].translation;
      _mealsList.add(value!);
    }
    return _mealsList;
  }
}
