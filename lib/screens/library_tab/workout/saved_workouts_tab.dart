import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/empty_content.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';

import '../../../common_widgets/custom_list_tile_64.dart';
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
    var query = database.workoutsPaginatedUserQuery();

    return PaginateFirestore(
      shrinkWrap: true,
      query: query,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilderType: PaginateBuilderType.listView,
      emptyDisplay: EmptyContent(
        message: S.current.savedWorkoutsEmptyText,
        button: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            primary: PrimaryColor,
          ),
          onPressed: () => CreateNewWorkoutScreen.show(context),
          child: Text(S.current.savedWorkoutEmptyButtonText, style: ButtonText),
        ),
      ),
      itemsPerPage: 10,
      header: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          if (query.snapshots() != null) CreateNewWorkoutWidget(),
        ],
      ),
      footer: const SizedBox(height: 16),
      onError: (error) => EmptyContent(
        message: '${S.current.somethingWentWrong}: $error',
      ),
      itemBuilder: (index, context, documentSnapshot) {
        final documentId = documentSnapshot.id;
        final data = documentSnapshot.data();
        final workout = Workout.fromMap(data, documentId);

        final locale = Intl.getCurrentLocale();

        final title = (locale == 'ko' || locale == 'en')
            ? workout.translated[locale]
            : workout.workoutTitle;

        final subtitle = MainMuscleGroup.values
            .firstWhere((e) => e.toString() == workout.mainMuscleGroup[0])
            .translation;

        return CustomListTile64(
          tag: 'savedWorkout${workout.workoutId}',
          title: title,
          subtitle: subtitle,
          imageUrl: workout.imageUrl,
          onTap: () => WorkoutDetailScreen.show(
            context,
            workout: workout,
            isRootNavigation: false,
            tag: 'savedWorkout${workout.workoutId}',
          ),
        );
      },
      isLive: true,
    );
  }
}
