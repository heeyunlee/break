import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/models/enum/equipment_required.dart';
import 'package:workout_player/models/enum/location.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/workout_history.dart';
import 'package:workout_player/models/workout_set.dart';
import 'package:collection/collection.dart';

import '../generated/l10n.dart';
import '../models/enum/difficulty.dart';
import '../models/enum/unit_of_mass.dart';

class Formatter {
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

  static String durationInString(Timestamp startTime, Timestamp endTime) {
    final format = DateFormat.jm();
    final formattedStartTime = format.format(startTime.toDate());
    final formattedEndTime = format.format(endTime.toDate());

    return '$formattedStartTime ~ $formattedEndTime';
  }

  /// Returns a translated [Difficulty] from either int or enum
  static String difficulty([int? difficulty, Difficulty? difficultyEnum]) {
    if (difficulty != null) {
      return Difficulty.values[difficulty].translation!;
    } else if (difficultyEnum != null) {
      return difficultyEnum.translation!;
    } else {
      return S.current.difficulty;
    }
  }

  /// Returns a translated [Location] from either int or enum
  static String location([String? location, Location? locationEnum]) {
    if (location != null) {
      return Location.values
              .firstWhereOrNull(
                (e) => e.toString() == location,
              )
              ?.translation ??
          S.current.location;
    } else if (locationEnum != null) {
      return locationEnum.translation!;
    } else {
      return S.current.location;
    }
  }

