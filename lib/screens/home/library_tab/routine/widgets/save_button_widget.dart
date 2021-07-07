import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/widgets/custom_stream_builder_widget.dart';
import 'package:workout_player/widgets/get_snackbar_widget.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';

class SaveButtonWidget extends StatelessWidget {
  final User user;
  final Database database;
  final AuthBase auth;
  final Routine routine;

  const SaveButtonWidget({
    Key? key,
    required this.user,
    required this.database,
    required this.auth,
    required this.routine,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomStreamBuilderWidget<User?>(
      initialData: user,
      stream: database.userStream(),
      hasDataWidget: (context, data) {
        // final User user = snapshot.data!;

        if (data!.savedRoutines != null) {
          if (data.savedRoutines!.isNotEmpty) {
            if (data.savedRoutines!.contains(routine.routineId)) {
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
            'savedRoutines': FieldValue.arrayUnion([routine.routineId]),
          };

          await database.updateUser(auth.currentUser!.uid, user);

          getSnackbarWidget(
            S.current.savedRoutineSnackBarTitle,
            S.current.savedRoutineSnackbar,
          );

          logger.i('added routine to saved routine');
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
          'savedRoutines': FieldValue.arrayRemove([routine.routineId]),
        };

        await database.updateUser(auth.currentUser!.uid, user);

        getSnackbarWidget(
          S.current.unsavedRoutineSnackBarTitle,
          S.current.unsavedRoutineSnackbar,
        );

        logger.i('Removed routine from saved routine');
      },
    );
  }
}
