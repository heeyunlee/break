import 'package:flutter/material.dart';

import 'package:workout_player/widgets/offset_opacity_animated_container.dart';

class AnimatedListViewBuilder extends StatelessWidget {
  final List<Widget> items;
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

  const AnimatedListViewBuilder({
    Key? key,
    required this.items,
    this.beginOffset,
    this.endOffset = const Offset(0, 0),
    this.offsetStartInterval = 0.2,
    this.offsetDelay = 0.1,
    this.offsetDuration = 0.3,
    this.offsetCurves = Curves.decelerate,
    this.opacityStartInterval = 0.2,
    this.opacityDelay = 0.1,
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
      itemBuilder: (context, index) {
        final offsetBegin = offsetStartInterval! + offsetDelay! * index;
        final offsetEnd = offsetBegin + offsetDuration!;

        assert(offsetEnd <= 1);

        final opacityBegin = opacityStartInterval! + opacityDelay! * index;
        final opacityEnd = opacityBegin + opacityDuration!;

        assert(opacityEnd <= 1);

        return OffsetOpacityAnimatedContainer(
          beginOffset: beginOffset,
          endOffset: endOffset,
          offsetBeginInterval: offsetBegin,
          offsetEndInterval: offsetEnd,
          offsetCurves: offsetCurves,
          opacityBeginInterval: opacityBegin,
          opacityEndInterval: opacityEnd,
          opacityCurves: opacityCurves,
          child: items[index],
        );
      },
    );
  }
}
