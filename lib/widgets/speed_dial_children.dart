import 'package:flutter/material.dart';

import '../constants.dart';

class SpeedDialChildren extends StatelessWidget {
  final void Function() onPressed;
  final Widget icon;

  const SpeedDialChildren({
    Key? key,
    required this.onPressed,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: PrimaryColor,
      clipBehavior: Clip.antiAlias,
      shape: const CircleBorder(),
      elevation: 4,
      child: SizedBox(
        width: 40,
        height: 40,
        child: IconButton(
          onPressed: onPressed,
          icon: icon,
        ),
      ),
    );
  }
}
