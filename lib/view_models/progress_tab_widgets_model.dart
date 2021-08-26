import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/combined/progress_tab_class.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/view/screens/calories_entries_screen.dart';
import 'package:workout_player/view/screens/carbs_entries_screen.dart';
import 'package:workout_player/view/screens/fat_entries_screen.dart';
import 'package:workout_player/view/screens/protein_entries_screen.dart';
import 'package:workout_player/view/screens/routine_histories_screen.dart';
import 'package:workout_player/view/widgets/progress/daily_activty_ring_widget.dart';
import 'package:workout_player/view/widgets/progress/latest_body_fat_widget.dart';
import 'package:workout_player/view/widgets/progress/latest_weight_widget.dart';
import 'package:workout_player/view/widgets/progress/most_recent_workout_widget.dart';
import 'package:workout_player/view/widgets/progress/weekly_bar_chart_card_template.dart';
import 'package:workout_player/view/widgets/progress/weekly_measurements_card.dart';
import 'package:workout_player/view/widgets/progress/weekly_workout_summary.dart';
import 'package:workout_player/view_models/home_screen_model.dart';

import 'weekly_calories_bar_chart_model.dart';
import 'weekly_carbs_bar_chart_model.dart';
import 'weekly_fat_bar_chart_model.dart';
import 'weekly_proteins_bar_chart_model.dart';
import 'weekly_weights_bar_chart_model.dart';

final progressTabWidgetsModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) => ProgressTabWidgetsModel(),
);

class ProgressTabWidgetsModel with ChangeNotifier {
  AuthBase? auth;
  Database? database;

  ProgressTabWidgetsModel({
    this.auth,
    this.database,
  }) {
    final container = ProviderContainer();
    auth = container.read(authServiceProvider);
    database = container.read(databaseProvider(auth!.currentUser?.uid));
  }

  Map<String, Widget> _keysAndWidgets = {};
  List<Widget> _widgets = [];
  List _widgetKeysList = [
    // 'empty2x2',
    'activityRing',
    'weeklyWorkoutHistorySmall',
    'latestBodyFat',
    'latestWeight',
    'recentWorkout',
    'weeklyMeasurementsChart',
    'weeklyNutritionChart',
    'weeklyWorkoutHistoryMedium',
    // 'stepsWidget',
    'weeklyCarbsBarChart',
    'weeklyFatBarChart',
    'weeklyCalorieBarChart',
  ];
  AnimationController? _staggeredController;
  // bool _isFirstStartUp = true;

  Map<String, Widget> get keysAndWidgets => _keysAndWidgets;
  List<Widget> get widgets => _widgets;
  List get widgetKeysList => _widgetKeysList;
  AnimationController? get staggeredController => _staggeredController;
  // bool get isFirstStartUp => _isFirstStartUp;

