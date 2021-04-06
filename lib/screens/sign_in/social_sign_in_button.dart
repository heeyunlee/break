import 'package:flutter/material.dart';

import '../../constants.dart';

class SocialSignInButton extends StatelessWidget {
  const SocialSignInButton({
    Key key,
    @required this.color,
    @required this.buttonText,
    this.logo,
    this.textColor = Colors.black,
    this.onPressed,
    this.iconData,
  }) : super(key: key);

  final Color color;
  final String logo;
  final String buttonText;
  final Color textColor;
  final void Function() onPressed;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: SizedBox(
        width: size.width - 64,
        height: 48,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            primary: color,
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              (logo != null)
                  ? Image.asset(
                      logo,
                      height: 18,
                      width: 18,
                    )
                  : Icon(
                      iconData,
                      color: Colors.white,
                      size: 20,
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
