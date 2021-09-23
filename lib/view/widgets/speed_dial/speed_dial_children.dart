import 'package:flutter/material.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/styles/theme_colors.dart';

class SpeedDialChildren extends StatelessWidget {
  final void Function() onPressed;
  final Widget icon;
  final String label;

  const SpeedDialChildren({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Material(
            color: ThemeColors.primary500,
            clipBehavior: Clip.antiAlias,
            shape: const CircleBorder(),
            elevation: 6,
            child: SizedBox(
              width: 40,
              height: 40,
              child: IconButton(
                icon: icon,
                onPressed: onPressed,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Material(
            color: Colors.transparent,
            child: Text(label, style: TextStyles.caption1),
          )
        ],
      ),
    );
  }
}
