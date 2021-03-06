import 'package:flutter/material.dart';

import '../constants.dart';

class MaxWidthRaisedButton extends StatelessWidget {
  const MaxWidthRaisedButton({
    Key key,
    this.color,
    this.buttonText,
    this.icon,
    this.onPressed,
  }) : super(key: key);

  final Color color;
  final String buttonText;
  final Icon icon;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 48,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: color),
          onPressed: onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) icon,
              if (icon != null && buttonText != null) const SizedBox(width: 16),
              if (buttonText != null) Text(buttonText, style: ButtonText),
            ],
          ),
        ),
      ),
    );
  }
}
