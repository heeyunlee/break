import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/classes/enum/equipment_required.dart';
import 'package:workout_player/classes/enum/main_muscle_group.dart';

import '../generated/l10n.dart';
import '../classes/enum/difficulty.dart';
import '../classes/enum/unit_of_mass.dart';

class Formatter {
  static String? difficulty(int? difficulty) {
    final difficultyNotNull = difficulty ?? 2;

    return Difficulty.values[difficultyNotNull].translation;
  }

  static String date(Timestamp date) {
    final dateInDateTime = date.toDate();

    return DateFormat.MMMMEEEEd().format(dateInDateTime);
  }

  static String dateShort(Timestamp date) {
    final dateInDateTime = date.toDate();

    return DateFormat.MMMd().format(dateInDateTime);
  }

  static String yMdjm(Timestamp timestamp) {
    final dateInDateTime = timestamp.toDate();

    return DateFormat.yMd().add_jm().format(dateInDateTime);
  }

  static String yMdjmInDateTime(DateTime date) {
    return DateFormat.yMd().add_jm().format(date);
  }

  static int durationInMin(int seconds) {
    final secondsNotNegative = seconds < 0 ? 0 : seconds;
    final minutes = Duration(seconds: secondsNotNegative).inMinutes;
    return minutes;
  }

  static String hours(double hours) {
    final hoursNotNegative = hours < 0.0 ? 0.0 : hours;
    final formatter = NumberFormat.decimalPattern();
    final formatted = formatter.format(hoursNotNegative);
    return formatted;
  }

  static String timeInHM(Timestamp timestamp) {
    final time = timestamp.toDate();
    final formattedTime = DateFormat.jm().format(time);

    return formattedTime;
  }

  /// Returns a formatted number with first decimal point from either `num` or
  /// `string` data type
  static String numWithDecimal([num? value, String? valueInString]) {
    if (value != null) {
      final formatter = NumberFormat(',###,##0.0');

      return formatter.format(value);
    } else if (valueInString != null) {
      final valueToNum = num.parse(valueInString);
      final formatter = NumberFormat(',###,##0.0');

      return formatter.format(valueToNum);
    } else {
      return '-';
    }
  }

  /// Returns a formatted number without decimal point from either `num` or
  /// `string` data type
  static String numWithoutDecimal([num? value, String? valueInString]) {
    if (value != null) {
      final formatter = NumberFormat(',###,##0');

      return formatter.format(value);
    } else if (valueInString != null) {
      final valueToNum = num.parse(valueInString);
      final formatter = NumberFormat(',###,##0');

      return formatter.format(valueToNum);
    } else {
      return '-';
    }
  }

  /// Returns a formatted number with or without first decimal point from either
  /// `num` or `string` data type
  static String numWithOrWithoutDecimal([num? value, String? valueInString]) {
    if (value != null) {
      final formatter = NumberFormat(',###,###.#');

      return formatter.format(value);
    } else if (valueInString != null) {
      final valueToNum = num.parse(valueInString);
      final formatter = NumberFormat(',###,###.#');

      return formatter.format(valueToNum);
    } else {
      return '-';
    }
  }

  /// Returns a string of pertange point with decimal point and % sign
  static String percentage(num? value) {
    if (value != null) {
      final formatter = NumberFormat('##.0');
      final formattedNum = formatter.format(value);

      return '$formattedNum %';
    } else {
      return '';
    }
  }

  /// Returns a string, which is a [UnitOfMass]'s kilogram level unit, either
  /// 'kg' or 'lbs', from `int` or `UnitOfMass`
  static String unitOfMass([int? unitOfMassInt, UnitOfMass? unitOfMassEnum]) {
    if (unitOfMassEnum != null) {
      return unitOfMassEnum.label!;
    } else if (unitOfMassInt != null) {
      return UnitOfMass.values[unitOfMassInt].label!;
    } else {
      return 'unit';
    }
  }

