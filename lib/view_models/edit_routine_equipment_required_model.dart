import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/equipment_required.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/view/widgets/widgets.dart';

import 'main_model.dart';

class EditRoutineEquipmentRequiredModel with ChangeNotifier {
  EditRoutineEquipmentRequiredModel({required this.database});

  final Database database;

  List<EquipmentRequired?> _selectedEquipmentRequired = [];

  List<EquipmentRequired?> get selectedEquipmentRequired =>
      _selectedEquipmentRequired;

  void init(Routine routine) {
    final List<EquipmentRequired?>? equipmentsFromString = routine
        .equipmentRequired
        ?.map((string) =>
            EquipmentRequired.values.firstWhere((e) => e.toString() == string))
        .toList();

    _selectedEquipmentRequired =
        routine.equipmentRequiredEnum ?? equipmentsFromString ?? [];
  }

  bool selected(EquipmentRequired equipment) {
    return _selectedEquipmentRequired.contains(equipment);
  }

  void addOrRemove(bool? value, EquipmentRequired equipment) {
    if (value!) {
      _selectedEquipmentRequired.add(equipment);
    } else {
      _selectedEquipmentRequired.remove(equipment);
    }

    notifyListeners();
  }

  Future<void> submitAndPop(
    BuildContext context, {
    required Routine routine,
  }) async {
    if (_selectedEquipmentRequired.isNotEmpty) {
      try {
        final enumToStrings = EnumToString.toList(_selectedEquipmentRequired);

        final updatedRoutine = {
          'equipmentRequiredEnum': enumToStrings,
        };
        await database.updateRoutine(routine, updatedRoutine);

        Navigator.of(context).pop();

        getSnackbarWidget(
          S.current.updateEquipmentRequiredTitle,
          S.current.updateEquipmentRequiredMessage(S.current.routine),
        );
      } on Exception catch (e) {
        logger.e(e);
        await showExceptionAlertDialog(
          context,
          title: S.current.operationFailed,
          exception: e.toString(),
        );
      }
    } else {
      await showAlertDialog(
        context,
        title: S.current.equipmentRequiredAlertTitle,
        content: S.current.equipmentRequiredAlertContent,
        defaultActionText: S.current.ok,
      );
    }
  }
}
