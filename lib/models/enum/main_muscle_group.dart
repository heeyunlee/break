import 'package:workout_player/generated/l10n.dart';
import 'package:json_annotation/json_annotation.dart';

enum MainMuscleGroup {
  @JsonValue('abs')
  abs,

  @JsonValue('arms')
  arms,

  @JsonValue('back')
  back,

  @JsonValue('cardio')
  cardio,

  @JsonValue('chest')
  chest,

  @JsonValue('fullBody')
  fullBody,

  @JsonValue('glutes')
  glutes,

  @JsonValue('hamstring')
  hamstring,

  @JsonValue('lats')
  lats,

  @JsonValue('lowerBody')
  lowerBody,

  @JsonValue('lowerBack')
  lowerBack,

  @JsonValue('quads')
  quads,

  @JsonValue('shoulder')
  shoulder,

  @JsonValue('stretch')
  stretch,

  @JsonValue('traps')
  traps,
}

extension MainMuscleGroupTranslationExtension on MainMuscleGroup {
  String? get translation {
    switch (this) {
      case MainMuscleGroup.abs:
        return S.current.abs;
      case MainMuscleGroup.arms:
        return S.current.arms;
      case MainMuscleGroup.back:
        return S.current.back;
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
      case MainMuscleGroup.traps:
        return S.current.traps;
      default:
        return null;
    }
  }
}

extension MainMuscleGroupBroadGroup on MainMuscleGroup {
  String? get broadGroup {
    switch (this) {
      case MainMuscleGroup.abs:
        return S.current.abs;
      case MainMuscleGroup.arms:
        return S.current.arms;
      case MainMuscleGroup.back:
        return S.current.back;
      case MainMuscleGroup.cardio:
        return S.current.cardio;
      case MainMuscleGroup.chest:
        return S.current.chest;
      case MainMuscleGroup.fullBody:
        return S.current.fullBody;
      case MainMuscleGroup.glutes:
        return S.current.lowerBody;
      case MainMuscleGroup.hamstring:
        return S.current.lowerBody;
      case MainMuscleGroup.lats:
        return S.current.back;
      case MainMuscleGroup.lowerBody:
        return S.current.lowerBody;
      case MainMuscleGroup.lowerBack:
        return S.current.back;
      case MainMuscleGroup.quads:
        return S.current.lowerBody;
      case MainMuscleGroup.shoulder:
        return S.current.shoulder;
      case MainMuscleGroup.stretch:
        return S.current.stretch;
      case MainMuscleGroup.traps:
        return S.current.back;
      default:
        return null;
    }
  }
}

extension MainMuscleGroupBareList on MainMuscleGroup {
  List<String> get list {
    final List<String> mainMuscleGroupList = [];
    for (var i = 0; i < MainMuscleGroup.values.length; i++) {
      final value = MainMuscleGroup.values[i].toString();
      mainMuscleGroupList.add(value);
    }
    return mainMuscleGroupList;
  }
}

extension MainMuscleGroupTranslatedList on MainMuscleGroup {
  List<String> get translatedList {
    final List<String> mainMuscleGroupList = [];
    for (var i = 0; i < MainMuscleGroup.values.length; i++) {
      final value = MainMuscleGroup.values[i].translation;
      mainMuscleGroupList.add(value!);
    }
    return mainMuscleGroupList;
  }
}

extension MainMuscleGroupBareMap on MainMuscleGroup {
  Map<String, bool> get map {
    final mainMuscleGroupList = MainMuscleGroup.values[0].list;
    final mainMuscleGroupMap = {
      for (var element in mainMuscleGroupList) element.toString(): false
    };
    return mainMuscleGroupMap;
  }
}
