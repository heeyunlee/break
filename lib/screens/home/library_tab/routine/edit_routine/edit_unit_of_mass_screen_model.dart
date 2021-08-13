import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/classes/enum/unit_of_mass.dart';
import 'package:workout_player/classes/routine.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/widgets/get_snackbar_widget.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';

final editUnitOfMassModelProvider = ChangeNotifierProvider(
  (ref) => EditUnitOfMassModel(),
);

class EditUnitOfMassModel with ChangeNotifier {
  FirestoreDatabase? database;

  EditUnitOfMassModel({
    this.database,
  }) {
    final container = ProviderContainer();
    final auth = container.read(authServiceProvider);
    database = container.read(databaseProvider(auth.currentUser?.uid));
  }

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

      await database!.updateRoutine(routine, updatedRoutine);

      getSnackbarWidget(
        S.current.unitOfMass,
        S.current.updateUnitOfMassMessage(S.current.routine),
      );
    } on FirebaseException catch (e) {
      logger.e(e);
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }
  }
}
