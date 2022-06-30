import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:workout_player/models/status.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/database.dart';

class CustomizeWidgetsScreenModel with ChangeNotifier {
  CustomizeWidgetsScreenModel({required this.database});
  final Database database;

  List<dynamic> _widgetKeysList = [];
  int? _selectedImageIndex;

  List<dynamic> get widgetKeysList => _widgetKeysList;
  int? get selectedImageIndex => _selectedImageIndex;

  void init(User user) {
    _widgetKeysList = user.widgetsList ??
        [
          'empty2x2',
          'activityRing',
          'weeklyWorkoutHistorySmall',
          'latestBodyFat',
          'latestWeight',
          'recentWorkout',
          'weeklyMeasurementsChart',
          'weeklyWorkoutHistoryMedium',
        ];
    _selectedImageIndex = user.backgroundImageIndex;
    // notifyListeners();
  }

  void onTap(String key) {
    if (_widgetKeysList.contains(key)) {
      _widgetKeysList.remove(key);
    } else {
      _widgetKeysList.add(key);
    }

    notifyListeners();
  }

  Future<Status> submit() async {
    try {
      final updatedUser = {
        'widgetsList': _widgetKeysList,
        'backgroundImageIndex': _selectedImageIndex,
      };

      await database.updateUser(database.uid!, updatedUser);

      // Navigator.of(context).pop();

      // getSnackbarWidget(
      //   S.current.updateWidgetsListSnackbarTitle,
      //   S.current.updateWidgetsListSnackbarMessage,
      // );

      return Status(statusCode: 200);
    } on FirebaseException catch (e) {
      return Status(statusCode: 404, exception: e);

      // _showSignInError(e, context);
    }
  }

  // void _showSignInError(FirebaseException exception, BuildContext context) {
  //   showExceptionAlertDialog(
  //     context,
  //     title: S.current.operationFailed,
  //     exception: exception.message ?? '',
  //   );
  // }

  void setselectedImageIndex(int? index) {
    _selectedImageIndex = index;
    notifyListeners();
  }

  Future<void> initSelectedImageIndex() async {
    final user = await database.getUserDocument(database.uid!);

    _selectedImageIndex = user!.backgroundImageIndex;
    notifyListeners();
  }

  Future<Status> updateBackground() async {
    try {
      final user = {
        'backgroundImageIndex': _selectedImageIndex,
      };

      await database.updateUser(database.uid!, user);

      return Status(statusCode: 200);

      // Navigator.of(context).pop();

      // getSnackbarWidget(
      //   S.current.updateBackgroundSnackbarTitle,
      //   S.current.updateBackgroundSnackbarMessage,
      // );
    } catch (e) {
      return Status(statusCode: 404, exception: e);
    }
  }

  // List<Widget> currentPreviewWidgetList = [
  //   ActivityRing(
  //     key: Key('activityRing'),
  //     muscleName: 'Chest',
  //     liftedWeights: 10000,
  //     weightGoal: 20000,
  //     consumedProtein: 75,
  //     proteinGoal: 150,
  //     unit: UnitOfMass.kilograms,
  //     cardColor: Colors.transparent,
  //     elevation: 0,
  //   ),
  //   const MostRecentWorkoutSampleWidget(
  //     padding: 4,
  //     key: Key('recentWorkout'),
  //   ),
  //   const WeeklyWorkoutSummarySampleWidget(
  //     padding: 4,
  //     key: Key('weeklyWorkoutHistorySmall'),
  //   ),
  //   const LatestBodyFatSampleWidget(
  //     padding: 4,
  //     key: Key('latestBodyFat'),
  //   ),
  //   const WeeklyMeasurementsSampleWidget(
  //     padding: 4,
  //     key: Key('weeklyMeasurementsChart'),
  //   ),
  //   // SampleWidgets().weeklyWeightsBarChart,
  //   // SampleWidgets().weeklyProteinsBarChart,
  //   // SampleWidgets().weeklyCarbsBarChart,
  //   // SampleWidgets().weeklyFatBarChart,
  //   // SampleWidgets().weeklyCaloriesChart,
  //   const LatestBodyWeightSampleWidget(
  //     padding: 4,
  //     key: Key('latestWeight'),
  //   ),
  // ];
}
