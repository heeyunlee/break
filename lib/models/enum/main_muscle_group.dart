import 'package:workout_player/generated/l10n.dart';

enum MainMuscleGroup {
  abs,
  arms,
  cardio,
  chest,
  fullBody,
  glutes,
  hamstring,
  lats,
  lowerBody,
  lowerBack,
  quads,
  shoulder,
  stretch,
}

extension MainMuscleGroupList on MainMuscleGroup {
  List<String> get list {
    // ignore: omit_local_variable_types
    final List<String> _mainMuscleGroupList = [];
    for (var i = 0; i < MainMuscleGroup.values.length; i++) {
      final value = MainMuscleGroup.values[i].label;
      _mainMuscleGroupList.add(value);
    }
    return _mainMuscleGroupList;
  }
}

extension MainMuscleGroupTranslatedList on MainMuscleGroup {
  List<String> get translatedList {
    // ignore: omit_local_variable_types
    final List<String> _mainMuscleGroupList = [];
    for (var i = 0; i < MainMuscleGroup.values.length; i++) {
      final value = MainMuscleGroup.values[i].translation;
      _mainMuscleGroupList.add(value);
    }
    return _mainMuscleGroupList;
  }
}

extension MainMuscleGroupMap on MainMuscleGroup {
  Map<String, bool> get map {
    final _mainMuscleGroupList = MainMuscleGroup.values[0].list;
    final _mainMuscleGroupMap = {
      for (var element in _mainMuscleGroupList) element.toString(): false
    };
    return _mainMuscleGroupMap;
  }
}

extension MainMuscleGroupLabelExtension on MainMuscleGroup {
  String get label {
    switch (this) {
      case MainMuscleGroup.abs:
        return 'Abs';
      case MainMuscleGroup.arms:
        return 'Arms';
      case MainMuscleGroup.cardio:
        return 'Cardio';
      case MainMuscleGroup.chest:
        return 'Chest';
      case MainMuscleGroup.fullBody:
        return 'Full Body';
      case MainMuscleGroup.glutes:
        return 'Glutes';
      case MainMuscleGroup.hamstring:
        return 'Hamstring';
      case MainMuscleGroup.lats:
        return 'Lats';
      case MainMuscleGroup.lowerBody:
        return 'Lower Body';
      case MainMuscleGroup.lowerBack:
        return 'Lower Back';
      case MainMuscleGroup.quads:
        return 'Quads';
      case MainMuscleGroup.shoulder:
        return 'Shoulder';
      case MainMuscleGroup.stretch:
        return 'Stretch';
      default:
        return null;
    }
  }
}

extension MainMuscleGroupTranslationExtension on MainMuscleGroup {
  String get translation {
    switch (this) {
      case MainMuscleGroup.abs:
        return S.current.abs;
      case MainMuscleGroup.arms:
        return S.current.arms;
      case MainMuscleGroup.cardio:
        return S.current.cardio;
      case MainMuscleGroup.chest:
        return S.current.chest;
      case MainMuscleGroup.fullBody:
        return S.current.fullBody;
      case MainMuscleGroup.glutes:
        return S.current.glutes;
      case MainMuscleGroup.hamstring:
        return S.current.hamstring;
      case MainMuscleGroup.lats:
        return S.current.lats;
      case MainMuscleGroup.lowerBody:
        return S.current.lowerBody;
      case MainMuscleGroup.lowerBack:
        return S.current.lowerBack;
      case MainMuscleGroup.quads:
        return S.current.quads;
      case MainMuscleGroup.shoulder:
        return S.current.shoulder;
      case MainMuscleGroup.stretch:
        return S.current.stretch;
      default:
        return null;
    }
  }
}
