import 'package:flutter/material.dart';

class BlurBackgroundCard extends StatelessWidget {
  const BlurBackgroundCard({
    Key? key,
    required this.child,
    this.color,
    this.shadowColor,
    this.topPadding,
    this.leftPadding,
    this.bottomPadding,
    this.rightPadding,
    this.allPadding,
    this.borderRadius = 24,
    this.isChecked = false,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  final Widget child;
  final Color? color;
  final Color? shadowColor;
  final double? topPadding;
  final double? leftPadding;
  final double? bottomPadding;
  final double? rightPadding;
  final double? allPadding;
  final double? borderRadius;
  final bool? isChecked;
  final void Function()? onTap;
  final void Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        top: topPadding ?? allPadding ?? 16,
        left: leftPadding ?? allPadding ?? 8,
        right: rightPadding ?? allPadding ?? 8,
        bottom: bottomPadding ?? allPadding ?? 16,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius!),
          border: isChecked!
              ? Border.all(color: theme.primaryColor, width: 4)
              : Border.all(width: 0),
          boxShadow: [
            BoxShadow(
              color: (shadowColor ?? Colors.black).withOpacity(0.14),
              blurRadius: 5,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: (shadowColor ?? Colors.black).withOpacity(0.12),
              blurRadius: 10,
              offset: const Offset(0, 1),
            ),
            BoxShadow(
              color: (shadowColor ?? Colors.black).withOpacity(0.20),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          borderRadius: BorderRadius.circular(24),
          color: color ?? theme.cardTheme.color?.withOpacity(0.95),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onLongPress: onLongPress,
            onTap: onTap,
            child: child,
          ),
        ),
        // child: ClipRRect(
        //   borderRadius: BorderRadius.circular(borderRadius! - 4),
        //   child: BackdropFilter(
        //     filter: ui.ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        //     child: Material(
        //       color: color ?? Colors.black38,
        //       child: InkWell(
        //         onLongPress: onLongPress,
        //         onTap: onTap,
        //         child: child,
        //       ),
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
