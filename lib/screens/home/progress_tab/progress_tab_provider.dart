import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

class ProgressTabProvider {
  static const bgList = [
    'assets/images/bg001.jpeg',
    'assets/images/bg002.jpeg',
    'assets/images/bg003.jpeg',
  ];

  static const bgURL = [
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/home_tab_bg%2Fbg001_1000x1000.jpeg?alt=media&token=199346a5-fb06-4871-a2e6-3f2ed7f628c1',
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/home_tab_bg%2Fbg002_1000x1000.jpeg?alt=media&token=2b60a27e-1efa-4b19-9325-7436b0f3d4fc',
    'https://firebasestorage.googleapis.com/v0/b/player-h.appspot.com/o/home_tab_bg%2Fbg003_1000x1000.jpeg?alt=media&token=4e9d2e6f-b550-4bd6-8a21-7d8e95a169fb',
  ];
}

class ProgressTabModel with ChangeNotifier {
  AuthService? auth;
  FirestoreDatabase? database;

  ProgressTabModel({
    this.auth,
    this.database,
  }) {
    final container = ProviderContainer();
    auth = container.read(authServiceProvider2);
    database = container.read(databaseProvider2(auth!.currentUser?.uid));
  }

  DateTime _focusedDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  bool _showBanner = true;

  DateTime get focusedDate => _focusedDate;
  DateTime get selectedDate => _selectedDate;
  bool get showBanner => _showBanner;

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
}

final progressTabModelProvider = ChangeNotifierProvider(
  (ref) => ProgressTabModel(),
);
