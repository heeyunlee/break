import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/unit_of_mass.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/view/widgets/widgets.dart';

class EditUnitOfMassModel with ChangeNotifier {
  EditUnitOfMassModel({required this.database});

  Database database;

  int? _unitOfMassInt = 0;
  UnitOfMass? _unitOfMassEnum = UnitOfMass.kilograms;

  int? get unitOfMassInt => _unitOfMassInt;
  UnitOfMass? get unitOfMassEnum => _unitOfMassEnum;

  void init(Routine routine) {
    _unitOfMassInt = routine.initialUnitOfMass;
    _unitOfMassEnum = routine.unitOfMassEnum;
  }

  bool selected(UnitOfMass unit) {
    if (_unitOfMassInt != null) {
      return unit == UnitOfMass.values[_unitOfMassInt!];
    } else {
      return unit == _unitOfMassEnum;
    }
  }

  void onChanged(
    BuildContext context,
    bool? value,
    UnitOfMass unit,
    Routine routine,
  ) {
    if (value!) {
      _unitOfMassInt = null;
      _unitOfMassEnum = unit;

      _updateUnitOfMass(context, routine);
    }

    notifyListeners();
  }

  // Submit data to Firestore
  Future<void> _updateUnitOfMass(BuildContext context, Routine routine) async {
    try {
      final updatedRoutine = {
        'initialUnitOfMass': null,
        'unitOfMassEnum': EnumToString.convertToString(_unitOfMassEnum),
      };

      await database.updateRoutine(routine, updatedRoutine);

      getSnackbarWidget(
        S.current.unitOfMass,
        S.current.updateUnitOfMassMessage(S.current.routine),
      );
    } on FirebaseException catch (e) {
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }
  }
}
