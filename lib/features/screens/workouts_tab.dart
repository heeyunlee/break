import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/models.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/features/widgets/widgets.dart';

import 'create_new_workout_screen.dart';
import 'saved_workouts_screen.dart';
import 'workout_detail_screen.dart';

/// Creates a tab that displays a list of workouts, either saved or created by
/// the user.
///
/// ## Roadmap
///
/// ### Refactoring
/// * TODO: Create custom Firebase pagination widget
///
/// ### Enhancement
///
class WorkoutsTab extends ConsumerWidget {
  const WorkoutsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomStreamBuilder<List<Workout>>(
      stream: ref.read(databaseProvider).userWorkoutsStream(),
      emptyWidget: SingleChildScrollView(
        child: _buildHeader(context, isHeader: false),
      ),
      builder: (context, data) {
        return SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context, isHeader: true),
              CustomListViewBuilder<Workout>(
                items: data,
                itemBuilder: (context, workout, i) {
                  return LibraryListTile(
                    tag: 'savedWorkout${workout.workoutId}',
                    title: Formatter.localizedTitle(
                      workout.workoutTitle,
                      workout.translated,
                    ),
                    subtitle: S.current.workoutsTabSubtitle(
                      Formatter.getJoinedEquipmentsRequired(
                          workout.equipmentRequired),
                    ),
                    imageUrl: workout.imageUrl,
                    onTap: () => WorkoutDetailScreen.show(
                      context,
                      workout: workout,
                      workoutId: workout.workoutId,
                      tag: 'savedWorkout${workout.workoutId}',
                    ),
                  );
                },
              ),
              const SizedBox(height: kBottomNavigationBarHeight + 48),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, {required bool isHeader}) {
    return Column(
      children: [
        const SizedBox(height: 16),
        CreateListTile(
          title: S.current.createNewWorkout,
          onTap: () => CreateNewWorkoutScreen.show(context),
        ),
        SavedListTile<Workout>(
          onTap: (user) => SavedWorkoutsScreen.show(context, user: user),
          title: S.current.savedWorkouts,
        ),
        if (!isHeader)
          EmptyContent(
            message: S.current.savedWorkoutsEmptyText,
          ),
      ],
    );
  }
}
