import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/widgets/get_snackbar_widget.dart';

final setProteinGoalModelProvider = ChangeNotifierProvider(
  (ref) => SetProteinGoalModel(),
);

class SetProteinGoalModel with ChangeNotifier {
  AuthService? auth;
  FirestoreDatabase? database;

  SetProteinGoalModel({
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

  num _proteinGoal = 150;
  num get proteinGoal => _proteinGoal;

  // Future<void> getProteinGoalFromUserData() async {
  //   debugPrint('setProteinGoal function initiated');

  //   final user = (await database!.getUserDocument(auth!.currentUser!.uid))!;
  //   if (user.dailyProteinGoal != null) {
  //     _proteinGoal = user.dailyProteinGoal ?? 150;
  //   }
  //   notifyListeners();
  // }

  void incrementProteinGoal() {
    print(auth!.currentUser.toString());
    print(database!.uid);
    print(_proteinGoal);

    _proteinGoal++;
    notifyListeners();
  }

  void decrementProteinGoal() {
    _proteinGoal--;
    notifyListeners();
  }

  Future<User> getUserData() async {
    final user = (await database!.getUserDocument(auth!.currentUser!.uid))!;
    return user;
  }

  Future<void> setProteinGoal(BuildContext context) async {
    print('set protein goal pressed');

    final userData = {
      'dailyProteinGoal': _proteinGoal,
    };

    await database!.updateUser(auth!.currentUser!.uid, userData);

    Navigator.of(context).pop();

    getSnackbarWidget(
      'Snackbar',
      'SnackBar',
    );
  }
}
