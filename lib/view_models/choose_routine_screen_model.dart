import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/services/database.dart';

class ChooseRoutineScreenModel with ChangeNotifier {
  ChooseRoutineScreenModel({required this.database});

  final Database database;

  String _selectedChip = 'Saved';
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

  Stream<List<Routine>>? stream() {
    if (_selectedChip == 'Saved') {
      return null;
    } else if (_selectedChip == 'All') {
      return database.routinesStream();
    } else {
      return database.routinesSearchStream(
        isEqualTo: false,
        arrayContainsVariableName: 'mainMuscleGroup',
        arrayContainsValue: _selectedChip,
      );
    }
  }
}
