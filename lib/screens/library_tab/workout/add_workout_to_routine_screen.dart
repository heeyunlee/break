import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/common_widgets/custom_list_tile_style1.dart';
import 'package:workout_player/common_widgets/list_item_builder.dart';
import 'package:workout_player/common_widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/common_widgets/show_flush_bar.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/screens/library_tab/routine/routine_detail_screen.dart';
import 'package:workout_player/services/database.dart';

import '../../../constants.dart';

class AddWorkoutToRoutineScreen extends StatefulWidget {
  const AddWorkoutToRoutineScreen({
    Key key,
    this.database,
    this.workout,
  }) : super(key: key);

  final Database database;
  final Workout workout;

  static void show(BuildContext context, {Workout workout}) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context, rootNavigator: false).push(
      CupertinoPageRoute(
        builder: (context) => AddWorkoutToRoutineScreen(
          workout: workout,
          database: database,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _AddWorkoutToRoutineScreenState createState() =>
      _AddWorkoutToRoutineScreenState();
}

class _AddWorkoutToRoutineScreenState extends State<AddWorkoutToRoutineScreen> {
  Future<void> _submit(Routine routine) async {
    try {
      final routineWorkouts =
          await widget.database.routineWorkoutsStream(routine).first;
      if (routineWorkouts != null) {
        final index = routineWorkouts.length + 1;

        final routineWorkout = RoutineWorkout(
          routineWorkoutId: documentIdFromCurrentDate(),
          workoutId: widget.workout.workoutId,
          workoutTitle: widget.workout.workoutTitle,
          isBodyWeightWorkout: widget.workout.isBodyWeightWorkout,
          totalWeights: 0,
          numberOfSets: 0,
          numberOfReps: 0,
          sets: [],
          index: index,
        );
        await widget.database.setRoutineWorkout(routine, routineWorkout);
        Navigator.of(context).popUntil((route) => route.isFirst);
        RoutineDetailScreen.show(
          context: context,
          routine: routine,
          isRootNavigation: false,
        );
        showFlushBar(context: context, message: 'Added workout to the routine');
      }
    } on Exception catch (e) {
      ShowExceptionAlertDialog(
        context,
        title: 'Operation Failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: AppbarBlurBG(),
        title: Text('Add workout to Routine', style: Subtitle1),
        leading: IconButton(
          icon: Icon(
            Icons.close_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      clipBehavior: Clip.none,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            SizedBox(height: 96),
            _buildRoutinesStream(context),
          ],
        ),
      ),
    );
  }

  Widget _buildRoutinesStream(BuildContext context) {
    // final database = Provider.of<Database>(context, listen: false);

    return StreamBuilder<List<Routine>>(
      stream: widget.database.routinesStream(),
      builder: (context, snapshot) {
        return ListItemBuilder<Routine>(
          emptyContentTitle: 'Create a new routine',
          snapshot: snapshot,
          itemBuilder: (context, routine) => CustomListTileStyle1(
            tag: 'routine${routine.routineId}',
            title: routine.routineTitle,
            subtitle: 'by ${routine.routineOwnerUserName}',
            imageUrl: routine.imageUrl,
            imageIndex: routine.imageIndex ?? 0,
            onTap: () => _submit(routine),
          ),
        );
      },
    );
  }
}
