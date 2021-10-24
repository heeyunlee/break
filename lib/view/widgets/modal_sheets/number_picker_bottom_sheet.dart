import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/view_models/edit_nutrition_entry_screen_model.dart';

import '../widgets.dart';

class NumberPickerBottomSheet extends StatefulWidget {
  const NumberPickerBottomSheet({
    Key? key,
    required this.model,
    required this.numValue,
    required this.intMaxValue,
    required this.title,
    required this.color,
    required this.onIntChanged,
    required this.onDecimalChanged,
  }) : super(key: key);

  final EditNutritionModel model;
  final num? numValue;
  final int intMaxValue;
  final String title;
  final Color color;
  final void Function(int) onIntChanged;
  final void Function(int) onDecimalChanged;

  @override
  State<NumberPickerBottomSheet> createState() =>
      _NumberPickerBottomSheetState();
}

class _NumberPickerBottomSheetState extends State<NumberPickerBottomSheet> {
  @override
  void initState() {
    super.initState();
    widget.model.initFatEditor(widget.numValue);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return BlurredCard(
      child: Stack(
        children: [
          Positioned(
            top: 16,
            right: 16,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(S.current.cancel, style: TextStyles.button1Grey),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 24),
              Text(widget.title, style: TextStyles.body1Bold),
              SizedBox(
                height: size.height / 4,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NumberPicker(
                        minValue: 0,
                        maxValue: widget.intMaxValue,
                        itemHeight: 48,
                        textStyle: TextStyles.body1,
                        selectedTextStyle: TextStyles.headline5W900.copyWith(
                          color: widget.color,
                        ),
                        value: widget.model.intValue!,
                        onChanged: widget.onIntChanged,
                      ),
                      Text(
                        '.',
                        style: TextStyles.headline5W900.copyWith(
                          color: widget.color,
                        ),
                      ),
                      NumberPicker(
                        minValue: 0,
                        maxValue: 9,
                        itemHeight: 48,
                        textStyle: TextStyles.body1,
                        selectedTextStyle: TextStyles.headline5W900.copyWith(
                          color: widget.color,
                        ),
                        value: widget.model.decimalValue!,
                        onChanged: widget.onDecimalChanged,
                      ),
                      Text(
                        Formatter.unitOfMassGram(
                          null,
                          widget.model.nutrition.unitOfMass,
                        ),
                        style: TextStyles.body1,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: MaxWidthRaisedButton(
                  color: theme.primaryColor,
                  radius: 24,
                  onPressed: () => widget.model.onPressSave(context),
                  buttonText: S.current.save,
                ),
              ),
              const SizedBox(height: kBottomNavigationBarHeight),
            ],
          ),
        ],
      ),
    );
  }
}