  void init(TickerProvider vsync) {
    _staggeredController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 3500),
    );

    final container = ProviderContainer();
    final m = container.read(homeScreenModelProvider);

    if (m.isFirstStartup) {
      _staggeredController?.forward();
      m.toggleIsFirstStartup();

      // _isFirstStartUp = false;
    } else {}
  }

  Widget buildDraggableFeedback(
    BuildContext context,
    BoxConstraints constraints,
    Widget child,
  ) {
    return ConstrainedBox(
      constraints: constraints,
      child: FittedBox(
        child: DottedBorder(
          borderType: BorderType.RRect,
          color: Colors.grey.withOpacity(0.5),
          radius: const Radius.circular(24),
          strokeCap: StrokeCap.round,
          dashPattern: const [16, 4],
          child: child,
        ),
      ),
    );
  }

  void onReorder(int oldIndex, int newIndex) {
    // if (newIndex > oldIndex) {
    //   newIndex -= 1;
    // }

    // final List<String> _newKeys = [];

    final itemToReorder = _widgets.removeAt(oldIndex);
    _widgets.insert(newIndex, itemToReorder);

    final _newKeys = _widgets
        .map((widget) =>
            widget.key.toString().replaceAll(RegExp(r'[^\w\s]+'), ''))
        .toList();

    // _widgets.forEach((e) {
    //   final key = e.key.toString().replaceAll(RegExp(r'[^\w\s]+'), '');

    //   _newKeys.add(key);
    // });
    _widgetKeysList = _newKeys;

    final updatedUser = {
      'widgetsList': _newKeys,
    };

    database!.updateUser(auth!.currentUser!.uid, updatedUser);
  }

  void initWidgets(
    BuildContext context, {
    required ProgressTabClass data,
    required BoxConstraints constraints,
  }) {
    _widgetKeysList = data.user.widgetsList ?? _widgetKeysList;

    final Widget latestBodyFat = LatestBodyFatWidget(
      key: const Key('latestBodyFat'),
      data: data,
      constraints: constraints,
    );

    final Widget latestWeight = LatestWeightWidget(
      key: const Key('latestWeight'),
      constraints: constraints,
      data: data,
    );

    final Widget weeklyWorkoutHistorySmall = WeeklyWorkoutWidget.create(
      key: const Key('weeklyWorkoutHistorySmall'),
      user: data.user,
      routineHistories: data.routineHistories,
      constraints: constraints,
    );

    final Widget weeklyWorkoutHistoryMedium = WeeklyBarChartCardTemplate(
      key: const Key('weeklyWorkoutHistoryMedium'),
      progressTabClass: data,
      constraints: constraints,
      defaultColor: kPrimaryColor,
      touchedColor: kPrimary700Color,
      model: weeklyWeightsBarChartModelProvider,
      onTap: () => RoutineHistoriesScreen.show(context),
      titleIcon: Icons.fitness_center_rounded,
      title: S.current.liftedWeights,
      subtitle: S.current.weightsChartMessage,
    );

    final Widget weeklyNutritionChart = WeeklyBarChartCardTemplate(
      key: const Key('weeklyNutritionChart'),
      progressTabClass: data,
      constraints: constraints,
      defaultColor: Colors.greenAccent,
      touchedColor: Colors.green,
      onTap: () => ProteinEntriesScreen.show(context, user: data.user),
      model: weeklyProteinsBarChartModelProvider,
      titleIcon: Icons.restaurant_menu_rounded,
      title: S.current.addProteins,
      subtitle: S.current.proteinChartContentText,
    );

    final Widget weeklyMeasurementsChart = WeeklyMeasurementsCard(
      key: const Key('weeklyMeasurementsChart'),
      progressTabClass: data,
      constraints: constraints,
    );

    final Widget activityRing = DailyActivityRingWidget(
      key: const Key('activityRing'),
      progressTabClass: data,
      constraints: constraints,
    );

    final Widget recentWorkout = MostRecentWorkout(
      key: const Key('recentWorkout'),
      constraints: constraints,
      data: data,
    );

    // Widget stepsWidget = StepsWidget(
    //   key: Key('stepsWidget'),
    //   steps: data.steps,
    // );

    final Widget empty2x2 = SizedBox(
      key: const Key('empty2x2'),
      width: constraints.maxWidth,
      height: constraints.maxHeight / 2,
    );

    final Widget empty1x2 = SizedBox(
      key: const Key('empty1x2'),
      width: constraints.maxWidth,
      height: constraints.maxHeight / 4,
    );

    final Widget empty1x1 = SizedBox(
      key: const Key('empty1x1'),
      width: constraints.maxWidth / 2,
      height: constraints.maxHeight / 4,
    );

    final Widget weeklyCarbsBarChart = WeeklyBarChartCardTemplate(
      key: const Key('weeklyCarbsBarChart'),
      onTap: () => CarbsEntriesScreen.show(context, user: data.user),
      constraints: constraints,
      progressTabClass: data,
      defaultColor: Colors.greenAccent,
      touchedColor: Colors.green,
      title: S.current.carbs,
      titleIcon: Icons.restaurant_menu_rounded,
      model: weeklyCarbsBarChartModelProvider,
    );

    final Widget weeklyFatBarChart = WeeklyBarChartCardTemplate(
      key: const Key('weeklyFatBarChart'),
      onTap: () => FatEntriesScreen.show(context, user: data.user),
      constraints: constraints,
      progressTabClass: data,
      defaultColor: Colors.greenAccent,
      touchedColor: Colors.green,
      title: S.current.fat,
      titleIcon: Icons.restaurant_menu_rounded,
      model: weeklyFatBarChartModelProvider,
    );

    final Widget weeklyCalorieBarChart = WeeklyBarChartCardTemplate(
      key: const Key('weeklyCalorieBarChart'),
      onTap: () => CaloriesEntriesScreen.show(context, user: data.user),
      constraints: constraints,
      progressTabClass: data,
      defaultColor: Colors.greenAccent,
      touchedColor: Colors.green,
      title: S.current.consumedCalorie,
      titleIcon: Icons.local_fire_department_rounded,
      model: weeklyCaloriesBarChartModelProvider,
    );

    _keysAndWidgets = {
      'activityRing': activityRing,
      'empty1x2': empty1x2,
      'empty2x2': empty2x2,
      'weeklyMeasurementsChart': weeklyMeasurementsChart,
      'weeklyNutritionChart': weeklyNutritionChart,
      'weeklyWorkoutHistoryMedium': weeklyWorkoutHistoryMedium,
      'weeklyWorkoutHistorySmall': weeklyWorkoutHistorySmall,
      'recentWorkout': recentWorkout,
      'empty1x1': empty1x1,
      'latestBodyFat': latestBodyFat,
      'latestWeight': latestWeight,
      // 'stepsWidget': stepsWidget,
      'weeklyCarbsBarChart': weeklyCarbsBarChart,
      'weeklyFatBarChart': weeklyFatBarChart,
      'weeklyCalorieBarChart': weeklyCalorieBarChart,
    };

    _widgetKeysList = data.user.widgetsList ?? _widgetKeysList;
    _widgets = List.generate(
      data.user.widgetsList?.length ?? _widgetKeysList.length,
      (index) => _keysAndWidgets[
          data.user.widgetsList?[index] ?? _widgetKeysList[index]]!,
    );
  }
}
