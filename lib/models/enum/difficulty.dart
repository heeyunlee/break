import 'package:workout_player/generated/l10n.dart';

enum Difficulty {
  beginner,
  intermediate,
  advanced,
}

extension DifficultyExtension on Difficulty {
  String? get translation {
    switch (this) {
      case Difficulty.beginner:
        return S.current.beginner;
      case Difficulty.intermediate:
        return S.current.intermediate;
      case Difficulty.advanced:
        return S.current.advanced;
      default:
        return null;
    }
  }
}

extension DifficultyList on Difficulty {
  List<String> get list {
    final List<String> _difficultyList = [];
    for (var i = 0; i < Difficulty.values.length; i++) {
      final value = Difficulty.values[i].toString();
      _difficultyList.add(value);
    }
    return _difficultyList;
  }
}

extension DifficultyTranslatedList on Difficulty {
  List<String> get translatedList {
    final List<String> _difficultyList = [];
    for (var i = 0; i < Difficulty.values.length; i++) {
      final value = Difficulty.values[i].translation;
      _difficultyList.add(value!);
    }
    return _difficultyList;
  }
}
