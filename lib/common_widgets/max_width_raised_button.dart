import 'package:flutter/material.dart';

import '../constants.dart';

class MaxWidthRaisedButton extends StatelessWidget {
  const MaxWidthRaisedButton({
    Key key,
    @required this.buttonText,
    this.color,
    this.icon,
    this.onPressed,
    this.width,
  }) : super(key: key);

  final Color color;
  final String buttonText;
  final Icon icon;
  final void Function() onPressed;
  final double width;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width ?? size.width, 48),
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
