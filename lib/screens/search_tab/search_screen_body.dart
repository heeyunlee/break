import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/custom_list_tile_style2.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/screens/library_tab/playlist/playlist_detail_screen.dart';
import 'package:workout_player/screens/library_tab/workout/workout_detail_screen.dart';
import 'package:workout_player/screens/search_tab/more_routine_search_results_screen.dart';
import 'package:workout_player/screens/search_tab/more_workout_search_results_screen.dart';

import '../../common_widgets/list_item_builder.dart';
import '../../common_widgets/show_exception_alert_dialog.dart';
import '../../common_widgets/workout_filter_button.dart';
import '../../constants.dart';
import '../../models/workout.dart';
import '../../services/database.dart';

class SearchScreenBody extends StatelessWidget {
  int index;

  // Delete workout from Cloud Firestore
  Future<void> _delete(BuildContext context, Workout workout) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteWorkout(workout);
    } on FirebaseException catch (e) {
      ShowExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

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
                  Text('오늘은', style: Headline5Bold),
                  SizedBox(width: 24),
                  Image.asset(
                    'images/leg.png',
                    height: 64,
                  ),
                  SizedBox(width: 24),
                  Text('뿌시는 날', style: Headline5Bold),
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
                      tagTitle: '가슴',
                      searchCategory: 'mainMuscleGroup',
                    ),
                    SizedBox(width: 16),
                    WorkoutFilterButton(
                      tagTitle: '등',
                      searchCategory: 'mainMuscleGroup',
                    ),
                    SizedBox(width: 16),
                    WorkoutFilterButton(
                      tagTitle: '어깨',
                      searchCategory: 'mainMuscleGroup',
                    ),
                    SizedBox(width: 16),
                    WorkoutFilterButton(
                      tagTitle: '하체',
                      searchCategory: 'mainMuscleGroup',
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    WorkoutFilterButton(
                      tagTitle: '덤벨 운동',
                      searchCategory: 'equipmentRequired',
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
            '오늘의 추천 운동',
            style: Headline6,
          ),
        ),
        StreamBuilder<List<Workout>>(
          stream: database.workoutsInitialStream(),
          builder: (context, snapshot) {
            return ListItemBuilder<Workout>(
              snapshot: snapshot,
              itemBuilder: (context, workout) => CustomListTileStyle2(
                tag: 'workoutTagForSearch-${workout.workoutId}',
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
                  '더 많은 운동 보기',
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
            '오늘의 추천 루틴',
            style: Headline6,
          ),
        ),
        StreamBuilder<List<Routine>>(
          stream: database.routinesInitialStream(),
          builder: (context, snapshot) {
            return ListItemBuilder<Routine>(
              snapshot: snapshot,
              itemBuilder: (context, routine) => CustomListTileStyle2(
                tag: 'routineForSearch${routine.routineId}',
                title: routine.routineTitle,
                subtitle: routine.routineOwnerId,
                imageUrl: routine.imageUrl,
                onTap: () => PlaylistDetailScreen.show(
                  index: index,
                  context: context,
                  routine: routine,
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
                  '더 많은 운동 보기',
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
