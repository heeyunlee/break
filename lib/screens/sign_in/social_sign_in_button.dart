import 'package:flutter/material.dart';

import '../../constants.dart';

class SocialSignInButton extends StatelessWidget {
  const SocialSignInButton({
    Key key,
    this.color,
    this.disabledColor,
    this.onPressed,
    this.logo,
    this.buttonText,
    this.textColor = Colors.black,
  }) : super(key: key);

  final Color color;
  final Color disabledColor;
  final onPressed;
  final String logo;
  final String buttonText;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: SizedBox(
        width: size.width - 64,
        height: 48,
        child: RaisedButton(
          disabledColor: disabledColor,
          color: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          onPressed: onPressed,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Image.asset(
                logo,
                height: 18,
                width: 18,
              ),
              Center(
                child: Text(
                  buttonText,
                  style: GoogleSignInStyle.copyWith(color: textColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
