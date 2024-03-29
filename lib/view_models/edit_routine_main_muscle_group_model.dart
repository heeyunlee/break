import 'dart:math';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/view/widgets/widgets.dart';

class EditRoutineMainMuscleGroupModel with ChangeNotifier {
  EditRoutineMainMuscleGroupModel({required this.database});

  final Database database;

  List<MainMuscleGroup?> _selectedMainMuscleGroupEnum = [];

  List<MainMuscleGroup?> get selectedMainMuscleGroupEnum =>
      _selectedMainMuscleGroupEnum;

  void init(Routine routine) {
    final List<MainMuscleGroup?>? musclesFromString = routine.mainMuscleGroup
        ?.map((string) =>
            MainMuscleGroup.values.firstWhere((e) => e.toString() == string))
        .toList();

    _selectedMainMuscleGroupEnum =
        routine.mainMuscleGroupEnum ?? musclesFromString ?? [];
  }

  bool selected(MainMuscleGroup muscle) {
    return _selectedMainMuscleGroupEnum.contains(muscle);
  }

  void addOrRemove(bool? value, MainMuscleGroup muscle) {
    if (value!) {
      _selectedMainMuscleGroupEnum.add(muscle);
    } else {
      _selectedMainMuscleGroupEnum.remove(muscle);
    }

    notifyListeners();
  }

  Future<void> submitAndPop(
    BuildContext context, {
    required Routine routine,
  }) async {
    if (_selectedMainMuscleGroupEnum.isNotEmpty) {
      try {
        // Get Image Url
        final bucket = FirebaseStorage.instance.ref().child(
              'workout-pictures/800by800',
            );
        final imageIndex = Random().nextInt(2);
        final enumToString = EnumToString.convertToString(
          _selectedMainMuscleGroupEnum[0],
        );
        final ref = bucket.child('$enumToString$imageIndex.jpeg');
        final imageUrl = await ref.getDownloadURL();

        final enumToStrings = EnumToString.toList(_selectedMainMuscleGroupEnum);

        final updatedRoutine = {
          'imageUrl': imageUrl,
          'mainMuscleGroupEnum': enumToStrings,
        };
        await database.updateRoutine(routine, updatedRoutine);

        Navigator.of(context).pop();

        getSnackbarWidget(
          S.current.updateMainMuscleGroupTitle,
          S.current.updateMainMuscleGroupMessage(S.current.routine),
        );
      } on Exception catch (e) {
        await showExceptionAlertDialog(
          context,
          title: S.current.operationFailed,
          exception: e.toString(),
        );
      }
    } else {
      await showAlertDialog(
        context,
        title: S.current.mainMuscleGroupAlertTitle,
        content: S.current.mainMuscleGroupAlertContent,
        defaultActionText: S.current.ok,
      );
    }
  }
}
