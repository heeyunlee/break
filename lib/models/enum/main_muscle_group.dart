enum MainMuscleGroup {
  Abs,
  Arms,
  Cardio,
  Chest,
  FullBody,
  Glutes,
  Hamstring,
  Lats,
  Leg,
  LowerBack,
  Quads,
  Shoulder,
  Stretch,
}

extension MainMuscleGroupExtension on MainMuscleGroup {
  String get label {
    switch (this) {
      case MainMuscleGroup.Abs:
        return 'Abs';
      case MainMuscleGroup.Arms:
        return 'Arms';
      case MainMuscleGroup.Cardio:
        return 'Cardio';
      case MainMuscleGroup.Chest:
        return 'Chest';
      case MainMuscleGroup.FullBody:
        return 'Full Body';
      case MainMuscleGroup.Glutes:
        return 'Glutes';
      case MainMuscleGroup.Hamstring:
        return 'Hamstring';
      case MainMuscleGroup.Lats:
        return 'Lats';
      case MainMuscleGroup.Leg:
        return 'Leg';
      case MainMuscleGroup.LowerBack:
        return 'Lower Back';
      case MainMuscleGroup.Quads:
        return 'Quads';
      case MainMuscleGroup.Shoulder:
        return 'Shoulder';
      case MainMuscleGroup.Stretch:
        return 'Stretch';
      default:
        return null;
    }
  }

  List<String> get list {
    List<String> _mainMuscleGroupList = [];
    for (int i = 0; i < MainMuscleGroup.values.length; i++) {
      var value = MainMuscleGroup.values[i].label;
      _mainMuscleGroupList.add(value);
    }
    return _mainMuscleGroupList;
  }

  Map<String, bool> get map {
    List<String> _mainMuscleGroupList = MainMuscleGroup.values[0].list;
    Map<String, bool> _mainMuscleGroupMap = new Map.fromIterable(
      _mainMuscleGroupList,
      key: (element) => element,
      value: (element) => false,
    );
    return _mainMuscleGroupMap;
  }
}
