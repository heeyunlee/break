import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

import 'offset_opacity_animated_container.dart';

class CheckboxListView extends StatelessWidget {
  final List<dynamic> items;
  final bool Function(dynamic) checked;
  final void Function(bool? value, dynamic item) onChangedMainMuscleEnum;
  final String Function(dynamic) getTitle;

  const CheckboxListView({
    Key? key,
    required this.items,
    required this.checked,
    required this.onChangedMainMuscleEnum,
    required this.getTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: items.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final item = items[index];
        final beginIntervalFactor = 0.5 / items.length;
        final endIntervalFactor = 1 / items.length;

        return OffsetOpacityAnimatedContainer(
          beginOffset: Offset(0.75, 0),
          endOffset: Offset(0, 0),
          offsetBeginInterval: beginIntervalFactor * index,
          offsetEndInterval: endIntervalFactor * index,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: checked(item) ? kPrimaryColor : kCardColorLight,
                child: CheckboxListTile(
                  activeColor: kPrimary700Color,
                  title: Text(getTitle(item), style: TextStyles.button1),
                  controlAffinity: ListTileControlAffinity.trailing,
                  value: checked(item),
                  selected: checked(item),
                  onChanged: (bool? checked) => onChangedMainMuscleEnum(
                    checked,
                    item,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
