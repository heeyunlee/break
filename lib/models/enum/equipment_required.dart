import 'package:workout_player/generated/l10n.dart';

enum EquipmentRequired {
  band,
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
  plate,

  other,
}

extension EquipmentRequiredTranslatedExtension on EquipmentRequired {
  String? get translation {
    switch (this) {
      case EquipmentRequired.band:
        return S.current.band;
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
      case EquipmentRequired.plate:
        return S.current.plate;
      case EquipmentRequired.other:
        return S.current.other;
      default:
        return null;
    }
  }
}

extension EquipmentRequiredListExtension on EquipmentRequired {
  List<String> get list {
    final List<String> equipmentRequiredList = [];
    for (var i = 0; i < EquipmentRequired.values.length; i++) {
      final value = EquipmentRequired.values[i].toString();
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

extension EquipmentRequiredTranslatedListExtension on EquipmentRequired {
  List<String> get translatedList {
    final List<String> equipmentRequiredList = [];
    for (var i = 0; i < EquipmentRequired.values.length; i++) {
      final value = EquipmentRequired.values[i].translation;
      equipmentRequiredList.add(value!);
    }
    return equipmentRequiredList;
  }
}
