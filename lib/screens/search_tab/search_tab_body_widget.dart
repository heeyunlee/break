import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/horz_list_item_builder.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/screens/library_tab/routine/routine_detail_screen.dart';
import 'package:workout_player/screens/library_tab/workout/workout_detail_screen.dart';
import 'package:workout_player/services/database.dart';

import '../../constants.dart';
import '../../format.dart';
import 'long_height_card_widget.dart';
import 'muscle_group_card/muscle_group_card_widget.dart';
import 'muscle_group_card/muscle_group_search_screen.dart';

class SearchTabBodyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final database = Provider.of<Database>(context, listen: false);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 48),
          _GridViewChildWidget(),
          const SizedBox(height: 48),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            child: Text('New Chest Routines', style: Headline6w900),
          ),
          StreamBuilder<List<Routine>>(
            stream: database.routinesSearchStream3(
              limit: 5,
              searchCategory: 'mainMuscleGroup',
              arrayContains: 'Chest',
            ),
            builder: (context, snapshot) {
              return Container(
                height: size.width,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: HoriListItemBuilder<Routine>(
                    isEmptyContentWidget: false,
                    snapshot: snapshot,
                    emptyContentTitle: 'Empty...',
                    itemBuilder: (context, routine) {
                      final duration = Format.durationInMin(routine.duration);

                      return LongHeightCardWidget(
                        tag: 'horizListTag1-${routine.routineId}',
                        imageUrl: routine.imageUrl,
                        title: routine.routineTitle,
                        subtitle: routine.routineOwnerUserName,
                        thirdLineSubtitle: '$duration min',
                        onTap: () => RoutineDetailScreen.show(
                          context,
                          isRootNavigation: false,
                          routine: routine,
                          tag: 'horizListTag1-${routine.routineId}',
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 48),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            child: Text(
              'Lower Back Workouts for you',
              style: Headline6w900,
            ),
          ),
          StreamBuilder<List<Workout>>(
            stream: database.workoutsSearchStream(
              limit: 5,
              searchCategory: 'mainMuscleGroup',
              arrayContains: 'Lower Back',
            ),
            builder: (context, snapshot) {
              return Container(
                height: size.width,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: HoriListItemBuilder<Workout>(
                    isEmptyContentWidget: false,
                    snapshot: snapshot,
                    emptyContentTitle: 'Empty...',
                    itemBuilder: (context, workout) {
                      final difficulty = Format.difficulty(workout.difficulty);

                      return LongHeightCardWidget(
                        tag: 'workoutTag1-${workout.workoutId}',
                        imageUrl: workout.imageUrl,
                        title: workout.workoutTitle,
                        subtitle: workout.equipmentRequired[0],
                        thirdLineSubtitle: difficulty,
                        onTap: () => WorkoutDetailScreen.show(
                          context,
                          isRootNavigation: false,
                          workout: workout,
                          tag: 'workoutTag1-${workout.workoutId}',
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 48),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            child: Text('Routines for your QUAD', style: Headline6w900),
          ),
          StreamBuilder<List<Routine>>(
            stream: database.routinesSearchStream(
              limit: 5,
              searchCategory: 'mainMuscleGroup',
              arrayContains: 'Leg',
            ),
            builder: (context, snapshot) {
              return Container(
                height: size.width,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: HoriListItemBuilder<Routine>(
                    isEmptyContentWidget: false,
                    snapshot: snapshot,
                    emptyContentTitle: 'Empty...',
                    itemBuilder: (context, routine) {
                      final duration = Format.durationInMin(routine.duration);

                      return LongHeightCardWidget(
                        tag: 'routineTag2-${routine.routineId}',
                        imageUrl: routine.imageUrl,
                        title: routine.routineTitle,
                        subtitle: '$duration min',
                        onTap: () => RoutineDetailScreen.show(
                          context,
                          isRootNavigation: false,
                          routine: routine,
                          tag: 'routineTag2-${routine.routineId}',
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 48),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
            child: Text(
              'Get Shoulders like Captain America',
              style: Headline6w900,
            ),
          ),
          StreamBuilder<List<Routine>>(
            stream: database.routinesSearchStream(
              limit: 5,
              searchCategory: 'mainMuscleGroup',
              arrayContains: 'Shoulder',
            ),
            builder: (context, snapshot) {
              return Container(
                height: size.width,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: HoriListItemBuilder<Routine>(
                    isEmptyContentWidget: false,
                    snapshot: snapshot,
                    emptyContentTitle: 'Empty...',
                    itemBuilder: (context, routine) {
                      final duration = Format.durationInMin(routine.duration);

                      return LongHeightCardWidget(
                        tag: 'routineTag2-${routine.routineId}',
                        imageUrl: routine.imageUrl,
                        title: routine.routineTitle,
                        subtitle: routine.equipmentRequired[0],
                        thirdLineSubtitle: '$duration minutes',
                        onTap: () => RoutineDetailScreen.show(
                          context,
                          isRootNavigation: false,
                          routine: routine,
                          tag: 'routineTag2-${routine.routineId}',
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _GridViewChildWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _mainMuscleGroup = MainMuscleGroup.values[0].list;

    var gridTiles = <Widget>[];

    for (var i = 0; i < _mainMuscleGroup.length; i++) {
      Widget card = MuscleGroupCardWidget(
        text: _mainMuscleGroup[i],
        onTap: () => MuscleGroupSearchScreen.show(
          context: context,
          arrayContains: _mainMuscleGroup[i],
          searchCategory: 'mainMuscleGroup',
        ),
      );

      gridTiles.add(card);
    }

    final size = MediaQuery.of(context).size;

    final itemWidth = size.width / 2;
    final itemHeight = size.width / 4;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        childAspectRatio: (itemWidth / itemHeight),
        crossAxisCount: 3,
        padding: const EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: gridTiles,
      ),
    );
  }
}
