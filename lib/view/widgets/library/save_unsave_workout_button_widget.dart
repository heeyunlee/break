import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/view_models/main_model.dart';

import '../widgets.dart';

class SaveUnsaveWorkoutButtonWidget extends StatelessWidget {
  final User user;
  final Database database;
  final AuthBase auth;
  final Workout workout;

  const SaveUnsaveWorkoutButtonWidget({
    Key? key,
    required this.user,
    required this.database,
    required this.auth,
    required this.workout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomStreamBuilder<User?>(
      initialData: user,
      stream: database.userStream(),
      builder: (context, data) {
        // final User user = snapshot.data!;

        if (data!.savedWorkouts != null) {
          if (data.savedWorkouts!.isNotEmpty) {
            if (data.savedWorkouts!.contains(workout.workoutId)) {
              return _unsaveButton(context);
            } else {
              return _saveButton(context);
            }
          } else {
            return _saveButton(context);
          }
        } else {
          return _saveButton(context);
        }
      },
      errorWidget: const Icon(Icons.error, color: Colors.white),
      loadingWidget: const Icon(Icons.sync, color: Colors.white),
    );
  }

  Widget _saveButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.bookmark_border_rounded,
        color: Colors.white,
      ),
      onPressed: () async {
        try {
          final user = {
            'savedWorkouts': FieldValue.arrayUnion([workout.workoutId]),
          };

          await database.updateUser(auth.currentUser!.uid, user);

          getSnackbarWidget(
            S.current.savedWorkoutSnackBarTitle,
            S.current.savedWorkoutSnackBarSubtitle,
          );

          logger.d('added routine to saved routine');
        } on FirebaseException catch (e) {
          logger.e(e);
          await showExceptionAlertDialog(
            context,
            title: S.current.operationFailed,
            exception: e.toString(),
          );
        }
      },
    );
  }

  Widget _unsaveButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.bookmark_rounded,
        color: Colors.white,
      ),
      onPressed: () async {
        final user = {
          'savedWorkouts': FieldValue.arrayRemove([workout.workoutId]),
        };

        await database.updateUser(auth.currentUser!.uid, user);

        getSnackbarWidget(
          S.current.unsavedRoutineSnackBarTitle,
          S.current.unsavedRoutineSnackbar,
        );

        logger.d('Removed routine from saved routine');
      },
    );
  }
}
