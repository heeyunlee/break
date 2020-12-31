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
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 48,
        child: RaisedButton(
          color: color,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              if (buttonText != null) SizedBox(width: 16),
              if (buttonText != null) Text(buttonText, style: ButtonText),
            ],
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
