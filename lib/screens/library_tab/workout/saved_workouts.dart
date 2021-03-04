import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common_widgets/custom_list_tile_64.dart';
import '../../../common_widgets/list_item_builder.dart';
import '../../../constants.dart';
import '../../../models/workout.dart';
import '../../../services/database.dart';
import 'create_workout/create_new_workout_screen.dart';
import 'create_workout/create_new_workout_widget.dart';
import 'workout_detail_screen.dart';

class SavedWorkoutsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return StreamBuilder<List<Workout>>(
      stream: database.userWorkoutsStream(),
      builder: (context, snapshot) {
        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 12),
              if (snapshot.hasData && snapshot.data.isNotEmpty)
                CreateNewWorkoutWidget(),
              ListItemBuilder<Workout>(
                emptyContentTitle: 'Save workouts, or create your own!',
                emptyContentButton: RaisedButton(
                  child: const Text(
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
