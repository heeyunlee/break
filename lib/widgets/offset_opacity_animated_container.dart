import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OffsetOpacityAnimatedContainer extends StatelessWidget {
  final Offset? beginOffset;
  final Offset? endOffset;
  final double? offsetBeginInterval;
  final double? offsetEndInterval;
  final Curve? offsetCurves;
  final double? opacityBeginInterval;
  final double? opacityEndInterval;
  final Curve? opacityCurves;
  final Widget child;

  const OffsetOpacityAnimatedContainer({
    Key? key,
    this.beginOffset = const Offset(0, 1),
    this.endOffset = const Offset(0, 0),
    this.offsetBeginInterval = 0.0,
    this.offsetEndInterval = 1.0,
    this.offsetCurves = Curves.decelerate,
    this.opacityBeginInterval = 0.0,
    this.opacityEndInterval = 1.0,
    this.opacityCurves = Curves.decelerate,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final animation = Provider.of<Animation<double>>(context, listen: false);
    final offsetTween = Tween<Offset>(begin: beginOffset!, end: endOffset!);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final opacityAnimation = CurvedAnimation(
          parent: animation,
          curve: Interval(
            opacityBeginInterval!,
            opacityEndInterval!,
            curve: opacityCurves!,
          ),
        );

        final offsetAnimation = CurvedAnimation(
          parent: animation,
          curve: Interval(
            offsetBeginInterval!,
            offsetEndInterval!,
            curve: offsetCurves!,
          ),
        );

        return Opacity(
          opacity: opacityAnimation.value,
          child: SlideTransition(
            position: offsetTween.animate(offsetAnimation),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
