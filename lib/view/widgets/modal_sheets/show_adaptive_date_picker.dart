import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:workout_player/view/widgets/widgets.dart';

void showAdaptiveDatePicker(
  BuildContext context, {
  Key? key,
  void Function(VisibilityInfo)? onVisibilityChanged,
  DateTime? initialDateTime,
  required void Function(DateTime) onDateTimeChanged,
  bool? showButton = false,
}) {
  showCupertinoModalPopup(
    context: context,
    builder: (context) {
      return AdaptiveDatePicker(
        key: key,
        onVisibilityChanged: onVisibilityChanged,
        initialDateTime: initialDateTime,
        onDateTimeChanged: onDateTimeChanged,
        showButton: showButton,
      );
    },
  );
}
