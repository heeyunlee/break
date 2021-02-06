import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/custom_list_tile_style2.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/screens/library_tab/routine/routine_detail_screen.dart';
import 'package:workout_player/screens/library_tab/workout/workout_detail_screen.dart';
import 'package:workout_player/screens/search_tab/more_routine_search_results_screen.dart';
import 'package:workout_player/screens/search_tab/more_workout_search_results_screen.dart';

import '../../common_widgets/list_item_builder.dart';
import '../../common_widgets/workout_filter_button.dart';
import '../../constants.dart';
import '../../models/workout.dart';
import '../../services/database.dart';

class SearchScreenBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 64),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 64,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Today is',
                    style: Headline5.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 24),
                  Image.network(
                    'https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/facebook/230/leg_1f9b5.png',
                    height: 64,
                  ),
                  SizedBox(width: 24),
                  Text(
                    'Day',
                    style: Headline5.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 64),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    WorkoutFilterButton(
                      tagTitle: 'Chest',
                      searchCategory: 'mainMuscleGroup',
                      buttonTitle: 'Chest',
                    ),
                    SizedBox(width: 16),
                    WorkoutFilterButton(
                      tagTitle: 'Back',
                      searchCategory: 'mainMuscleGroup',
                      buttonTitle: 'Back',
                    ),
                    SizedBox(width: 16),
                    WorkoutFilterButton(
                      tagTitle: 'Shoulder',
                      searchCategory: 'mainMuscleGroup',
                      buttonTitle: 'Shoulder',
                    ),
                    SizedBox(width: 16),
                    WorkoutFilterButton(
                      tagTitle: 'Leg',
                      searchCategory: 'mainMuscleGroup',
                      buttonTitle: 'Leg',
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    WorkoutFilterButton(
                      tagTitle: 'Dumbbell',
                      searchCategory: 'equipmentRequired',
                      buttonTitle: 'Dumbbell Workout',
                    ),
                    SizedBox(width: 16),
                    WorkoutFilterButton(
                      tagTitle: 'EZ Bar',
                      searchCategory: 'equipmentRequired',
                      buttonTitle: 'EZ Bar Workout',
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
          _buildWorkoutListView(context),
          _buildRoutineListView(context),
        ],
      ),
    );
  }

  // Stream Builder of Public Workout data from Cloud Firestore
  Widget _buildWorkoutListView(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.centerLeft,
          child: Text(
            'Today\'s recommended workouts',
            style: Headline6,
          ),
        ),
        StreamBuilder<List<Workout>>(
          stream: database.workoutsInitialStream(),
          builder: (context, snapshot) {
            return ListItemBuilder<Workout>(
              emptyContentTitle: 'Empty...',
              snapshot: snapshot,
              itemBuilder: (context, workout) => CustomListTileStyle2(
                title: workout.workoutTitle,
                subtitle: workout.mainMuscleGroup[0],
                imageIndex: workout.imageIndex ?? 0,
                onTap: () => WorkoutDetailScreen.show(
                  context: context,
                  // index: index,
                  workout: workout,
                  isRootNavigation: false,
                ),
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: OutlineButton(
            highlightedBorderColor: PrimaryColor,
            borderSide: BorderSide(color: Colors.grey),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onPressed: () => MoreWorkoutSearchResultScreen.show(
              context: context,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'More workouts',
                  style: ButtonTextGrey,
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 40),
      ],
    );
  }

  // Stream Builder of Public Routine data from Cloud Firestore
  Widget _buildRoutineListView(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.centerLeft,
          child: Text(
            'Today\'s recommended routines',
            style: Headline6,
          ),
        ),
        StreamBuilder<List<Routine>>(
          stream: database.routinesInitialStream(),
          builder: (context, snapshot) {
            return ListItemBuilder<Routine>(
              emptyContentTitle: 'Empty....',
              snapshot: snapshot,
              itemBuilder: (context, routine) => CustomListTileStyle2(
                title: routine.routineTitle,
                subtitle: routine.mainMuscleGroup[0],
                imageIndex: routine.imageIndex ?? 0,
                imageUrl: routine.imageUrl,
                onTap: () => RoutineDetailScreen.show(
                  context: context,
                  routine: routine,
                  isRootNavigation: false,
                ),
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: OutlineButton(
            highlightedBorderColor: PrimaryColor,
            borderSide: BorderSide(color: Colors.grey),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onPressed: () => MoreRoutineSearchResultsScreen.show(
              context: context,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'More routines',
                  style: ButtonTextGrey,
                ),
                SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 40),
      ],
    );
  }

  //             itemBuilder: (context, workout) => Dismissible(
  //               key: Key('workoutKeyForSearch-${workout.workoutId}'),
  //               background: Container(color: Colors.red),
  //               direction: DismissDirection.endToStart,
  //               onDismissed: (direction) => _delete(context, workout),
  //               child: SearchListTile(
}
