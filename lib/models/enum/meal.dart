enum Meal {
  BeforeWorkout,
  AfterWorkout,
  Breakfast,
  Lunch,
  Dinner,
  Snack,
  Supplement
}

extension MealExtension on Meal {
  String get label {
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

  List<String> get list {
    // ignore: omit_local_variable_types
    final List<String> _mealsList = [];
    for (var i = 0; i < Meal.values.length; i++) {
      final value = Meal.values[i].label;
      _mealsList.add(value);
    }
    return _mealsList;
  }
}
