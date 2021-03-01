enum MainMuscleGroup {
  Abs,
  Arms,
  Back,
  Cardio,
  Chest,
  FullBody,
  Leg,
  Shoulder,
}

extension MainMuscleGroupExtension on MainMuscleGroup {
  String get label {
    switch (this) {
      case MainMuscleGroup.Abs:
        return 'Abs';
      case MainMuscleGroup.Arms:
        return 'Arms';
      case MainMuscleGroup.Back:
        return 'Back';
      case MainMuscleGroup.Cardio:
        return 'Cardio';
      case MainMuscleGroup.Chest:
        return 'Chest';
      case MainMuscleGroup.FullBody:
        return 'Full Body';
      case MainMuscleGroup.Leg:
        return 'Leg';
      case MainMuscleGroup.Shoulder:
        return 'Shoulder';
      default:
        return null;
    }
  }
}

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

enum EquipmentRequired {
  Barbell,
  Bench,
  Bodyweight,
  Cable,
  Dumbbell,
  EZBar,
  GymBall,
  Machine,
}

extension EquipmentRequiredExtension on EquipmentRequired {
  String get label {
    switch (this) {
      case EquipmentRequired.Barbell:
        return 'Barbell';
      case EquipmentRequired.Bench:
        return 'Bench';
      case EquipmentRequired.Bodyweight:
        return 'Bodyweight';
      case EquipmentRequired.Cable:
        return 'Cable';
      case EquipmentRequired.Dumbbell:
        return 'Dumbbell';
      case EquipmentRequired.EZBar:
        return 'EZ Bar';
      case EquipmentRequired.GymBall:
        return 'Gym Ball';
      case EquipmentRequired.Machine:
        return 'Machine';
      default:
        return null;
    }
  }
}

enum Difficulty {
  SuperEasy,
  Beginner,
  Intermediate,
  PrettyHard,
  SuperHard,
}

extension DifficultyExtension on Difficulty {
  String get label {
    switch (this) {
      case Difficulty.SuperEasy:
        return 'Super Easy';
      case Difficulty.Beginner:
        return 'Beginner';
      case Difficulty.Intermediate:
        return 'Intermediate';
      case Difficulty.PrettyHard:
        return 'Pretty Hard';
      case Difficulty.SuperHard:
        return 'Super Hard';
      default:
        return null;
    }
  }
}

enum UnitOfMass { kg, lbs }

extension UnitOfMassExtension on UnitOfMass {
  String get label {
    switch (this) {
      case UnitOfMass.kg:
        return 'kg';
      case UnitOfMass.lbs:
        return 'lbs';
      default:
        return null;
    }
  }

  double get multiplyFactor {
    switch (this) {
      case UnitOfMass.kg:
        return 1;
      case UnitOfMass.lbs:
        return 2.205;
      default:
        return null;
    }
  }

  double get dividingFactor {
    switch (this) {
      case UnitOfMass.kg:
        return 2.205;
      case UnitOfMass.lbs:
        return 1;
      default:
        return null;
    }
  }
}
