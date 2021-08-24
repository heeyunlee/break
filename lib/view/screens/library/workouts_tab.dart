import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/models.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/main_model.dart';

import '../create_new_workout_screen.dart';
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
class WorkoutsTab extends StatelessWidget {
  const WorkoutsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.d('[WorkoutsTab] tab...');

    final database = Provider.of<Database>(context, listen: false);

    return PaginateFirestore(
      isLive: true,
      shrinkWrap: true,
      itemsPerPage: 10,
      query: database.workoutsPaginatedUserQuery(),
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilderType: PaginateBuilderType.listView,
      emptyDisplay: SingleChildScrollView(
        child: _buildHeader(context, isHeader: false),
      ),
      header: SliverToBoxAdapter(
        child: _buildHeader(context, isHeader: true),
      ),
      footer: SliverToBoxAdapter(
        child: const SizedBox(height: kBottomNavigationBarHeight + 48),
      ),
      onError: (error) => EmptyContent(
        message: '${S.current.somethingWentWrong}: $error',
      ),
      itemBuilder: (index, context, documentSnapshot) {
        final workout = documentSnapshot.data() as Workout;

        return LibraryListTile(
          tag: 'savedWorkout${workout.workoutId}',
          title: Formatter.localizedTitle(
            workout.workoutTitle,
            workout.translated,
          ),
          subtitle: S.current.workoutsTabSubtitle(
            Formatter.getJoinedEquipmentsRequired(workout.equipmentRequired),
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
