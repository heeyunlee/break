import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/text_styles.dart';

import '../widgets.dart';

class AdaptiveDatePicker extends StatelessWidget {
  const AdaptiveDatePicker({
    Key? key,
    this.initialDateTime,
    required this.onDateTimeChanged,
    this.showButton = false,
    this.onSave,
  }) : super(key: key);

  final DateTime? initialDateTime;
  final void Function(DateTime) onDateTimeChanged;
  final bool? showButton;
  final void Function()? onSave;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return BlurredCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: size.height / 3,
            child: CupertinoTheme(
              data: const CupertinoThemeData(
                brightness: Brightness.dark,
              ),
              child: CupertinoDatePicker(
                initialDateTime: initialDateTime,
                onDateTimeChanged: onDateTimeChanged,
              ),
            ),
          ),
          if (showButton!)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: MaxWidthRaisedButton(
                color: theme.primaryColor,
                radius: 24,
                buttonText: S.current.save,
                onPressed: onSave,
              ),
            ),
          if (showButton!) const SizedBox(height: 8),
          if (showButton!)
            SizedBox(
              width: size.width - 32,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  S.current.cancel,
                  style: TextStyles.button1Grey,
                ),
              ),
            ),
          if (showButton!) const SizedBox(height: kBottomNavigationBarHeight),
        ],
      ),
    );
  }
}
