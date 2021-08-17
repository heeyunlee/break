import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

import '../fade_slide_transition.dart';

class CheckboxListView extends StatelessWidget {
  final List<dynamic> items;
  final bool Function(dynamic) checked;
  final void Function(bool? value, dynamic item) onChangedMainMuscleEnum;
  final String Function(dynamic) getTitle;
  final Offset? beginOffset;
  final Offset? endOffset;
  final double? offsetStartInterval;
  final double? offsetDelay;
  final double? offsetDuration;
  final Curve? offsetCurves;
  final double? opacityStartInterval;
  final double? opacityDelay;
  final double? opacityDuration;
  final Curve? opacityCurves;

  const CheckboxListView({
    Key? key,
    required this.items,
    required this.checked,
    required this.onChangedMainMuscleEnum,
    required this.getTitle,
    this.beginOffset,
    this.endOffset = const Offset(0, 0),
    this.offsetStartInterval = 0.0,
    this.offsetDelay = 0.05,
    this.offsetDuration = 0.25,
    this.offsetCurves = Curves.decelerate,
    this.opacityStartInterval = 0.0,
    this.opacityDelay = 0.05,
    this.opacityDuration = 0.25,
    this.opacityCurves = Curves.decelerate,
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
        final offsetBegin = offsetStartInterval! + offsetDelay! * index;
        final offsetEnd = offsetBegin + offsetDuration!;

        assert(offsetEnd <= 1);

        final opacityBegin = opacityStartInterval! + opacityDelay! * index;
        final opacityEnd = opacityBegin + opacityDuration!;

        assert(opacityEnd <= 1);

        return FadeSlideTransition(
          beginOffset: Offset(0.75, 0),
          endOffset: Offset(0, 0),
          offsetBeginInterval: offsetBegin,
          offsetEndInterval: offsetEnd,
          offsetCurves: offsetCurves,
          opacityBeginInterval: opacityBegin,
          opacityEndInterval: opacityEnd,
          opacityCurves: opacityCurves,
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
