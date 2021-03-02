import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/custom_list_tile_64.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/screens/library_tab/workout/create_workout/create_new_workout_screen.dart';
import 'package:workout_player/services/database.dart';

import '../../../common_widgets/list_item_builder.dart';
import '../../../constants.dart';
import 'create_workout/create_new_workout_widget.dart';
import 'workout_detail_screen.dart';

Logger logger = Logger();

class SavedWorkoutsTab extends StatelessWidget {
  // static Widget create(BuildContext context) {
  //   final database = Provider.of<Database>(context, listen: false);
  //   return Provider<UserSavedWorkoutModel>(
  //     create: (_) => UserSavedWorkoutModel(database: database),
  //     child: SavedWorkoutsTab(),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return StreamBuilder<List<Workout>>(
      stream: database.userWorkoutsStream(),
      builder: (context, snapshot) {
        print(snapshot.error);

        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 12),
              if (snapshot.hasData && snapshot.data.isNotEmpty)
                CreateNewWorkoutWidget(),
              ListItemBuilder<Workout>(
                emptyContentTitle: 'Save workouts, or create your own!',
                emptyContentButton: RaisedButton(
                  child: Text(
                    'Create your own Workout now!',
                    style: ButtonText,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: PrimaryColor,
                  onPressed: () => CreateNewWorkoutScreen.show(context),
                ),
                snapshot: snapshot,
                itemBuilder: (context, workout) => CustomListTile64(
                  tag: 'workout${workout.workoutId}',
                  title: workout.workoutTitle,
                  subtitle: workout.mainMuscleGroup[0],
                  imageUrl: workout.imageUrl,
                  onTap: () => WorkoutDetailScreen.show(
                    context,
                    workout: workout,
                    isRootNavigation: false,
                    tag: 'workout${workout.workoutId}',
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
