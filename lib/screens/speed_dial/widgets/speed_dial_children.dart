import 'package:flutter/material.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

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
    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: 80,
          height: 80,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Material(
                color: kPrimaryColor,
                clipBehavior: Clip.antiAlias,
                shape: const CircleBorder(),
                elevation: 6,
                child: SizedBox(width: 40, height: 40, child: icon),
              ),
              const SizedBox(height: 8),
              Text(label, style: TextStyles.caption1)
            ],
          ),
        ),
      ),
    );
  }
}
