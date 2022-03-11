import 'package:flutter/cupertino.dart';
import 'package:workout_player/view/widgets/widgets.dart';

void showAdaptiveDatePicker(
  BuildContext context, {
  Key? key,
  DateTime? initialDateTime,
  required void Function(DateTime) onDateTimeChanged,
  bool? showButton = false,
}) {
  showCupertinoModalPopup(
    context: context,
    builder: (context) {
      return AdaptiveDatePicker(
        key: key,
        initialDateTime: initialDateTime,
        onDateTimeChanged: onDateTimeChanged,
        showButton: showButton,
      );
    },
  );
}
