import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/custom_list_tile_style1.dart';

import '../../../common_widgets/list_item_builder.dart';
import '../../../models/workout.dart';
import '../../../services/database.dart';
import 'create_new_workout_widget.dart';
import 'workout_detail_screen.dart';

class SavedWorkout extends StatelessWidget {
  int index;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 16),
          CreateNewWorkoutWidget(),
          SizedBox(height: 4),
          _workoutBuilder(context),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  // Building lists of Workouts from Cloud Firestore
  Widget _workoutBuilder(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return StreamBuilder<List<Workout>>(
      stream: database.savedWorkoutsStream(),
      builder: (context, snapshot) {
        return ListItemBuilder<Workout>(
          emptyContentTitle: 'Start saving workouts, or create a new one!',
          snapshot: snapshot,
          itemBuilder: (context, workout) => CustomListTileStyle1(
            tag: '${workout.workoutId}',
            imageUrl: workout.imageUrl,
            title: workout.workoutTitle,
            subtitle: workout.mainMuscleGroup,
            onTap: () => WorkoutDetailScreen.show(
              context: context,
              index: index,
              workout: workout,
            ),
          ),
        );
      },
    );
  }
}
