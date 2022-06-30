import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/combined/progress_tab_class.dart';
import 'package:workout_player/models/enum/unit_of_mass.dart';
import 'package:workout_player/models/models.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/services/top_level_variables.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/features/progress/progress_widgets.dart';
import 'package:workout_player/features/screens/routine_histories_screen.dart';
import 'package:workout_player/features/widgets/progress/latest_body_fat_widget.dart';
import 'package:workout_player/features/widgets/progress/latest_weight_widget.dart';
import 'package:workout_player/features/widgets/progress/weekly_measurements_card.dart';

class MoveTabWidgetsModel with ChangeNotifier {
  MoveTabWidgetsModel({
    required this.database,
    required this.topLevelVariables,
  });

  final Database database;
  final TopLevelVariables topLevelVariables;

  Map<String, Widget> _keysAndWidgets = {};
  List<Widget> _widgets = [];
  static List _widgetKeysList = [
    'empty2x2',
    'activityRing',
    'weeklyWorkoutHistorySmall',
    'latestBodyFat',
    'latestWeight',
    'recentWorkout',
    'weeklyMeasurementsChart',
    'weeklyWorkoutHistoryMedium',
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

    final newKeys = _widgets
        .map((widget) =>
            widget.key.toString().replaceAll(RegExp(r'[^\w\s]+'), ''))
        .toList();

    // _widgets.forEach((e) {
    //   final key = e.key.toString().replaceAll(RegExp(r'[^\w\s]+'), '');

    //   _newKeys.add(key);
    // });
    _widgetKeysList = newKeys;

    final updatedUser = {
      'widgetsList': newKeys,
    };

    database.updateUser(database.uid!, updatedUser);
  }

