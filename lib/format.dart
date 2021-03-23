import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'models/enum/difficulty.dart';
import 'models/enum/unit_of_mass.dart';

class Format {
  static String weights(num weights) {
    final weightsNotNull = weights ?? 0;
    final formatter = NumberFormat(',###,###.#');

    return formatter.format(weightsNotNull);
  }

  static String proteins(num weights) {
    final weightsNotNull = weights ?? 0;
    final formatter = NumberFormat(',###,###.0');

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

  static String yMdjm(Timestamp timestamp) {
    if (timestamp != null) {
      final dateInDateTime = timestamp.toDate();

      return DateFormat.yMd().add_jm().format(dateInDateTime);
    }
    return 'null...';
  }

  static String yMdjmInDateTime(DateTime date) {
    if (date != null) {
      return DateFormat.yMd().add_jm().format(date);
    }
    return 'null...';
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
    final differenceInMinutes = now.difference(date).inMinutes;
    final differenceInHours = now.difference(date).inHours;
    final differenceInDays = now.difference(date).inDays;

    if (differenceInMinutes < 60) {
      return '$differenceInMinutes minutes ago';
    } else if (differenceInHours < 24) {
      return '$differenceInHours hours ago';
    } else {
      return '$differenceInDays days ago';
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
}
