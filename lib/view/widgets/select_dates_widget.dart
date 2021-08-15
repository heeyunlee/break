import 'package:flutter/cupertino.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/view_models/main_model.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';

class SelectDatesWidget extends StatelessWidget {
  final String? labelText;
  final DateTime initialDateTime;
  final void Function(DateTime) onDateTimeChanged;
  final void Function(VisibilityInfo) onVisibilityChanged;
  final Color borderColor;

  const SelectDatesWidget({
    Key? key,
    this.labelText,
    required this.initialDateTime,
    required this.onDateTimeChanged,
    required this.onVisibilityChanged,
    required this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.d('Select Dates Widget building...');

    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () => _showDatePicker(context),
          child: Container(
            height: 56,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  Formatter.yMdjmInDateTime(initialDateTime),
                  style: TextStyles.body1,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 12,
          top: -6,
          child: Container(
            color: kBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                labelText ?? S.current.time,
                style: TextStyles.caption1,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showDatePicker(BuildContext context) {
    final size = MediaQuery.of(context).size;

    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return VisibilityDetector(
          key: Key('DatePicker'),
          onVisibilityChanged: onVisibilityChanged,
          child: Container(
            color: kCardColorLight,
            height: size.height / 3,
            child: CupertinoTheme(
              data: CupertinoThemeData(brightness: Brightness.dark),
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
}
