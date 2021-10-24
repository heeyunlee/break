import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view_models/add_nutrition_screen_model.dart';

class SetProteinAmountWidget extends StatelessWidget {
  final AddNutritionScreenModel model;
  final String unit;

  const SetProteinAmountWidget({
    Key? key,
    required this.model,
    required this.unit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NumberPicker(
                  minValue: 1,
                  maxValue: 200,
                  itemHeight: 36,
                  textStyle: TextStyles.body1,
                  selectedTextStyle: TextStyles.headline5W900RedAccent,
                  value: model.intValue,
                  onChanged: model.onIntValueChanged,
                ),
                const Text('.', style: TextStyles.headline5W900RedAccent),
                NumberPicker(
                  minValue: 0,
                  maxValue: 9,
                  itemHeight: 36,
                  textStyle: TextStyles.body1,
                  selectedTextStyle: TextStyles.headline5W900RedAccent,
                  value: model.decimalValue,
                  onChanged: model.onDecimalValueChanged,
                ),
                Text(unit, style: TextStyles.body1),
              ],
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
                S.current.proteins,
                style: TextStyles.caption1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
