import 'package:workout_player/generated/l10n.dart';
import 'package:json_annotation/json_annotation.dart';

enum Meal {
  @JsonValue('Breakfast')
  Breakfast,

  @JsonValue('Lunch')
  Lunch,

  @JsonValue('Dinner')
  Dinner,

  @JsonValue('Snack')
  Snack,

  @JsonValue('Supplement')
  Supplement,

  @JsonValue('Before Workout')
  BeforeWorkout,

  @JsonValue('After Workout')
  AfterWorkout,
}

extension MealLabelExtension on Meal {
  String? get label {
    switch (this) {
      case Meal.BeforeWorkout:
        return 'Before Workout';
      case Meal.AfterWorkout:
        return 'After Workout';
      case Meal.Breakfast:
        return 'Breakfast';
      case Meal.Lunch:
        return 'Lunch';
      case Meal.Dinner:
        return 'Dinner';
      case Meal.Snack:
        return 'Snack';
      case Meal.Supplement:
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
      case Meal.BeforeWorkout:
        return S.current.beforeWorkout;
      case Meal.AfterWorkout:
        return S.current.afterWorkout;
      case Meal.Breakfast:
        return S.current.breakfast;
      case Meal.Lunch:
        return S.current.lunch;
      case Meal.Dinner:
        return S.current.dinner;
      case Meal.Snack:
        return S.current.snack;
      case Meal.Supplement:
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
