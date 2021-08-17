import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

final progressTabModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) => ProgressTabModel(),
);

class ProgressTabModel with ChangeNotifier {
  AuthBase? auth;
  Database? database;

  ProgressTabModel({
    this.auth,
    this.database,
  }) {
    final container = ProviderContainer();
    auth = container.read(authServiceProvider);
    database = container.read(databaseProvider(auth!.currentUser?.uid));
  }

  List<DateTime> _dates = [];
  List<String> _daysOfTheWeek = [];
  DateTime _focusedDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  bool _showBanner = true;
  late AnimationController _animationController;
  late Animation<double> _blurTween;
  late Animation<double> _brightnessTween;
  late bool Function(ScrollNotification) _onNotification;

  List<DateTime> get dates => _dates;
  List<String> get daysOfTheWeek => _daysOfTheWeek;
  DateTime get focusedDate => _focusedDate;
  DateTime get selectedDate => _selectedDate;
  bool get showBanner => _showBanner;
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

  void init({required TickerProvider vsync}) {
    // INIT Background Blur Animation
    _animationController = AnimationController(
      vsync: vsync,
      duration: Duration.zero,
    );

    _blurTween = Tween<double>(begin: 0, end: 20).animate(_animationController);
    _brightnessTween = Tween<double>(begin: 0.0, end: 0.5).animate(
      _animationController,
    );
    _onNotification = (ScrollNotification scrollInfo) {
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

  static const bgPlaceholderHash = [
    'DFEMI3~B5rpx%M_3s8M{xuaK',
    'M1AAExAB00-q~V1SDk0000?vn#~p?vxU4n',
    'M267}#01t7^j0MS}n%j[bajF02~BRjIp={',
    'MvPF1H4.XnaKV[?^n4WFW.aeNHf+VtkWoe',
    'MCI;^i~p004n4o4oD%%M%Mae01WBt8kC%M',
    'MVE{kN~q?b-;xu%MWBIUIUM{%M%MofWBRj',
  ];
}
