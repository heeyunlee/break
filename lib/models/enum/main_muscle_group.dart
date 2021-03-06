enum MainMuscleGroup {
  abs,
  arms,
  cardio,
  chest,
  fullBody,
  glutes,
  hamstring,
  lats,
  leg,
  lowerBack,
  quads,
  shoulder,
  stretch,
}

extension MainMuscleGroupExtension on MainMuscleGroup {
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
      case MainMuscleGroup.leg:
        return 'Leg';
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

  List<String> get list {
    // ignore: omit_local_variable_types
    final List<String> _mainMuscleGroupList = [];
    for (var i = 0; i < MainMuscleGroup.values.length; i++) {
      final value = MainMuscleGroup.values[i].label;
      _mainMuscleGroupList.add(value);
    }
    return _mainMuscleGroupList;
  }

  Map<String, bool> get map {
    final _mainMuscleGroupList = MainMuscleGroup.values[0].list;
    final _mainMuscleGroupMap = {
      for (var element in _mainMuscleGroupList) element.toString(): false
    };
    return _mainMuscleGroupMap;
  }
}
