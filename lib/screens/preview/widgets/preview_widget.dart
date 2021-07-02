import 'package:flutter/material.dart';
import 'package:workout_player/styles/text_styles.dart';

class PreviewWidget extends StatelessWidget {
  final Widget child;
  final String title;
  final String subtitle;
  final double? width;
  final double? height;

  const PreviewWidget({
    Key? key,
    required this.child,
    required this.title,
    required this.subtitle,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: width ?? size.width,
            height: height ?? size.width,
            child: child,
          ),
          Text(
            title,
            style: TextStyles.headline6_menlo_bold,
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            style: TextStyles.body1_menlo_white54,
          ),
          const SizedBox(height: 96),
        ],
      ),
    );
  }
}
