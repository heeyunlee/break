import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/models/main_muscle_group.dart';

class Format {
  static String weights(double weights) {
    final weightsNotNull = weights ?? 0;
    final formatter = NumberFormat('#,###,###');

    return formatter.format(weightsNotNull);
  }

  static String unitOfMass(int unitOfMass) {
    final unitOfMassNotNull = unitOfMass ?? 1;

    return UnitOfMass.values[unitOfMassNotNull].label;
  }

  static String difficulty(int difficulty) {
    final difficultyNotNull = difficulty ?? 2;

    return Difficulty.values[difficultyNotNull].label;
  }

  static String date(Timestamp date) {
    if (date != null) {
      final dateInDateTime = date.toDate();

      return DateFormat.MMMMEEEEd().format(dateInDateTime);
    }
    return 'null...';
  }

  static String dateShort(Timestamp date) {
    if (date != null) {
      final dateInDateTime = date.toDate();

      return DateFormat.MMMd().format(dateInDateTime);
    }
    return 'null...';
  }

  static String durationInMin(int seconds) {
    final secondsNotNegative = seconds < 0 ? 0 : seconds;
    final minutes = Duration(seconds: secondsNotNegative).inMinutes;
    return '$minutes min';
  }

  static String hours(double hours) {
    final hoursNotNegative = hours < 0.0 ? 0.0 : hours;
    final formatter = NumberFormat.decimalPattern();
    final formatted = formatter.format(hoursNotNegative);
    return '${formatted}h';
  }

  static String currency(double pay) {
    if (pay != 0.0) {
      final formatter = NumberFormat.simpleCurrency(decimalDigits: 0);
      return formatter.format(pay);
    }
    return '';
  }
}
