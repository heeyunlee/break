import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/common_widgets/custom_list_tile_3.dart';
import 'package:workout_player/common_widgets/empty_content.dart';
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
    await HapticFeedback.mediumImpact();
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
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(isEqualTo ?? arrayContains, style: Subtitle1),
                flexibleSpace: const AppbarBlurBG(),
                backgroundColor: Colors.transparent,
                bottom: const TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Grey400,
                  indicatorColor: PrimaryColor,
                  tabs: [
                    Tab(text: 'Workouts'),
                    Tab(text: 'Routines'),
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

    return PaginateFirestore(
      shrinkWrap: true,
      itemsPerPage: 10,
      query: database.workoutsSearchQuery(searchCategory, arrayContains),
      itemBuilderType: PaginateBuilderType.listView,
      emptyDisplay: const EmptyContent(
        message: 'Nothing...',
      ),
      header: const SizedBox(height: 8),
      footer: const SizedBox(height: 8),
      onError: (error) => EmptyContent(
        message: 'Something went wrong: $error',
      ),
      physics: const BouncingScrollPhysics(),
      itemBuilder: (index, context, documentSnapshot) {
        final documentId = documentSnapshot.id;
        final data = documentSnapshot.data();
        final workout = Workout.fromMap(data, documentId);

        return CustomListTile3(
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
        );
      },
      isLive: true,
    );
  }

  Widget _buildRoutinesBody(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return PaginateFirestore(
      shrinkWrap: true,
      itemsPerPage: 10,
      query: database.routinesSearchQuery(searchCategory, arrayContains),
      itemBuilderType: PaginateBuilderType.listView,
      emptyDisplay: const EmptyContent(
        message: 'Nothing...',
      ),
      header: const SizedBox(height: 8),
      footer: const SizedBox(height: 8),
      onError: (error) => EmptyContent(
        message: 'Something went wrong: $error',
      ),
      physics: const BouncingScrollPhysics(),
      itemBuilder: (index, context, documentSnapshot) {
        final documentId = documentSnapshot.id;
        final data = documentSnapshot.data();
        final routine = Routine.fromMap(data, documentId);

        final duration = Duration(seconds: routine?.duration ?? 0).inMinutes;
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
      isLive: true,
    );
  }
}