  void initWidgets(
    BuildContext context, {
    required ProgressTabClass data,
    required BoxConstraints constraints,
  }) {
    final heightFactor = (constraints.maxHeight > 600) ? 4 : 3.5;
    _widgetKeysList = data.user.widgetsList ?? _widgetKeysList;

    // final Widget weeklyWorkoutHistorySmall = WeeklyWorkoutWidget.create(
    //   key: const Key('weeklyWorkoutHistorySmall'),
    //   user: data.user,
    //   routineHistories: data.routineHistories,
    //   constraints: constraints,
    // );

    Map<DateTime, List<RoutineHistory>> mapData;
    List<double> listOfYs = [];

    mapData = {
      for (var item in topLevelVariables.thisWeek)
        item: data.routineHistories
            .where((e) => e.workoutDate.toUtc() == item)
            .toList()
    };

    listOfYs = mapData.values.map((list) {
      double sum = 0;

      if (list.isNotEmpty) {
        for (final history in list) {
          sum += history.totalWeights;
        }
      }

      return sum;
    }).toList();

    List<String?> muscleWorked = mapData.values.map((list) {
      if (list.isNotEmpty) {
        final todaysMuscleWorked = Formatter.getFirstMainMuscleGroup(
          list.last.mainMuscleGroup,
          list.last.mainMuscleGroupEnum,
        );

        return todaysMuscleWorked;
      } else {
        return null;
      }
    }).toList();

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

    final Widget weeklyWorkoutHistorySmall = WeeklyWorkoutSummary(
      key: const Key('weeklyWorkoutHistorySmall'),
      weeklyWorkedOutMuscles: muscleWorked,
      height: constraints.maxHeight / heightFactor,
      width: constraints.maxWidth,
      cardOnTap: () => RoutineHistoriesScreen.show(context),
    );

    final Widget weeklyWorkoutHistoryMedium = WeeklyBarChart(
      yValues: listOfYs,
      key: const Key('weeklyWorkoutHistoryMedium'),
      color: Colors.red,
      unit: data.user.unitOfMassEnum?.label ?? 'Kg',
      titleOnTap: () => RoutineHistoriesScreen.show(context),
      leadingIcon: Icons.fitness_center_rounded,
      title: S.current.liftedWeights,
      subtitle: S.current.weightsChartMessage,
      height: constraints.maxHeight / 2,
    );

    final Widget weeklyMeasurementsChart = WeeklyMeasurementsCard(
      key: const Key('weeklyMeasurementsChart'),
      data: data,
      constraints: constraints,
    );

    final Widget activityRing = ActivityRing(
      key: const Key('activityRing'),
      width: constraints.maxWidth,
      height: constraints.maxHeight / 4,
      liftedWeights: 12000,
      consumedProtein: 120,
      muscleName: 'Chest',
      proteinGoal: 100,
      unit: UnitOfMass.kilograms,
      weightGoal: 15000,
      cardColor: Colors.transparent,
      elevation: 0,
      onTap: () {},
    );

    final Widget recentWorkout = MostRecentWorkout(
      key: const Key('recentWorkout'),
      workoutEndTime: DateTime.now(),
      routineTitle: 'Chest Workout',
      totalWeights: 12000,
      unit: UnitOfMass.kilograms,
      durationInMins: 75,
      height: constraints.maxHeight / 4,

      // routineHistory: (data.routineHistories.isNotEmpty)
      //     ? data.routineHistories.last
      //     : null,
      // constraints: constraints,
      // data: data,
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

    // final Widget weeklyCarbsBarChart = WeeklyBarChartCardTemplate(
    //   key: const Key('weeklyCarbsBarChart'),
    //   onTap: () => CarbsEntriesScreen.show(context, user: data.user),
    //   constraints: constraints,
    //   progressTabClass: data,
    //   defaultColor: Colors.greenAccent,
    //   touchedColor: Colors.green,
    //   title: S.current.carbs,
    //   titleIcon: Icons.restaurant_menu_rounded,
    //   model: weeklyCarbsBarChartModelProvider,
    // );

    // final Widget weeklyFatBarChart = WeeklyBarChartCardTemplate(
    //   key: const Key('weeklyFatBarChart'),
    //   onTap: () => FatEntriesScreen.show(context, user: data.user),
    //   constraints: constraints,
    //   progressTabClass: data,
    //   defaultColor: Colors.greenAccent,
    //   touchedColor: Colors.green,
    //   title: S.current.fat,
    //   titleIcon: Icons.restaurant_menu_rounded,
    //   model: weeklyFatBarChartModelProvider,
    // );

    // final Widget weeklyCalorieBarChart = WeeklyBarChartCardTemplate(
    //   key: const Key('weeklyCalorieBarChart'),
    //   onTap: () => CaloriesEntriesScreen.show(context, user: data.user),
    //   constraints: constraints,
    //   progressTabClass: data,
    //   defaultColor: Colors.greenAccent,
    //   touchedColor: Colors.green,
    //   title: S.current.consumedCalorie,
    //   titleIcon: Icons.local_fire_department_rounded,
    //   model: weeklyCaloriesBarChartModelProvider,
    // );

    _keysAndWidgets = {
      'activityRing': activityRing,
      'empty1x2': empty1x2,
      'empty2x2': empty2x2,
      'weeklyMeasurementsChart': weeklyMeasurementsChart,
      // 'weeklyNutritionChart': weeklyNutritionChart,
      'weeklyWorkoutHistoryMedium': weeklyWorkoutHistoryMedium,
      'weeklyWorkoutHistorySmall': weeklyWorkoutHistorySmall,
      'recentWorkout': recentWorkout,
      'empty1x1': empty1x1,
      'latestBodyFat': latestBodyFat,
      'latestWeight': latestWeight,
      // 'stepsWidget': stepsWidget,
      // 'weeklyCarbsBarChart': weeklyCarbsBarChart,
      // 'weeklyFatBarChart': weeklyFatBarChart,
      // 'weeklyCalorieBarChart': weeklyCalorieBarChart,
    };

    _widgetKeysList = data.user.widgetsList ?? _widgetKeysList;
    _widgets = List.generate(
      data.user.widgetsList?.length ?? _widgetKeysList.length,
      (index) =>
          _keysAndWidgets[
              data.user.widgetsList?[index] ?? _widgetKeysList[index]] ??
          Container(),
    );
  }
}
