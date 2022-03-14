import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/services/database.dart';

import '../widgets.dart';

class SaveUnsaveWorkoutButtonWidget extends ConsumerWidget {
  const SaveUnsaveWorkoutButtonWidget({
    Key? key,
    required this.workout,
  }) : super(key: key);

  final Workout workout;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ref.watch(databaseProvider);

    return CustomStreamBuilder<User?>(
      stream: database.userStream(),
      builder: (context, data) {
        // final User user = snapshot.data!;

        if (data!.savedWorkouts != null) {
          if (data.savedWorkouts!.isNotEmpty) {
            if (data.savedWorkouts!.contains(workout.workoutId)) {
              return _unsaveButton(context, database);
            } else {
              return _saveButton(context, database);
            }
          } else {
            return _saveButton(context, database);
          }
        } else {
          return _saveButton(context, database);
        }
      },
      errorWidget: const Icon(Icons.error, color: Colors.white),
      loadingWidget: const Icon(Icons.sync, color: Colors.white),
    );
  }

  Widget _saveButton(BuildContext context, Database database) {
    return IconButton(
      icon: const Icon(
        Icons.bookmark_border_rounded,
        color: Colors.white,
      ),
      onPressed: () async {
        try {
          final user = {
            'savedWorkouts': FieldValue.arrayUnion([workout.workoutId]),
          };

          await database.updateUser(database.uid!, user);

          getSnackbarWidget(
            S.current.savedWorkoutSnackBarTitle,
            S.current.savedWorkoutSnackBarSubtitle,
          );
        } on FirebaseException catch (e) {
          await showExceptionAlertDialog(
            context,
            title: S.current.operationFailed,
            exception: e.toString(),
          );
        }
      },
    );
  }

  Widget _unsaveButton(BuildContext context, Database database) {
    return IconButton(
      icon: const Icon(
        Icons.bookmark_rounded,
        color: Colors.white,
      ),
      onPressed: () async {
        final user = {
          'savedWorkouts': FieldValue.arrayRemove([workout.workoutId]),
        };

        await database.updateUser(database.uid!, user);

        getSnackbarWidget(
          S.current.unsavedRoutineSnackBarTitle,
          S.current.unsavedRoutineSnackbar,
        );
      },
    );
  }
}
