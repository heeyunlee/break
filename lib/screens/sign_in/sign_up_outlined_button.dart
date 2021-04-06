import 'package:flutter/material.dart';

import '../../constants.dart';

class SignUpOutlinedButton extends StatelessWidget {
  final void Function() onPressed;
  final String logo;
  final String buttonText;
  final Color logoColor;
  final double logoSize;

  const SignUpOutlinedButton({
    Key key,
    this.logo,
    this.buttonText,
    this.onPressed,
    this.logoColor,
    this.logoSize = 18,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: SizedBox(
        width: size.width - 64,
        height: 48,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Grey700),
            shape: StadiumBorder(
              side: BorderSide(width: 3),
            ),
          ),
          onPressed: onPressed,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              Image.asset(
                logo,
                height: logoSize,
                width: logoSize,
                color: logoColor,
              ),
              Center(
                child: Text(
                  buttonText,
                  style: GoogleSignInStyle.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
