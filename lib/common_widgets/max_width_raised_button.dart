import 'package:flutter/material.dart';

import '../constants.dart';

class MaxWidthRaisedButton extends StatelessWidget {
  const MaxWidthRaisedButton({
    Key key,
    this.color,
    this.buttonText,
    this.icon,
    this.onPressed,
    @required this.width,
  }) : super(key: key);

  final Color color;
  final String buttonText;
  final Icon icon;
  final void Function() onPressed;
  final double width;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width, 48),
        primary: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) icon,
          if (icon != null && buttonText != null) const SizedBox(width: 16),
          if (buttonText != null) Text(buttonText, style: ButtonText),
        ],
      ),
    );
  }
}
