import 'package:flutter/material.dart';

class AppbarBlurBG extends StatelessWidget {
  const AppbarBlurBG({
    Key? key,
    this.childWidget,
    this.color,
    this.blurSigma,
  }) : super(key: key);

  final Widget? childWidget;
  final Color? color;
  final double? blurSigma;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: color ?? theme.appBarTheme.backgroundColor,
      ),
      child: childWidget,
    );
    // return ClipRect(
    //   clipBehavior: Clip.antiAlias,
    //   child: BackdropFilter(
    //     filter: ImageFilter.blur(
    //       sigmaX: blurSigma ?? 15,
    //       sigmaY: blurSigma ?? 15,
    //     ),
    //     child: Container(
    //       decoration: BoxDecoration(
    //         // color: color ?? kAppBarColor.withOpacity(0.5),
    //         color: color ?? kAppBarColor,
    //       ),
    //       child: childWidget,
    //     ),
    //   ),
    // );
  }
}
