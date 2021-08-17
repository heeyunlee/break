import 'package:flutter/material.dart';
import 'package:workout_player/view/widgets/widgets.dart';

class AnimatedListViewBuilder extends StatelessWidget {
  final List<Widget> items;
  final Offset? beginOffset;
  final Offset? endOffset;
  final double? offsetInitialDelayTime;
  final double? offsetStaggerTime;
  final double? offsetDuration;
  final Curve? offsetCurves;
  final double? opacityInitialDelayTime;
  final double? opacityStaggerTime;
  final double? opacityDuration;
  final Curve? opacityCurves;

  const AnimatedListViewBuilder({
    Key? key,
    required this.items,
    this.beginOffset,
    this.endOffset = const Offset(0, 0),
    this.offsetInitialDelayTime = 0.2,
    this.offsetStaggerTime = 0.1,
    this.offsetDuration = 0.3,
    this.offsetCurves = Curves.decelerate,
    this.opacityInitialDelayTime = 0.2,
    this.opacityStaggerTime = 0.1,
    this.opacityDuration = 0.3,
    this.opacityCurves = Curves.decelerate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: items.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, i) {
        final offsetBegin = offsetInitialDelayTime! + offsetStaggerTime! * i;
        final offsetEnd = offsetBegin + offsetDuration!;

        assert(offsetEnd <= 1);

        final opacityBegin = opacityInitialDelayTime! + opacityStaggerTime! * i;
        final opacityEnd = opacityBegin + opacityDuration!;

        assert(opacityEnd <= 1);

        return FadeSlideTransition(
          beginOffset: beginOffset,
          endOffset: endOffset,
          offsetBeginInterval: offsetBegin,
          offsetEndInterval: offsetEnd,
          offsetCurves: offsetCurves,
          opacityBeginInterval: opacityBegin,
          opacityEndInterval: opacityEnd,
          opacityCurves: opacityCurves,
          child: items[i],
        );
      },
    );
  }
}
