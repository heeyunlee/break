import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/classes/combined/auth_and_database.dart';

import 'package:workout_player/classes/user.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/screens/preview/sample_widgets/activity_ring_sample_widget.dart';
import 'package:workout_player/screens/preview/sample_widgets/latest_body_fat_sample_widget.dart';
import 'package:workout_player/screens/preview/sample_widgets/latest_body_weight_sample_widget.dart';
import 'package:workout_player/screens/preview/sample_widgets/most_recent_workout_sample_widget.dart';
import 'package:workout_player/screens/preview/sample_widgets/sample_widgets.dart';
import 'package:workout_player/screens/preview/sample_widgets/weekly_measurements_sample_widget.dart';
import 'package:workout_player/screens/preview/sample_widgets/weekly_workout_summary_sample_widget.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/widgets/get_snackbar_widget.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';

import '../progress_tab_model.dart';

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
    _widgetKeysList = user.widgetsList ?? ProgressTabModel().widgetKeysList;
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
    ActivityRingSampleWidget(
      color: kCardColor,
      margin: 4,
      key: Key('activityRing'),
    ),
    MostRecentWorkoutSampleWidget(
      color: kCardColor,
      padding: 4,
      key: Key('recentWorkout'),
    ),
    WeeklyWorkoutSummarySampleWidget(
      color: kCardColor,
      padding: 4,
      key: Key('weeklyWorkoutHistorySmall'),
    ),
    LatestBodyFatSampleWidget(
      color: kCardColor,
      padding: 4,
      key: Key('latestBodyFat'),
    ),
    WeeklyMeasurementsSampleWidget(
      color: kCardColor,
      padding: 4,
      key: Key('weeklyMeasurementsChart'),
    ),
    SampleWidgets().weeklyWeightsBarChart,
    SampleWidgets().weeklyProteinsBarChart,
    SampleWidgets().weeklyCarbsBarChart,
    SampleWidgets().weeklyFatBarChart,
    SampleWidgets().weeklyCaloriesChart,
    LatestBodyWeightSampleWidget(
      color: kCardColor,
      padding: 4,
      key: Key('latestWeight'),
    ),
  ];
}
