import 'package:flutter/material.dart';

import 'package:workout_player/models/combined/combined_models.dart';
import 'package:workout_player/models/models.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/main_model.dart';

class RoutineDetailScreen extends StatelessWidget {
  final Routine routine;
  final String tag;
  final AuthAndDatabase authAndDatabase;

  const RoutineDetailScreen({
    Key? key,
    required this.routine,
    required this.tag,
    required this.authAndDatabase,
  }) : super(key: key);

  // For Navigation
  static Future<void> show(
    BuildContext context, {
    required Routine routine,
    required String tag,
  }) async {
    customPush(
      context,
      rootNavigator: false,
      builder: (context, auth, database) => RoutineDetailScreen(
        routine: routine,
        tag: tag,
        authAndDatabase: AuthAndDatabase(auth: auth, database: database),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    logger.d('[RoutineDetailScreen] building...');

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      backgroundColor: kBackgroundColor,
      body: CustomStreamBuilder<RoutineDetailScreenClass>(
        stream: authAndDatabase.database.routineDetailScreenStream(
          routine.routineId,
        ),
        loadingWidget: const RoutineDetailScreenShimmer(),
        builder: (context, data) => RoutineStreamHasDataWidget.create(
          data: data,
          tag: tag,
          authAndDatabase: authAndDatabase,
        ),
      ),
    );
  }
}
