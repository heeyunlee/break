import 'package:flutter/cupertino.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:workout_player/styles/constants.dart';

void showDatePicker(
  BuildContext context, {
  required void Function(VisibilityInfo)? onVisibilityChanged,
  DateTime? initialDateTime,
  required void Function(DateTime) onDateTimeChanged,
}) {
  final size = MediaQuery.of(context).size;

  showCupertinoModalPopup(
    context: context,
    builder: (context) {
      return VisibilityDetector(
        key: const Key('DatePicker'),
        onVisibilityChanged: onVisibilityChanged,
        child: Container(
          color: kCardColorLight,
          height: size.height / 3,
          child: CupertinoTheme(
            data: const CupertinoThemeData(brightness: Brightness.dark),
            child: CupertinoDatePicker(
              initialDateTime: initialDateTime,
              onDateTimeChanged: onDateTimeChanged,
            ),
          ),
        ),
      );
    },
  );
}
