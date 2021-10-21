import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/view/widgets/basic.dart';
import 'package:workout_player/view/widgets/dialogs.dart';

import 'main_model.dart';

final changeDisplayNameScreenModelProvider = ChangeNotifierProvider.autoDispose
    .family<ChangeDisplayNameScreenModel, User>(
  (ref, user) => ChangeDisplayNameScreenModel(user: user),
);

class ChangeDisplayNameScreenModel with ChangeNotifier {
  ChangeDisplayNameScreenModel({required this.user});

  final User user;

  late TextEditingController _textController;
  late FocusNode _focusNode;

  TextEditingController get textController => _textController;
  FocusNode get focusNode => _focusNode;

  void init() {
    _textController = TextEditingController(text: user.displayName);
    _focusNode = FocusNode();
  }

  // void onChanged(String value) {}

  void onFieldSubmitted(BuildContext context, String value) {
    updateDisplayName(context);
  }

  // Submit data to Firestore
  Future<bool?> updateDisplayName(BuildContext context) async {
    final database = provider.Provider.of<Database>(context, listen: false);
    final auth = provider.Provider.of<AuthBase>(context, listen: false);

    if (_textController.text.isNotEmpty) {
      try {
        final user = {
          'displayName': _textController.text,
        };
        await database.updateUser(auth.currentUser!.uid, user);

        // // Updating username in Routine History
        // final List<Map<String, dynamic>> routineHistories = [];
        // final historiesDoc = await database.routineHistoriesStream().first;
        // if (historiesDoc.isNotEmpty) {
        //   historiesDoc.map((history) {
        //     final updatedElement = {
        //       'routineHistoryId': history.routineHistoryId,
        //       'username': _textController.text,
        //     };

        //     routineHistories.add(updatedElement);
        //   });

        //   await database.batchUpdateRoutineHistories(routineHistories);
        // }

        // TODO: Create Cloud Function that update routineOwner's name
        // // Updating username in Routine
        // List<Map<String, dynamic>> routines = [];
        // final routinesDoc = await widget.database.userRoutinesStream().first;
        // print('length is ${routinesDoc.length}');
        // if (routinesDoc.isNotEmpty) {
        //   print('routines is not empty and length is ${routinesDoc.length}');

        //   routinesDoc.forEach((element) {
        //     final routine = {
        //       'routineId': element.routineId,
        //       'routineOwnerUserName': _displayName,
        //     };
        //     routines.add(routine);
        //   });
        //   await widget.database.batchUpdateRoutines(routines);
        // }

        // TODO: Create Cloud Function that update workoutOwner's name
        // // Updating username in Workout
        // List<Map<String, dynamic>> workouts = [];
        // final workoutsDoc = await widget.database.userWorkoutsStream().first;
        // if (workoutsDoc.isNotEmpty) {
        //   workoutsDoc.forEach((element) {
        //     final workout = {
        //       'workoutId': element.workoutId,
        //       'workoutOwnerUserName': _displayName,
        //     };
        //     workouts.add(workout);
        //   });
        //   await widget.database.batchUpdateWorkouts(workouts);
        // }

        getSnackbarWidget(
          S.current.updateDisplayNameSnackbarTitle,
          S.current.updateDisplayNameSnackbar,
        );
      } on FirebaseException catch (e) {
        logger.e(e);
        await showExceptionAlertDialog(
          context,
          title: S.current.operationFailed,
          exception: e.toString(),
        );
      }
    } else {
      return showAlertDialog(
        context,
        title: S.current.displayNameEmptyTitle,
        content: S.current.displayNameEmptyContent,
        defaultActionText: S.current.ok,
      );
    }
  }

  static final formKey = GlobalKey<FormState>();
}
