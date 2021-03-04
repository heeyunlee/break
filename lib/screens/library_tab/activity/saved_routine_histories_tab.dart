import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/empty_content_widget.dart';
import 'package:workout_player/common_widgets/list_item_builder.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/screens/search_tab/start_workout_shortcut_screen.dart';
import 'package:workout_player/services/database.dart';

import 'routine_history/daily_summary_card.dart';
import 'routine_history/daily_summary_detail_screen.dart';

class SavedRoutineHistoriesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 12),
          StreamBuilder<List<RoutineHistory>>(
            stream: database.routineHistoriesStream(),
            builder: (context, snapshot) {
              print(snapshot.error);

              return ListItemBuilder<RoutineHistory>(
                snapshot: snapshot,
                isEmptyContentWidget: true,
                emptyContentWidget: EmptyContentWidget(
                  imageUrl: 'assets/images/routine_history_empty_bg.png',
                  bodyText:
                      'Use your own routines to Workout, and save your progress!',
                  onPressed: () => StartWorkoutShortcutScreen.show(context),
                ),
                itemBuilder: (context, routineHistory) => DailySummaryCard(
                  date: routineHistory.workoutStartTime,
                  workoutTitle: routineHistory.routineTitle,
                  totalWeights: routineHistory.totalWeights,
                  caloriesBurnt: routineHistory.totalCalories,
                  totalDuration: routineHistory.totalDuration,
                  earnedBadges: routineHistory.earnedBadges,
                  unitOfMass: routineHistory.unitOfMass,
                  onTap: () {
                    debugPrint('Activity Card was tapped');

                    HapticFeedback.mediumImpact();
                    DailySummaryDetailScreen.show(
                      context: context,
                      routineHistory: routineHistory,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
