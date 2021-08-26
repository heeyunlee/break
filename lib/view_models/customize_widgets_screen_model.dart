import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/combined/auth_and_database.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/view/widgets/widgets.dart';

import 'main_model.dart';
import 'progress_tab_widgets_model.dart';

final customizeWidgetsScreenModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) => CustomizeWidgetsScreenModel(),
);

class CustomizeWidgetsScreenModel with ChangeNotifier {
  AuthBase? auth;
  Database? database;

  CustomizeWidgetsScreenModel({
    this.auth,
    this.database,
  });

  List<dynamic> _widgetKeysList = [];

  List<dynamic> get widgetKeysList => _widgetKeysList;

  void init(AuthAndDatabase authAndDatabase, User user) {
    _widgetKeysList =
        user.widgetsList ?? ProgressTabWidgetsModel().widgetKeysList;
    auth = authAndDatabase.auth;
    database = authAndDatabase.database;
  }

  void onTap(String key) {
    if (_widgetKeysList.contains(key)) {
      _widgetKeysList.remove(key);
    } else {
      _widgetKeysList.add(key);
    }

    notifyListeners();
  }

  Future<void> submit(BuildContext context) async {
    try {
      final updatedUser = {
        'widgetsList': _widgetKeysList,
      };

      await database!.updateUser(auth!.currentUser!.uid, updatedUser);

      Navigator.of(context).pop();

      getSnackbarWidget(
        S.current.updateWidgetsListSnackbarTitle,
        S.current.updateWidgetsListSnackbarMessage,
      );
    } on FirebaseException catch (e) {
      _showSignInError(e, context);
    }
  }

  void _showSignInError(FirebaseException exception, BuildContext context) {
    logger.e(exception);

    showExceptionAlertDialog(
      context,
      title: S.current.operationFailed,
      exception: exception.message ?? '',
    );
  }

  List<Widget> currentPreviewWidgetList = [
    const ActivityRingSampleWidget(
      color: kCardColor,
      margin: 4,
      key: Key('activityRing'),
    ),
    const MostRecentWorkoutSampleWidget(
      color: kCardColor,
      padding: 4,
      key: Key('recentWorkout'),
    ),
    const WeeklyWorkoutSummarySampleWidget(
      color: kCardColor,
      padding: 4,
      key: Key('weeklyWorkoutHistorySmall'),
    ),
    const LatestBodyFatSampleWidget(
      color: kCardColor,
      padding: 4,
      key: Key('latestBodyFat'),
    ),
    const WeeklyMeasurementsSampleWidget(
      color: kCardColor,
      padding: 4,
      key: Key('weeklyMeasurementsChart'),
    ),
    SampleWidgets().weeklyWeightsBarChart,
    SampleWidgets().weeklyProteinsBarChart,
    SampleWidgets().weeklyCarbsBarChart,
    SampleWidgets().weeklyFatBarChart,
    SampleWidgets().weeklyCaloriesChart,
    const LatestBodyWeightSampleWidget(
      color: kCardColor,
      padding: 4,
      key: Key('latestWeight'),
    ),
  ];
}
