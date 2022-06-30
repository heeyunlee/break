import 'package:flutter/material.dart';

/// A customizable transition builder that fades and slides the `child` widget,
/// using the `CurvedAnimation`,
///
/// This can be used as a item transition in an [AnimatedListViewBuilder].
class FadeSlideTransition extends StatelessWidget {
  final Animation<double> animation;
  final Offset? beginOffset;
  final Offset? endOffset;
  final double? offsetBeginInterval;
  final double? offsetEndInterval;
  final Curve? offsetCurves;
  final double? opacityBeginInterval;
  final double? opacityEndInterval;
  final Curve? opacityCurves;
  final Widget child;

  const FadeSlideTransition({
    Key? key,
    required this.animation,
    this.beginOffset = const Offset(0, 1),
    this.endOffset = Offset.zero,
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
    final offsetTween = Tween<Offset>(begin: beginOffset, end: endOffset);

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

        return FadeTransition(
          opacity: opacityAnimation,
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