  /// Returns a string, which is a [UnitOfMass]'s gram level unit, either
  /// 'g' or 'lbs', from `int` or `UnitOfMass`
  static String unitOfMassGram([
    int? unitOfMassInt,
    UnitOfMass? unitOfMassEnum,
  ]) {
    if (unitOfMassEnum != null) {
      return unitOfMassEnum.gram!;
    } else if (unitOfMassInt != null) {
      return UnitOfMass.values[unitOfMassInt].gram!;
    } else {
      return 'unit';
    }
  }

  /// Returns a string, which is a translation of first [MainMuscleGroup]
  /// from either `List<dynamic>` or `List<MainMuscleGroup?>`
  static String getFirstMainMuscleGroup([
    List<dynamic>? musclesAsString,
    List<MainMuscleGroup?>? musclesAsEnum,
  ]) {
    if (musclesAsEnum != null) {
      return musclesAsEnum[0]!.translation!;
    } else if (musclesAsString != null) {
      return MainMuscleGroup.values
          .firstWhere((e) => e.toString() == musclesAsString[0])
          .translation!;
    } else {
      return S.current.mainMuscleGroup;
    }
  }

  /// Returns a joined string, which is a combination of each [MainMuscleGroup]'s
  /// translation from either `List<dynamic>` or `List<MainMuscleGroup?>`
  static String getJoinedMainMuscleGroups([
    List<dynamic>? musclesAsString,
    List<MainMuscleGroup?>? musclesAsEnum,
  ]) {
    if (musclesAsEnum != null) {
      final list = musclesAsEnum.map((muscle) => muscle!.translation!).toList();

      return list.join(', ');
    } else if (musclesAsString != null) {
      final list = musclesAsString
          .map((muscle) => MainMuscleGroup.values
              .firstWhere((e) => e.toString() == muscle)
              .translation!)
          .toList();

      return list.join(', ');
    } else {
      return S.current.mainMuscleGroup;
    }
  }

  /// Returns a list of strings, which is a list of translation of [MainMuscleGroup]
  /// from either `List<dynamic>` or `List<MainMuscleGroup?>`
  static List<String> getListOfMainMuscleGroup([
    List<dynamic>? musclesAsString,
    List<MainMuscleGroup?>? musclesAsEnum,
  ]) {
    if (musclesAsEnum != null) {
      return musclesAsEnum.map((muscle) => muscle!.translation!).toList();
    } else if (musclesAsString != null) {
      return musclesAsString
          .map((muscle) => MainMuscleGroup.values
              .firstWhere((e) => e.toString() == muscle)
              .translation!)
          .toList();
    } else {
      return [];
    }
  }

  /// Returns a joined string, which is a combination of each [EquipmentRequired]'s
  /// translation from either `List<dynamic>` or `List<EquipmentRequired?>`
  static String getJoinedEquipmentsRequired([
    List<dynamic>? equipmentsAsString,
    List<EquipmentRequired?>? equipmentsAsEnum,
  ]) {
    if (equipmentsAsEnum != null) {
      final list =
          equipmentsAsEnum.map((equipment) => equipment!.translation!).toList();

      return list.join(', ');
    } else if (equipmentsAsString != null) {
      final list = equipmentsAsString
          .map((equipment) => EquipmentRequired.values
              .firstWhere((e) => e.toString() == equipment)
              .translation!)
          .toList();

      return list.join(', ');
    } else {
      return S.current.equipmentRequired;
    }
  }

  /// Returns a list of strings, which is a list of translation of [EquipmentRequired]
  /// from either `List<dynamic>` or `List<EquipmentRequired?>`
  static List<String> getListOfEquipments([
    List<dynamic>? equipmentsAsString,
    List<EquipmentRequired?>? equipmentsAsEnum,
  ]) {
    if (equipmentsAsEnum != null) {
      return equipmentsAsEnum
          .map((equipment) => equipment!.translation!)
          .toList();
    } else if (equipmentsAsString != null) {
      return equipmentsAsString
          .map((equipment) => EquipmentRequired.values
              .firstWhere((e) => e.toString() == equipment)
              .translation!)
          .toList();
    } else {
      return [];
    }
  }
}
