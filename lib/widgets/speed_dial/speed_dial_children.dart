import 'package:flutter/material.dart';

import '../../constants.dart';

class SpeedDialChildren extends StatelessWidget {
  final void Function() onPressed;
  final Widget icon;
  final String label;
  // final double distance;

  const SpeedDialChildren({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.label,
    // required this.distance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          color: PrimaryColor,
          clipBehavior: Clip.antiAlias,
          shape: const CircleBorder(),
          elevation: 6,
          child: SizedBox(
            width: 40,
            height: 40,
            child: IconButton(
              onPressed: onPressed,
              icon: icon,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: Caption1)
      ],
    );
  }
}
