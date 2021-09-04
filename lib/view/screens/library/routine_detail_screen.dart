import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/view/screens/library/routine_workouts_tab.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/main_model.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/combined/routine_detail_screen_class.dart';
import 'package:workout_player/services/database.dart';

import 'package:workout_player/services/auth.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/utils/dummy_data.dart';
import 'package:workout_player/view/widgets/library/routine_detail_screen_sliver_widget.dart';
import 'package:workout_player/view/widgets/library/routine_history_tab.dart';
import 'package:workout_player/view/widgets/builders/custom_stream_builder.dart';
import 'package:workout_player/view_models/routine_detail_screen_model.dart';

class RoutineDetailScreen extends StatefulWidget {
  final Database database;
  final Routine routine;
  final String tag;
  final AuthBase auth;
  final RoutineDetailScreenModel model;

  const RoutineDetailScreen({
    Key? key,
    required this.database,
    required this.routine,
    required this.tag,
    required this.auth,
    required this.model,
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
      builder: (context, auth, database) => Consumer(
        builder: (context, watch, child) => RoutineDetailScreen(
          routine: routine,
          tag: tag,
          auth: auth,
          database: database,
          model: watch(routineDetailScreenModelProvider),
        ),
      ),
    );
  }

  @override
  _RoutineDetailScreenState createState() => _RoutineDetailScreenState();
}

class _RoutineDetailScreenState extends State<RoutineDetailScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.model.init(this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.d('[RoutineDetailScreen] building...');

    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      backgroundColor: kBackgroundColor,
      body: CustomStreamBuilder<RoutineDetailScreenClass>(
        stream: widget.database.routineDetailScreenStream(
          widget.routine.routineId,
        ),
        builder: (context, data) => LayoutBuilder(
          builder: (context, constraints) {
            return DefaultTabController(
              length: 2,
              child: NestedScrollView(
                controller: widget.model.scrollController,
                clipBehavior: Clip.antiAlias,
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    RoutineDetailScreenSliverWidget(
                      constraints: constraints,
                      data: data,
                      tag: widget.tag,
                    ),
                  ];
                },
                body: TabBarView(
                  children: [
                    RoutineWorkoutsTab(
                      auth: widget.auth,
                      database: widget.database,
                      data: data,
                    ),
                    RoutineHistoryTab(
                      routine: data.routine ?? routineDummyData,
                      auth: widget.auth,
                      database: widget.database,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
