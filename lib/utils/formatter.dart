import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../generated/l10n.dart';
import '../classes/enum/difficulty.dart';
import '../classes/enum/unit_of_mass.dart';

class Formatter {
  static String weights(num weights) {
    final weightsNotNull = weights;
    final formatter = NumberFormat(',###.#');

    return formatter.format(weightsNotNull);
  }

  static String weightsWithDecimal(num weights) {
    final weightsNotNull = weights;
    final formatter = NumberFormat(',##0.0');

    return formatter.format(weightsNotNull);
  }

  static String proteins(num weights) {
    final weightsNotNull = weights;
    final formatter = NumberFormat(',###,###.0');

    return formatter.format(weightsNotNull);
  }

  static String unitOfMass(int unitOfMass) {
    final unitOfMassNotNull = unitOfMass;

    return UnitOfMass.values[unitOfMassNotNull].label!;
  }

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

  static String timeDifference(DateTime date) {
    final now = Timestamp.now().toDate();
    final differenceInSeconds = now.difference(date).inSeconds;
    final differenceInMinutes = now.difference(date).inMinutes;
    final differenceInHours = now.difference(date).inHours;
    final differenceInDays = now.difference(date).inDays;

    if (differenceInSeconds < 60) {
      return S.current.timeDifferenceInSeconds(differenceInSeconds);
    } else if (differenceInMinutes < 60) {
      return S.current.timeDifferenceInMinutes(differenceInMinutes);
    } else if (differenceInHours < 24) {
      return S.current.timeDifferenceInHours(differenceInHours);
    } else {
      return S.current.timeDifferenceInDays(differenceInDays);
    }
  }

  static String currency(double pay) {
    if (pay != 0.0) {
      final formatter = NumberFormat.simpleCurrency(decimalDigits: 0);
      return formatter.format(pay);
    }
    return '';
  }

  static String timeInHM(Timestamp timestamp) {
    final time = timestamp.toDate();
    final formattedTime = DateFormat.jm().format(time);

    return formattedTime;
  }

  static String percentage(num? value) {
    if (value != null) {
      final formatter = NumberFormat('##.0');
      final formattedNum = formatter.format(value);

      return '$formattedNum %';
    } else {
      return '';
    }
  }
}
