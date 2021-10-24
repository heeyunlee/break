import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppBarCloseButton extends StatelessWidget {
  const AppBarCloseButton({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ??
          () {
            HapticFeedback.mediumImpact();
            Navigator.of(context).pop();
          },
      icon: const Icon(Icons.close_rounded),
    );
  }
}
