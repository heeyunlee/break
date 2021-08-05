import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/classes/enum/equipment_required.dart';
import 'package:workout_player/classes/routine.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/widgets/get_snackbar_widget.dart';
import 'package:workout_player/widgets/show_alert_dialog.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';

final editRoutineEquipmentRequiredModelProvider = ChangeNotifierProvider(
  (ref) => EditRoutineEquipmentRequiredModel(),
);

class EditRoutineEquipmentRequiredModel with ChangeNotifier {
  List<EquipmentRequired?> _selectedEquipmentRequired = [];

  List<EquipmentRequired?> get selectedEquipmentRequired =>
      _selectedEquipmentRequired;

  void init(Routine routine) {
    List<EquipmentRequired?>? equipmentsFromString = routine.equipmentRequired
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
    required Database database,
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
