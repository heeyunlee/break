import 'package:flutter/material.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/styles/theme_colors.dart';

class NoDataInChartMessageWidget extends StatelessWidget {
  final Color? color;
  final TextStyle textStyle;

  const NoDataInChartMessageWidget({
    Key? key,
    this.color = ThemeColors.primary500,
    this.textStyle = TextStyles.caption1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0, 0),
      child: Container(
        width: 120,
        height: 28,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(S.current.addMoreData, style: textStyle),
        ),
      ),
    );
  }
}
