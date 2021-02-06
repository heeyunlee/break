import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/custom_list_tile_style1.dart';
import 'package:workout_player/models/user_saved_workout.dart';
import 'package:workout_player/screens/library_tab/workout/user_saved_workout_model.dart';
import 'package:workout_player/screens/library_tab/workout/workout_detail_screen.dart';

import '../../../common_widgets/list_item_builder.dart';
import '../../../services/database.dart';
import 'create_workout/create_new_workout_widget.dart';

class SavedWorkoutsTab extends StatelessWidget {
  static Widget create(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return Provider<UserSavedWorkoutModel>(
      create: (_) => UserSavedWorkoutModel(database: database),
      child: SavedWorkoutsTab(),
    );
  }

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
    final model = Provider.of<UserSavedWorkoutModel>(context, listen: false);

    return StreamBuilder<List<UserSavedWorkout>>(
      stream: model.userSavedWorkoutsStream(),
      builder: (context, snapshot) {
        return ListItemBuilder<UserSavedWorkout>(
          emptyContentTitle: 'Start saving workouts, or create a new one!',
          snapshot: snapshot,
          itemBuilder: (context, userSavedWorkout) => CustomListTileStyle1(
            tag: 'workout${userSavedWorkout.workout.workoutId}',
            title: userSavedWorkout.workout.workoutTitle,
            subtitle: userSavedWorkout.workout.mainMuscleGroup[0],
            imageIndex: userSavedWorkout.workout?.imageIndex ?? 0,
            // imageUrl: userSavedWorkout.workout.imageUrl,
            onTap: () => WorkoutDetailScreen.show(
              context: context,
              workout: userSavedWorkout.workout,
              isRootNavigation: false,
              // index: index,
              // workout: userSavedWorkout.workout,
              // userSavedWorkout: userSavedWorkout,
            ),
          ),
        );
      },
    );
  }
}
