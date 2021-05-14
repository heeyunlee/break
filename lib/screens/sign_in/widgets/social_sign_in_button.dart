import 'package:flutter/material.dart';

import '../../../constants.dart';

class SocialSignInButton extends StatelessWidget {
  final Color color;
  final String kButtonText;
  final String? logo;
  final Color textColor;
  final void Function()? onPressed;
  final IconData? iconData;
  final double? width;
  final Color? kDisabledColor;
  final bool isLogoSVG;

  const SocialSignInButton({
    Key? key,
    required this.color,
    required this.kButtonText,
    this.logo,
    this.textColor = Colors.black,
    this.onPressed,
    this.iconData,
    this.width,
    this.kDisabledColor,
    this.isLogoSVG = false,
  }) : super(key: key);

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
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return kDisabledColor ?? color.withOpacity(0.5);
                } else {
                  return color;
                }
              },
            ),
            minimumSize: MaterialStateProperty.resolveWith<Size>(
              (_) => Size(width ?? size.width, 48),
            ),
            shape: MaterialStateProperty.resolveWith(
              (_) => RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              (logo != null)
                  ? Image.asset(
                      logo!,
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
                  kButtonText,
                  style: kGoogleSignInStyle.copyWith(color: textColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
