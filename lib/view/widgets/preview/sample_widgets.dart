import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/theme_colors.dart';

import 'weekly_bar_chart_sample_template.dart';

class SampleWidgets {
  final Widget weeklyWeightsBarChart = const WeeklyBarChartSampleTemplate(
    key: Key('weeklyWorkoutHistoryMedium'),
    cardPadding: 4,
    cardColor: ThemeColors.card,
    defaultColor: ThemeColors.primary500,
    aboveGoalColor: ThemeColors.primary700,
    horizontalInterval: 7800,
    leadingIcon: Icons.fitness_center_rounded,
    maxY: 10000,
    randomData: [7500, 2000, 3000, 5000, 10000, 5000, 9500],
    title: 'Lift Weights',
    unit: 'kg',
  );

  final Widget weeklyWeightsBarChartPreview =
      const WeeklyBarChartSampleTemplate(
    key: Key('weeklyWorkoutHistoryMedium'),
    cardPadding: 16,
    defaultColor: ThemeColors.primary500,
    aboveGoalColor: ThemeColors.primary700,
    horizontalInterval: 7800,
    leadingIcon: Icons.fitness_center_rounded,
    maxY: 10000,
    randomData: [7500, 2000, 3000, 5000, 10000, 5000, 9500],
    title: 'Lift Weights',
    unit: 'kg',
  );

  final Widget weeklyProteinsBarChart = const WeeklyBarChartSampleTemplate(
    key: Key('weeklyNutritionChart'),
    cardPadding: 4,
    cardColor: ThemeColors.card,
    defaultColor: Colors.greenAccent,
    aboveGoalColor: Colors.green,
    horizontalInterval: 130,
    leadingIcon: Icons.restaurant_menu_rounded,
    maxY: 150,
    randomData: [150, 140, 123, 150, 120, 160, 100],
    title: 'Eat Proteins',
    unit: 'g',
  );

  final Widget weeklyProteinsBarChartPreview =
      const WeeklyBarChartSampleTemplate(
    key: Key('weeklyNutritionChart'),
    cardPadding: 16,
    defaultColor: Colors.greenAccent,
    aboveGoalColor: Colors.green,
    horizontalInterval: 130,
    leadingIcon: Icons.restaurant_menu_rounded,
    maxY: 150,
    randomData: [150, 140, 123, 150, 120, 160, 100],
    title: 'Eat Proteins',
    unit: 'g',
  );

  final Widget weeklyCarbsBarChart = WeeklyBarChartSampleTemplate(
    key: const Key('weeklyCarbsBarChart'),
    cardPadding: 4,
    cardColor: ThemeColors.card,
    title: S.current.carbs,
    defaultColor: Colors.lightGreenAccent,
    aboveGoalColor: Colors.lightGreen,
    horizontalInterval: 150,
    leadingIcon: Icons.restaurant_menu_rounded,
    unit: 'g',
    maxY: 160,
    randomData: const [140, 163, 123, 153, 162, 100, 160],
  );

  final Widget weeklyCarbsBarChartPreview = WeeklyBarChartSampleTemplate(
    key: const Key('weeklyCarbsBarChart'),
    cardPadding: 16,
    title: S.current.carbs,
    defaultColor: Colors.lightGreenAccent,
    aboveGoalColor: Colors.lightGreen,
    horizontalInterval: 150,
    leadingIcon: Icons.restaurant_menu_rounded,
    unit: 'g',
    maxY: 160,
    randomData: const [140, 163, 123, 153, 162, 100, 160],
  );

  final Widget weeklyFatBarChart = WeeklyBarChartSampleTemplate(
    key: const Key('weeklyFatBarChart'),
    title: S.current.fat,
    cardColor: ThemeColors.card,
    cardPadding: 4,
    defaultColor: Colors.lightGreenAccent,
    aboveGoalColor: Colors.lightGreen,
    leadingIcon: Icons.restaurant_menu_rounded,
    horizontalInterval: 50,
    unit: 'g',
    maxY: 60,
    randomData: const [45, 32, 66, 43, 52, 12, 50],
  );

  final Widget weeklyFatBarChartPreview = WeeklyBarChartSampleTemplate(
    key: const Key('weeklyFatBarChart'),
    title: S.current.fat,
    cardPadding: 16,
    defaultColor: Colors.lightGreenAccent,
    aboveGoalColor: Colors.lightGreen,
    leadingIcon: Icons.restaurant_menu_rounded,
    horizontalInterval: 50,
    unit: 'g',
    maxY: 60,
    randomData: const [45, 32, 66, 43, 52, 12, 50],
  );

  final Widget weeklyCaloriesChart = WeeklyBarChartSampleTemplate(
    key: const Key('weeklyCalorieBarChart'),
    title: S.current.consumedCalorie,
    cardColor: ThemeColors.card,
    cardPadding: 4,
    defaultColor: Colors.lightGreenAccent,
    aboveGoalColor: Colors.lightGreen,
    leadingIcon: Icons.restaurant_menu_rounded,
    horizontalInterval: 2000,
    unit: 'Cal',
    maxY: 2100,
    randomData: const [1600, 1730, 2000, 2145, 1960, 2000, 2010],
  );

  final Widget weeklyCaloriesChartPreview = WeeklyBarChartSampleTemplate(
    key: const Key('weeklyCalorieBarChart'),
    title: S.current.consumedCalorie,
    cardPadding: 16,
    defaultColor: Colors.lightGreenAccent,
    aboveGoalColor: Colors.lightGreen,
    leadingIcon: Icons.restaurant_menu_rounded,
    horizontalInterval: 2000,
    unit: 'Cal',
    maxY: 2100,
    randomData: const [1600, 1730, 2000, 2145, 1960, 2000, 2010],
  );
}
