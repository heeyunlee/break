import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/view_models/main_model.dart';
import 'package:workout_player/view/widgets/get_snackbar_widget.dart';
import 'package:workout_player/view/widgets/show_exception_alert_dialog.dart';

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

  Future<void> _saveRoutine(BuildContext context) async {
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
  }

  Future<void> _unsaveRoutine(BuildContext context) async {
    try {
      final user = {
        'savedRoutines': FieldValue.arrayRemove([routine.routineId]),
      };

      await database.updateUser(auth.currentUser!.uid, user);

      getSnackbarWidget(
        S.current.unsavedRoutineSnackBarTitle,
        S.current.unsavedRoutineSnackbar,
      );

      logger.i('Removed routine from saved routine');
    } on FirebaseException catch (e) {
      logger.e(e);
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user.savedRoutines != null) {
      if (user.savedRoutines!.isNotEmpty) {
        if (user.savedRoutines!.contains(routine.routineId)) {
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
  }

  Widget _saveButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.bookmark_border_rounded,
        color: Colors.white,
      ),
      onPressed: () => _saveRoutine(context),
    );
  }

  Widget _unsaveButton(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.bookmark_rounded,
        color: Colors.white,
      ),
      onPressed: () => _unsaveRoutine(context),
    );
  }
}
