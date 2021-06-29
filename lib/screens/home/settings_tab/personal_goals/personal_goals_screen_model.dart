import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/widgets/get_snackbar_widget.dart';

final personalGoalsScreenModelProvider = ChangeNotifierProvider(
  (ref) => PersonalGoalsScreenModel(),
);

class PersonalGoalsScreenModel with ChangeNotifier {
  AuthService? auth;
  FirestoreDatabase? database;

  PersonalGoalsScreenModel({
    this.auth,
    this.database,
  }) {
    final container = ProviderContainer();
    auth = container.read(authServiceProvider2);
    database = container.read(databaseProvider2(auth!.currentUser?.uid));
  }

  Future<void> initProteinGoal() async {
    final user = (await database!.getUserDocument(auth!.currentUser!.uid))!;
    _proteinGoal = user.dailyProteinGoal ?? 150;

    notifyListeners();
  }

  Future<void> initLiftingGoal() async {
    final user = (await database!.getUserDocument(auth!.currentUser!.uid))!;
    _liftingGoal = user.dailyWeightsGoal ?? 20000;

    notifyListeners();
  }

  num _proteinGoal = 150.0;
  num _liftingGoal = 20000.0;

  num get proteinGoal => _proteinGoal;
  num get liftingGoal => _liftingGoal;

  // Protein Goal
  void incrementProteinGoal() {
    _proteinGoal++;
    notifyListeners();
  }

  void decrementProteinGoal() {
    _proteinGoal--;
    notifyListeners();
  }

  Future<void> setProteinGoal(BuildContext context) async {
    final userData = {
      'dailyProteinGoal': _proteinGoal,
    };

    await database!.updateUser(auth!.currentUser!.uid, userData);

    Navigator.of(context).popUntil((route) => route.isFirst);

    getSnackbarWidget(
      S.current.setProteinGoalSnackbarTitle,
      S.current.setProteinGoalSnackbarBody,
    );
  }

  // Lifting Goal
  void incrementLiftingGoal() {
    _liftingGoal += 500;
    notifyListeners();
  }

  void decrementLiftingGoal() {
    _liftingGoal -= 500;
    notifyListeners();
  }

  Future<void> setLiftingGoal(BuildContext context) async {
    final userData = {
      'dailyWeightsGoal': _liftingGoal,
    };

    await database!.updateUser(auth!.currentUser!.uid, userData);

    Navigator.of(context).popUntil((route) => route.isFirst);

    getSnackbarWidget(
      S.current.setLiftingGoalSnackbarTitle,
      S.current.setLiftingGoalSnackbarBody,
    );
  }
}
