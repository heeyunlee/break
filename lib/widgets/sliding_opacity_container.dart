import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SlidingOpacityContainer extends StatelessWidget {
  final Offset? beginOffset;
  final Offset? endOffset;
  final double? beginInterval;
  final double? endInterval;
  final Curve? curves;
  final Widget child;

  const SlidingOpacityContainer({
    Key? key,
    this.beginOffset,
    this.endOffset,
    this.beginInterval,
    this.endInterval,
    this.curves,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final animation = Provider.of<Animation<double>>(context, listen: false);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Interval(
            beginInterval ?? 0.0,
            endInterval ?? 1.0,
            curve: curves ?? Curves.easeOutCubic,
          ),
        );

        return Opacity(
          opacity: curvedAnimation.value,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: beginOffset ?? Offset(0, 1),
              end: endOffset ?? Offset(0, 0),
            ).animate(curvedAnimation),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
