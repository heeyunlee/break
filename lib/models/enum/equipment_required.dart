import 'package:workout_player/generated/l10n.dart';

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
}

extension EquipmentRequiredListExtension on EquipmentRequired {
  List<String> get list {
    // ignore: omit_local_variable_types
    final List<String> equipmentRequiredList = [];
    for (var i = 0; i < EquipmentRequired.values.length; i++) {
      final value = EquipmentRequired.values[i].label;
      equipmentRequiredList.add(value);
    }
    return equipmentRequiredList;
  }
}

extension EquipmentRequiredMapExtension on EquipmentRequired {
  Map<String, bool> get map {
    final _equipmentRequiredList = EquipmentRequired.values[0].list;
    final _equipmentRequiredMap = {
      for (var element in _equipmentRequiredList) element.toString(): false
    };
    return _equipmentRequiredMap;
  }
}

extension EquipmentRequiredTranslatedExtension on EquipmentRequired {
  String get translation {
    switch (this) {
      case EquipmentRequired.barbell:
        return S.current.barbell;
      case EquipmentRequired.bench:
        return S.current.bench;
      case EquipmentRequired.bodyweight:
        return S.current.bodyweight;
      case EquipmentRequired.cable:
        return S.current.cable;
      case EquipmentRequired.chains:
        return S.current.chains;
      case EquipmentRequired.dumbbell:
        return S.current.dumbbell;
      case EquipmentRequired.eZBar:
        return S.current.eZBar;
      case EquipmentRequired.gymBall:
        return S.current.gymBall;
      case EquipmentRequired.kettlebell:
        return S.current.kettlebell;
      case EquipmentRequired.machine:
        return S.current.machine;
      case EquipmentRequired.other:
        return S.current.other;
      default:
        return null;
    }
  }
}

extension EquipmentRequiredTranslatedListExtension on EquipmentRequired {
  List<String> get translatedList {
    // ignore: omit_local_variable_types
    final List<String> equipmentRequiredList = [];
    for (var i = 0; i < EquipmentRequired.values.length; i++) {
      final value = EquipmentRequired.values[i].translation;
      equipmentRequiredList.add(value);
    }
    return equipmentRequiredList;
  }
}
