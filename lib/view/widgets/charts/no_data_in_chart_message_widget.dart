import 'package:flutter/material.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

class NoDataInChartMessageWidget extends StatelessWidget {
  final Color? color;
  final TextStyle textStyle;

  const NoDataInChartMessageWidget({
    Key? key,
    this.color = kPrimaryColor,
    this.textStyle = TextStyles.caption1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0.2, -0.1),
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
