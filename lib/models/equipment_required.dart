enum EquipmentRequired {
  Barbell,
  Bench,
  Bodyweight,
  Cable,
  Chains,
  Dumbbell,
  EZBar,
  GymBall,
  Kettlebell,
  Machine,
  Other,
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
      case EquipmentRequired.Chains:
        return 'Chains';
      case EquipmentRequired.Dumbbell:
        return 'Dumbbell';
      case EquipmentRequired.EZBar:
        return 'EZ Bar';
      case EquipmentRequired.GymBall:
        return 'Gym Ball';
      case EquipmentRequired.Kettlebell:
        return 'Kettlebell';
      case EquipmentRequired.Machine:
        return 'Machine';
      case EquipmentRequired.Other:
        return 'Other';
      default:
        return null;
    }
  }

  List<String> get list {
    List<String> equipmentRequiredList = [];
    for (int i = 0; i < EquipmentRequired.values.length; i++) {
      var value = EquipmentRequired.values[i].label;
      equipmentRequiredList.add(value);
    }
    return equipmentRequiredList;
  }

  Map<String, bool> get map {
    List<String> _equipmentRequiredList = EquipmentRequired.values[0].list;
    Map<String, bool> _equipmentRequiredMap = new Map.fromIterable(
      _equipmentRequiredList,
      key: (element) => element,
      value: (element) => false,
    );
    return _equipmentRequiredMap;
  }
}
