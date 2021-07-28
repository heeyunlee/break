import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppBarBackButton extends StatelessWidget {
  final void Function()? onPressed;

  const AppBarBackButton({
    Key? key,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ??
          () {
            HapticFeedback.mediumImpact();
            Navigator.of(context).pop();
          },
      icon: const Icon(Icons.arrow_back_ios_rounded),
    );
  }
}
