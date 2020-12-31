import 'package:flutter/material.dart';

import '../../constants.dart';

class SocialSignInButton extends StatefulWidget {
  const SocialSignInButton({
    Key key,
    this.color,
    this.disabledColor,
    this.onPressed,
    this.logo,
    this.buttonText,
  }) : super(key: key);

  final Color color;
  final Color disabledColor;
  final onPressed;
  final String logo;
  final String buttonText;

  @override
  _SocialSignInButtonState createState() => _SocialSignInButtonState();
}

class _SocialSignInButtonState extends State<SocialSignInButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: RaisedButton(
        disabledColor: widget.disabledColor,
        color: widget.color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        onPressed: widget.onPressed,
        child: Container(
          height: 48,
          width: 258,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Image.asset(
                widget.logo,
                height: 18,
                width: 18,
              ),
              Center(
                child: Text(
                  widget.buttonText,
                  style: GoogleSignInStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
