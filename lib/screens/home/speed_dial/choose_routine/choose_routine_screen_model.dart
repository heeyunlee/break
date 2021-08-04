import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/classes/enum/main_muscle_group.dart';
import 'package:workout_player/classes/routine.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/services/database.dart';

final chooseRoutineScreenModelProvider = ChangeNotifierProvider(
  (ref) => ChooseRoutineScreenModel(),
);

class ChooseRoutineScreenModel with ChangeNotifier {
  String _selectedChip = 'All';
  String _selectedChipTranslation = S.current.saved;

  String get selectedChip => _selectedChip;
  String get selectedChipTranslation => _selectedChipTranslation;

  void onSelectChoiceChip(bool selected, String string) {
    HapticFeedback.mediumImpact();

    _selectedChip = string;
    _selectedChipTranslation = (string == 'Saved')
        ? S.current.saved
        : (string == 'All')
            ? S.current.all
            : MainMuscleGroup.values
                .firstWhere((e) => e.toString() == _selectedChip)
                .translation!;

    notifyListeners();
  }

  Stream<List<Routine>> stream(Database database) {
    if (_selectedChip == 'Saved') {
      return database.routinesStream();
    } else if (_selectedChip == 'All') {
      return database.routinesStream();
    } else {
      return database.routinesSearchStream(
        arrayContainsVariableName: 'mainMuscleGroup',
        arrayContainsValue: _selectedChip,
      );
    }
  }
}