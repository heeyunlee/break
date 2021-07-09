import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/models/nutrition.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

final progressTabModelProvider = ChangeNotifierProvider(
  (ref) => ProgressTabModel(),
);

class ProgressTabModel with ChangeNotifier {
  AuthService? auth;
  FirestoreDatabase? database;

  ProgressTabModel({
    this.auth,
    this.database,
  }) {
    final container = ProviderContainer();
    // auth = container.read(authServiceProvider2);
    auth = container.read(authServiceProvider3);
    database = container.read(databaseProvider2(auth!.currentUser?.uid));
  }

  DateTime _focusedDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  bool _showBanner = true;
  num _nutritionDailyGoal = 150;
  num _nutritionDailyTotal = 0;
  double _nutritionDailyProgress = 0.0;
  late AnimationController _animationController;
  late Animation<double> _blurTween;
  late Animation<double> _brightnessTween;
  late bool Function(ScrollNotification) _onNotification;

  DateTime get focusedDate => _focusedDate;
  DateTime get selectedDate => _selectedDate;
  bool get showBanner => _showBanner;
  num get nutritionDailyGoal => _nutritionDailyGoal;
  num get nutritionDailyTotal => _nutritionDailyTotal;
  double get nutritionDailyProgress => _nutritionDailyProgress;
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

  Future<void> initShowBanner() async {
    final userData = (await database!.getUserDocument(auth!.currentUser!.uid))!;
    if (userData.dailyProteinGoal == null ||
        userData.dailyWeightsGoal == null) {
      _showBanner = true;
    } else {
      _showBanner = false;
    }
    notifyListeners();
  }

  void setNutritionDailyGoal(num? value) {
    _nutritionDailyGoal = value ?? 150.0;
  }

  void setNutritionDailyTotal(List<Nutrition>? data) {
    _nutritionDailyTotal = 0;

    if (data != null) {
      data.forEach((e) {
        _nutritionDailyTotal += e.proteinAmount.toInt();
      });
      _nutritionDailyProgress = _nutritionDailyTotal / _nutritionDailyGoal;

      if (_nutritionDailyProgress >= 1) {
        _nutritionDailyProgress = 1;
      }
    }
  }

  void init(TickerProvider vsync) {
    _animationController = AnimationController(
      vsync: vsync,
      duration: Duration(seconds: 0),
    );

    _blurTween = Tween<double>(begin: 0, end: 20).animate(animationController);
    _brightnessTween = Tween<double>(begin: 0.9, end: 0.0).animate(
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
