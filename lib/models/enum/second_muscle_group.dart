enum SecondMuscleGroup {
  Abductors,
  Abs,
  Adductors,
  Biceps,
  Calves,
  Chest,
  Forearms,
  Glutes,
  Hamstring,
  HipFlexors,
  ITBand,
  Lats,
  LowerBack,
  UpperBack,
  Neck,
  Obliques,
  Quads,
  Shoulders,
  Traps,
  Triceps,
}

extension SecondMuscleGroupExtension on SecondMuscleGroup {
  String get label {
    switch (this) {
      case SecondMuscleGroup.Abductors:
        return 'Abductors';
      case SecondMuscleGroup.Abs:
        return 'Abs';
      case SecondMuscleGroup.Adductors:
        return 'Adductors';
      case SecondMuscleGroup.Biceps:
        return 'Biceps';
      case SecondMuscleGroup.Calves:
        return 'Calves';
      case SecondMuscleGroup.Chest:
        return 'Chest';
      case SecondMuscleGroup.Forearms:
        return 'Forearms';
      case SecondMuscleGroup.Glutes:
        return 'Glutes';
      case SecondMuscleGroup.Hamstring:
        return 'Hamstring';
      case SecondMuscleGroup.HipFlexors:
        return 'Hip Flexors';
      case SecondMuscleGroup.ITBand:
        return 'IT Band';
      case SecondMuscleGroup.Lats:
        return 'Lats';
      case SecondMuscleGroup.LowerBack:
        return 'Lower Back';
      case SecondMuscleGroup.UpperBack:
        return 'Upper Back';
      case SecondMuscleGroup.Neck:
        return 'Neck';
      case SecondMuscleGroup.Obliques:
        return 'Obliques';
      case SecondMuscleGroup.Quads:
        return 'Quads';
      case SecondMuscleGroup.Shoulders:
        return 'Shoulders';
      case SecondMuscleGroup.Traps:
        return 'Traps';
      case SecondMuscleGroup.Triceps:
        return 'Triceps';
      default:
        return null;
    }
  }
}
