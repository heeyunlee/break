import 'package:flutter/material.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/features/widgets/modal_sheets/show_adaptive_date_picker.dart';

import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';

class SelectDatesWidget extends StatelessWidget {
  const SelectDatesWidget({
    Key? key,
    this.labelText,
    required this.initialDateTime,
    required this.onDateTimeChanged,
  }) : super(key: key);

  final String? labelText;
  final DateTime initialDateTime;
  final void Function(DateTime) onDateTimeChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () => showAdaptiveDatePicker(
            context,
            onDateTimeChanged: onDateTimeChanged,
          ),
          child: Container(
            height: 56,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
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
            color: theme.backgroundColor,
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
}
