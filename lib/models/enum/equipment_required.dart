enum EquipmentRequired {
  barbell,
  bench,
  bodyweight,
  cable,
  chains,
  dumbbell,
  eZBar,
  gymBall,
  kettlebell,
  machine,
  other,
}

extension EquipmentRequiredExtension on EquipmentRequired {
  String get label {
    switch (this) {
      case EquipmentRequired.barbell:
        return 'Barbell';
      case EquipmentRequired.bench:
        return 'Bench';
      case EquipmentRequired.bodyweight:
        return 'Bodyweight';
      case EquipmentRequired.cable:
        return 'Cable';
      case EquipmentRequired.chains:
        return 'Chains';
      case EquipmentRequired.dumbbell:
        return 'Dumbbell';
      case EquipmentRequired.eZBar:
        return 'EZ Bar';
      case EquipmentRequired.gymBall:
        return 'Gym Ball';
      case EquipmentRequired.kettlebell:
        return 'Kettlebell';
      case EquipmentRequired.machine:
        return 'Machine';
      case EquipmentRequired.other:
        return 'Other';
      default:
        return null;
    }
  }

  List<String> get list {
    // ignore: omit_local_variable_types
    final List<String> equipmentRequiredList = [];
    for (var i = 0; i < EquipmentRequired.values.length; i++) {
      final value = EquipmentRequired.values[i].label;
      equipmentRequiredList.add(value);
    }
    return equipmentRequiredList;
  }

  Map<String, bool> get map {
    final _equipmentRequiredList = EquipmentRequired.values[0].list;
    final _equipmentRequiredMap = {
      for (var element in _equipmentRequiredList) element.toString(): false
    };
    return _equipmentRequiredMap;
  }
}