  /// Returns a duration in minutes and localized `minutes` as string from
  /// seconds
  static String durationInMin(int? seconds) {
    if (seconds != null) {
      final secondsNotNegative = seconds < 0 ? 0 : seconds;
      final minutes = Duration(seconds: secondsNotNegative).inMinutes;

      return '$minutes ${S.current.minutes}';
    } else {
      return '- ${S.current.minutes}';
    }
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
      return '0';
    }
  }

  /// Returns a formatted number with or without first decimal point from either
  /// `num` or `string` data type
  static String? numWithOrWithoutDecimalOrNull(num? value) {
    if (value != null) {
      final formatter = NumberFormat(',###,###.#');

      return formatter.format(value);
    } else {
      return null;
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

  static String localizedTitle([String? string, Map<String, dynamic>? map]) {
    final locale = Intl.getCurrentLocale();

    if (map != null && (locale == 'ko' || locale == 'en')) {
      return map[locale].toString();
    } else {
      return string ?? 'Title is null';
    }
  }

  /// Returns a string, which is a [UnitOfMass]'s kilogram level unit, either
  /// 'kg' or 'lbs', from `int` or `UnitOfMass`
  static String unitOfMass([int? unitOfMassInt, UnitOfMass? unitOfMassEnum]) {
    if (unitOfMassEnum != null) {
      return unitOfMassEnum.label;
    } else if (unitOfMassInt != null) {
      return UnitOfMass.values[unitOfMassInt].label;
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
      return unitOfMassEnum.gram;
    } else if (unitOfMassInt != null) {
      return UnitOfMass.values[unitOfMassInt].gram;
    } else {
      return 'g';
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

  /// Returns a list of [MainMuscleGroup] from `List<dynamic>`
  static List<MainMuscleGroup> getListOfMainMuscleGroupFromStrings(
    List<dynamic>? musclesAsString,
  ) {
    if (musclesAsString != null) {
      return musclesAsString
          .map((muscle) =>
              MainMuscleGroup.values.firstWhere((e) => e.toString() == muscle))
          .toList();
    } else {
      return <MainMuscleGroup>[];
    }
  }

  /// Returns a string, which is a translation of first [EquipmentRequired]
  /// from either `List<dynamic>` or `List<EquipmentRequired?>`
  static String getFirstEquipmentRequired([
    List<dynamic>? equipmentRequiredString,
    List<EquipmentRequired?>? equipmentRequiredEnum,
  ]) {
    if (equipmentRequiredEnum != null) {
      return equipmentRequiredEnum[0]!.translation!;
    } else if (equipmentRequiredString != null) {
      return EquipmentRequired.values
          .firstWhere((e) => e.toString() == equipmentRequiredString[0])
          .translation!;
    } else {
      return S.current.equipmentRequired;
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
      final lowerCased = list.join(', ');

      return lowerCased;
    } else if (equipmentsAsString != null) {
      final list = equipmentsAsString
          .map((equipment) => EquipmentRequired.values
              .firstWhere((e) => e.toString() == equipment)
              .translation!)
          .toList();

      final lowerCased = list.join(', ');

      return lowerCased;
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

  /// Returns a list of [EquipmentRequired] from `List<dynamic>`
  static List<EquipmentRequired> getListOfEquipmentsFromStrings(
    List<dynamic>? equipments,
  ) {
    if (equipments != null) {
      return equipments
          .map((equipment) => EquipmentRequired.values
              .firstWhere((e) => e.toString() == equipment))
          .toList();
    } else {
      return <EquipmentRequired>[];
    }
  }

  /// Returns a formatted weights and a unit as a string from a [RoutineHistory]
  static String routineHistoryWeights(RoutineHistory? routineHistory) {
    if (routineHistory != null) {
      final formatter = NumberFormat(',###,###.#');
      final formattedWeight = formatter.format(routineHistory.totalWeights);
      final unit = unitOfMass(
        routineHistory.unitOfMass,
        routineHistory.unitOfMassEnum,
      );
      return '$formattedWeight $unit';
    } else {
      return '-,--- kg';
    }
  }

  /// Returns a formatted weights and a unit as a string from a [Routine],
  ///  [RoutineWorkout], and [WorkoutSet].
  ///
  /// Returns `bodyweight` when [RoutineWorkout] is `isBodyWeightWorkout`
  static String workoutSetWeights(
    Routine routine,
    RoutineWorkout routineWorkout,
    WorkoutSet workoutSet,
  ) {
    if (routineWorkout.isBodyWeightWorkout) {
      return S.current.bodyweight;
    } else {
      final formatter = NumberFormat(',###,###.#');
      final formattedWeight = formatter.format(workoutSet.weights);
      final unit = unitOfMass(
        routine.initialUnitOfMass,
        routine.unitOfMassEnum,
      );

      return '$formattedWeight $unit';
    }
  }

  /// Returns a formatted weights and a unit as a string from a [RoutineHistory],
  ///  [WorkoutHistory], and [WorkoutSet].
  ///
  /// Returns `bodyweight` when [WorkoutHistory] is `isBodyWeightWorkout`
  static String workoutSetWeightsFromHistory(
    RoutineHistory routineHistory,
    WorkoutHistory workoutHistory,
    WorkoutSet workoutSet,
  ) {
    if (workoutHistory.isBodyWeightWorkout) {
      return S.current.bodyweight;
    } else {
      final formatter = NumberFormat(',###,###.#');
      final formattedWeight = formatter.format(workoutSet.weights);
      final unit = unitOfMass(
        routineHistory.unitOfMass,
        routineHistory.unitOfMassEnum,
      );

      return '$formattedWeight $unit';
    }
  }

  /// Returns a formatted weights and a unit as a string from a [Routine]
  static String routineTotalWeights(Routine routine) {
    final formatter = NumberFormat(',###,###.#');
    final formattedWeight = formatter.format(routine.totalWeights);
    final unit = unitOfMass(
      routine.initialUnitOfMass,
      routine.unitOfMassEnum,
    );

    return '$formattedWeight $unit';
  }

  /// Returns a formatted weights and a unit as a string from a [RoutineHistory]
  ///  and [WorkoutHistory], but returns `bodyweight` when the [WorkoutHistory] is
  /// `isBodyWeightWorkout`
  static String workoutHistoryTotalWeights(
    RoutineHistory routineHistory,
    WorkoutHistory workoutHistory,
  ) {
    final bool isBodyWorkout = workoutHistory.isBodyWeightWorkout;
    final bool isZero = workoutHistory.totalWeights == 0;
    final unit = unitOfMass(
      routineHistory.unitOfMass,
      routineHistory.unitOfMassEnum,
    );
    final formatter = NumberFormat(',###,###.#');
    final formattedWeight = formatter.format(workoutHistory.totalWeights);

    if (isBodyWorkout && isZero) {
      return S.current.bodyweight;
    } else if (isBodyWorkout && !isZero) {
      return '${S.current.bodyweight} + $formattedWeight $unit';
    } else {
      return '$formattedWeight $unit';
    }
  }

  static String formattedWorkoutSetTitle(WorkoutSet? workoutSet) {
    if (workoutSet != null) {
      if (workoutSet.isRest) {
        return '${S.current.rest} ${workoutSet.restIndex}';
      } else {
        return '${S.current.set} ${workoutSet.setIndex}';
      }
    } else {
      return S.current.noWorkoutSetTitle;
    }
  }

  static String workoutSetWeightAndReps(
    Routine? routine,
    RoutineWorkout? routineWorkout,
    WorkoutSet? workoutSet,
  ) {
    if (workoutSet != null && routineWorkout != null) {
      if (workoutSet.isRest) {
        final restTime = workoutSet.restTime;

        return '${S.current.rest}: $restTime ${S.current.seconds}';
      } else {
        final reps = '${workoutSet.reps} ${S.current.x}';

        if (routineWorkout.isBodyWeightWorkout) {
          return '${S.current.bodyweight}   •   $reps';
        } else {
          final unit = Formatter.unitOfMass(
            routine!.initialUnitOfMass,
            routine.unitOfMassEnum,
          );
          final formattedWeight = numWithOrWithoutDecimal(workoutSet.weights);

          return '$formattedWeight $unit   •   $reps';
        }
      }
    } else {
      return S.current.noWorkoutSetTitle;
    }
  }

  static String durationInMMSS(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  static Duration stringToDuration(String string) {
    final split = string.split(':');
    final hours = int.parse(split[0]);
    final minutes = int.parse(split[1]);

    final secondSplit = split[2].split('.');
    final seconds = int.parse(secondSplit[0]);
    final milliseconds = int.parse(secondSplit[1].substring(0, 3));
    final miscroseconds = int.parse(secondSplit[1].substring(3, 6));

    final parsedDuration = Duration(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      milliseconds: milliseconds,
      microseconds: miscroseconds,
    );

    return parsedDuration;
  }

  static String formattedKcal(num? value) {
    if (value != null) {
      return '${numWithOrWithoutDecimal(value)} Kcal';
    } else {
      return '--.- Kcal';
    }
  }
}
