import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/styles/theme_colors.dart';

import '../widgets.dart';

class AdaptiveDatePicker extends StatelessWidget {
  const AdaptiveDatePicker({
    Key? key,
    this.onVisibilityChanged,
    this.initialDateTime,
    required this.onDateTimeChanged,
    this.showButton = false,
    this.onSave,
  }) : super(key: key);

  final void Function(VisibilityInfo)? onVisibilityChanged;
  final DateTime? initialDateTime;
  final void Function(DateTime) onDateTimeChanged;
  final bool? showButton;
  final void Function()? onSave;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return VisibilityDetector(
      key: const Key('DatePicker'),
      onVisibilityChanged: onVisibilityChanged,
      child: BlurredCard(
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
                  color: ThemeColors.primary500,
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
      ),
    );
  }
}
