import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/common_widgets/custom_list_tile_style3.dart';
import 'package:workout_player/common_widgets/list_item_builder.dart';
import 'package:workout_player/common_widgets/show_flush_bar.dart';
import 'package:workout_player/common_widgets/tag_widget.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/services/database.dart';

import '../../../constants.dart';

class AddWorkoutsToRoutine extends StatefulWidget {
  const AddWorkoutsToRoutine({
    Key key,
    this.database,
    this.routine,
  }) : super(key: key);

  final Database database;
  final Routine routine;

  static void show(BuildContext context, {Routine routine}) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        builder: (context) => AddWorkoutsToRoutine(
          routine: routine,
          database: database,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _AddWorkoutsToRoutineState createState() => _AddWorkoutsToRoutineState();
}

class _AddWorkoutsToRoutineState extends State<AddWorkoutsToRoutine> {
  Future<void> _submit() async {
    try {
      final routineWorkouts =
          await widget.database.routineWorkoutsStream(widget.routine).first;
      if (routineWorkouts == null || routineWorkouts != null) {
        final index = routineWorkouts.length + 1;
        final routineWorkout = RoutineWorkout(
          routineWorkoutId: documentIdFromCurrentDate(),
          workoutId: selectedWorkoutId,
          workoutTitle: selectedWorkoutTitle,
          numberOfReps: 0,
          numberOfSets: 0,
          index: index,
          sets: [],
          isBodyWeightWorkout: isBodyWeightWorkout,
        );
        await widget.database.setRoutineWorkout(widget.routine, routineWorkout);
        Navigator.of(context).pop();
        showFlushBar(context: context, message: '운동을 추가했습니다!!');
      } else {
        return null;
      }
    } on Exception catch (e) {
      // TODO
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: AppbarBlurBG(),
        title: Text('운동 추가', style: Subtitle1),
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
      // floatingActionButton: FloatingActionButton.extended(
      //   backgroundColor: PrimaryColor,
      //   icon: Icon(
      //     Icons.add_rounded,
      //     color: Colors.white,
      //   ),
      //   label: Text('4개 운동 추가하기', style: ButtonText),
      //   onPressed: _submit,
      // ),
    );
  }

  String selectedWorkoutId;
  String selectedWorkoutTitle;
  bool isBodyWeightWorkout;

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            // _buildChips(),
            // SizedBox(
            //   height: 52,
            //   child: ListView.builder(
            //     shrinkWrap: true,
            //     scrollDirection: Axis.horizontal,
            //     itemCount: 6,
            //     itemBuilder: (context, index) => TagButton(
            //       tagTitle: 'false',
            //     ),
            //   ),
            // ),
            // SizedBox(height: 32),
            // ListTile(
            //   tileColor: Grey800,
            //   title: Text(
            //     '가슴 운동',
            //     style: TextStyle(color: Colors.white),
            //   ),
            // ),
            // SizedBox(height: 8),
            _buildWorkoutStream(),
          ],
        ),
      ),
    );
  }

  Widget _buildChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: <Widget>[
            TagButton(
              tagTitle: '모든 운동',
            ),
            SizedBox(width: 8),
            TagButton(
              tagTitle: '저장한 운동',
            ),
            SizedBox(width: 8),
            TagButton(
              tagTitle: '가슴',
            ),
            SizedBox(width: 8),
            TagButton(
              tagTitle: '등',
            ),
            SizedBox(width: 8),
            TagButton(
              tagTitle: '어깨',
            ),
            SizedBox(width: 8),
            TagButton(
              tagTitle: '하체',
            ),
            SizedBox(width: 8),
            TagButton(
              tagTitle: '홈트',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutStream() {
    final database = Provider.of<Database>(context, listen: false);

    return StreamBuilder<List<Workout>>(
      stream: database.workoutsStream(),
      builder: (context, snapshot) {
        // final initialWorkoutData = snapshot.data;
        return ListItemBuilder<Workout>(
          snapshot: snapshot,
          itemBuilder: (context, workout) => CustomListTileStyle3(
            color: PrimaryColor.withOpacity(0.12),
            imageUrl: workout.imageUrl,
            title: workout.workoutTitle,
            subtitle: workout.mainMuscleGroup,
            onTap: () {
              setState(() {
                selectedWorkoutId = workout.workoutId;
                selectedWorkoutTitle = workout.workoutTitle;
                isBodyWeightWorkout = workout.isBodyWeightWorkout;
              });
              print(selectedWorkoutId);
              print(selectedWorkoutTitle);
              _submit();
            },
          ),
        );
      },
    );
  }
}
// TODO: Create 'Selected Item List' to be able to add multiple workouts at once
// class ListItem<Workout> {
//   bool isSelected = false;
//   Workout workout;
//
//   ListItem(this.workout);
// }
