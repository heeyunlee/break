import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/empty_content.dart';
import 'package:workout_player/common_widgets/empty_content_widget.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/screens/search_tab/start_workout_shortcut_screen.dart';
import 'package:workout_player/services/database.dart';

import 'routine_history/daily_summary_card.dart';
import 'routine_history/daily_summary_detail_screen.dart';

class SavedRoutineHistoriesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return PaginateFirestore(
      shrinkWrap: true,
      itemsPerPage: 10,
      query: database.routineHistoriesPaginatedUserQuery(),
      itemBuilderType: PaginateBuilderType.listView,
      emptyDisplay: EmptyContentWidget(
        imageUrl: 'assets/images/routine_history_empty_bg.png',
        bodyText: 'Use your own routines to Workout, and save your progress!',
        onPressed: () => StartWorkoutShortcutScreen.show(context),
      ),
      header: SizedBox(height: 16),
      footer: const SizedBox(height: 16),
      onError: (error) => EmptyContent(
        message: 'Something went wrong: $error',
      ),
      physics: const BouncingScrollPhysics(),
      itemBuilder: (index, context, documentSnapshot) {
        final documentId = documentSnapshot.id;
        final data = documentSnapshot.data();
        final routineHistory = RoutineHistory.fromMap(data, documentId);

        return DailySummaryCard(
          date: routineHistory.workoutStartTime,
          workoutTitle: routineHistory.routineTitle,
          totalWeights: routineHistory.totalWeights,
          caloriesBurnt: routineHistory.totalCalories,
          totalDuration: routineHistory.totalDuration,
          earnedBadges: routineHistory.earnedBadges,
          unitOfMass: routineHistory.unitOfMass,
          onTap: () {
            debugPrint('Activity Card was tapped');

            DailySummaryDetailScreen.show(
              context: context,
              routineHistory: routineHistory,
            );
          },
        );
      },
      isLive: true,
    );
  }
}
