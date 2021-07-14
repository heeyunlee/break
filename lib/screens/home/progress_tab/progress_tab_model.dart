import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/models/auth_and_database.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/models/nutritions_and_routine_histories.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

// final progressTabModelProvider =
//     ChangeNotifierProvider.family<ProgressTabModel, AuthAndDatabase>(
//   (ref, authAndDatabase) => ProgressTabModel(
//     auth: authAndDatabase.authbase,
//     database: authAndDatabase.database,
//   ),
// );

final progressTabModelProvider = ChangeNotifierProvider(
  (ref) => ProgressTabModel(),
);

class ProgressTabModel with ChangeNotifier {
  late AuthBase? auth;
  late Database? database;

  ProgressTabModel({
    this.auth,
    this.database,
  });

  List<DateTime> _dates = [];
  List<String> _daysOfTheWeek = [];
  DateTime _focusedDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  bool _showBanner = true;
  num _nutritionDailyGoal = 150;
  num _nutritionDailyTotal = 0;
  double _nutritionDailyProgress = 0.0;
  num _liftingDailyGoal = 10000;
  num _weightsLiftedDailyTotal = 0;
  double _weightsLiftedDailyProgress = 0.0;
  String _todaysMuscleWorked = '-';
  late AnimationController _animationController;
  late Animation<double> _blurTween;
  late Animation<double> _brightnessTween;
  late bool Function(ScrollNotification) _onNotification;

  List<DateTime> get dates => _dates;
  List<String> get daysOfTheWeek => _daysOfTheWeek;
  DateTime get focusedDate => _focusedDate;
  DateTime get selectedDate => _selectedDate;
  bool get showBanner => _showBanner;
  num get nutritionDailyGoal => _nutritionDailyGoal;
  num get nutritionDailyTotal => _nutritionDailyTotal;
  double get nutritionDailyProgress => _nutritionDailyProgress;

  num get liftingDailyGoal => _liftingDailyGoal;
  num get weightsLiftedDailyTotal => _weightsLiftedDailyTotal;
  double get weightsLiftedDailyProgress => _weightsLiftedDailyProgress;
  String get todaysMuscleWorked => _todaysMuscleWorked;
  AnimationController get animationController => _animationController;
  Animation<double> get blurTween => _blurTween;
  Animation<double> get brightnessTween => _brightnessTween;
  bool Function(ScrollNotification) get onNotification => _onNotification;

  void selectSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void selectFocusedDate(DateTime date) {
    _focusedDate = date;
    notifyListeners();
  }

  void setShowBanner(bool value) {
    _showBanner = value;
    notifyListeners();
  }

  void initWeeklyDates() {
    DateTime now = DateTime.now();

    // Create list of 7 days
    _dates = List<DateTime>.generate(7, (index) {
      return DateTime.utc(now.year, now.month, now.day - index);
    });
    _dates = _dates.reversed.toList();

    // Create list of 7 days of the week
    _daysOfTheWeek = List<String>.generate(
      7,
      (index) => DateFormat.E().format(_dates[index]),
    );
  }

  void init(TickerProvider vsync, AuthAndDatabase authAndDatabase) {
    auth = authAndDatabase.auth;
    database = authAndDatabase.database;

    _animationController = AnimationController(
      vsync: vsync,
      duration: Duration(seconds: 0),
    );

    _blurTween = Tween<double>(begin: 0, end: 20).animate(animationController);
    _brightnessTween = Tween<double>(begin: 1, end: 0.0).animate(
      animationController,
    );
    _onNotification = (ScrollNotification scrollInfo) {
      // debugPrint('${scrollInfo.metrics.pixels}');

      if (scrollInfo.metrics.axis == Axis.vertical) {
        _animationController.animateTo(
          scrollInfo.metrics.pixels / 1400,
        );

        return true;
      }
      return false;
    };
  }

  Future<void> initShowBanner() async {
    final uid = auth!.currentUser!.uid;
    final user = await database!.getUserDocument(uid);
    if (user!.dailyProteinGoal == null ||
        user.dailyWeightsGoal == null ||
        user.weightGoal == null ||
        user.bodyFatPercentageGoal == null) {
      _showBanner = true;
    } else {
      _showBanner = false;
    }
  }

  void setDailyGoal(User user) {
    _nutritionDailyGoal = user.dailyProteinGoal ?? 150.0;
    _liftingDailyGoal = user.dailyWeightsGoal ?? 10000;
  }

  void setDailyTotal(NutritionsAndRoutineHistories data) {
    _nutritionDailyTotal = 0;
    _nutritionDailyProgress = 0;
    _weightsLiftedDailyTotal = 0;
    _weightsLiftedDailyProgress = 0;
    _todaysMuscleWorked = '-';

    if (data.nutritions.isNotEmpty) {
      data.nutritions.forEach((e) {
        _nutritionDailyTotal += e.proteinAmount.toInt();
      });
      _nutritionDailyProgress = _nutritionDailyTotal / _nutritionDailyGoal;

      if (_nutritionDailyProgress >= 1) {
        _nutritionDailyProgress = 1;
      }
    }

    if (data.routineHistories.isNotEmpty) {
      data.routineHistories.forEach((e) {
        _weightsLiftedDailyTotal += e.totalWeights.toInt();
      });

      _weightsLiftedDailyProgress =
          _weightsLiftedDailyTotal / _liftingDailyGoal;

      if (_weightsLiftedDailyProgress >= 1) {
        _weightsLiftedDailyProgress = 1;
      }

      final latest = data.routineHistories.last;

      _todaysMuscleWorked = MainMuscleGroup.values
          .firstWhere((e) => e.toString() == latest.mainMuscleGroup[0])
          .broadGroup!;
    }
  }

  // CONST VARIABLES
  static const bgURL = [
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/home_tab_bg%2Fbg001_1000x1000.jpeg?alt=media&token=199346a5-fb06-4871-a2e6-3f2ed7f628c1',
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/home_tab_bg%2Fbg002_1000x1000.jpeg?alt=media&token=2b60a27e-1efa-4b19-9325-7436b0f3d4fc',
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/home_tab_bg%2Fbg003_1000x1000.jpeg?alt=media&token=4e9d2e6f-b550-4bd6-8a21-7d8e95a169fb',
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/home_tab_bg%2Fbg004_1000x1000.jpeg?alt=media&token=592ae255-735c-4c94-9b04-a00ae743047c',
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/home_tab_bg%2Fbg005_1000x1000.jpeg?alt=media&token=16aea7d3-596c-4e80-92e8-acd4c2d4d3b7',
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/home_tab_bg%2Fbg006_1000x1000.jpeg?alt=media&token=2f95cfc4-38c9-4105-b0f8-150c94758d3a',
  ];
}
