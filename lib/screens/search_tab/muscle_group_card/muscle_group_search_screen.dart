import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/common_widgets/custom_list_tile_3.dart';
import 'package:workout_player/common_widgets/list_item_builder.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/screens/library_tab/routine/routine_detail_screen.dart';
import 'package:workout_player/screens/library_tab/workout/workout_detail_screen.dart';
import 'package:workout_player/services/database.dart';

import '../../../constants.dart';

class MuscleGroupSearchScreen extends StatelessWidget {
  const MuscleGroupSearchScreen({
    this.isEqualTo,
    this.arrayContains,
    this.searchCategory,
  });

  final String isEqualTo;
  final String arrayContains;
  final String searchCategory;

  static void show({
    BuildContext context,
    String isEqualTo,
    String arrayContains,
    String searchCategory,
  }) async {
    HapticFeedback.mediumImpact();
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => MuscleGroupSearchScreen(
          isEqualTo: isEqualTo,
          arrayContains: arrayContains,
          searchCategory: searchCategory,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: BackgroundColor,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                floating: true,
                pinned: true,
                snap: false,
                centerTitle: true,
                title: Text(isEqualTo ?? arrayContains, style: Subtitle1),
                flexibleSpace: const AppbarBlurBG(),
                backgroundColor: Colors.transparent,
                bottom: const TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Grey400,
                  indicatorColor: PrimaryColor,
                  tabs: [
                    const Tab(text: 'Workouts'),
                    const Tab(text: 'Routines'),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: <Widget>[
              _buildWorkoutsBody(context),
              _buildRoutinesBody(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutsBody(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: StreamBuilder<List<Workout>>(
        stream: database.workoutsSearchStream(
          isEqualTo: isEqualTo,
          arrayContains: arrayContains,
          searchCategory: searchCategory,
        ),
        builder: (context, snapshot) {
          return ListItemBuilder<Workout>(
            emptyContentTitle: 'Empty...',
            snapshot: snapshot,
            itemBuilder: (context, workout) => CustomListTile3(
              imageUrl: workout.imageUrl,
              isLeadingDuration: false,
              title: workout.workoutTitle,
              leadingText: '${workout.equipmentRequired[0]}',
              subtitle: 'Created by ${workout.workoutOwnerUserName}',
              tag: 'MoreScreen-${workout.workoutId}',
              onTap: () => WorkoutDetailScreen.show(
                context,
                workout: workout,
                isRootNavigation: false,
                tag: 'MoreScreen-${workout.workoutId}',
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRoutinesBody(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: StreamBuilder<List<Routine>>(
        stream: database.routinesSearchStream(
          isEqualTo: isEqualTo,
          arrayContains: arrayContains,
          searchCategory: searchCategory,
        ),
        builder: (context, snapshot) {
          return ListItemBuilder<Routine>(
            emptyContentTitle: 'Empty...',
            snapshot: snapshot,
            itemBuilder: (context, routine) {
              final duration =
                  Duration(seconds: routine?.duration ?? 0).inMinutes;
              return CustomListTile3(
                isLeadingDuration: true,
                imageUrl: routine.imageUrl,
                leadingText: '$duration',
                title: routine.routineTitle,
                subtitle: routine.routineOwnerUserName,
                tag: 'MoreScreen-${routine.routineId}',
                onTap: () => RoutineDetailScreen.show(
                  context,
                  routine: routine,
                  isRootNavigation: false,
                  tag: 'MoreScreen-${routine.routineId}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
