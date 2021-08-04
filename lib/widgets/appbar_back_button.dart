import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppBarBackButton extends StatelessWidget {
  final void Function()? onPressed;
  final bool? pressed;

  const AppBarBackButton({
    Key? key,
    this.onPressed,
    this.pressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      disabledColor: Colors.white30,
      color: Colors.white,
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
      onPressed: (pressed ?? false)
          ? null
          : onPressed ??
              () {
                HapticFeedback.mediumImpact();
                Navigator.of(context).pop();
              },
    );
  }
}
