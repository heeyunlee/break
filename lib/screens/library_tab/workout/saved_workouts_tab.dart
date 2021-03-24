import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/empty_content.dart';
import 'package:workout_player/generated/l10n.dart';

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
      physics: const BouncingScrollPhysics(),
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

        return CustomListTile64(
          tag: 'workout${workout.workoutId}',
          title: workout.workoutTitle,
          subtitle: workout.mainMuscleGroup[0],
          imageUrl: workout.imageUrl,
          onTap: () => WorkoutDetailScreen.show(
            context,
            workout: workout,
            isRootNavigation: false,
            tag: 'workout${workout.workoutId}',
          ),
        );
      },
      isLive: true,
    );
  }
}
