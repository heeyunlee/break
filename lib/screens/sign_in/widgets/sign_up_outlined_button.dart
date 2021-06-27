import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:workout_player/styles/text_styles.dart';

import '../../../styles/constants.dart';

class SignUpOutlinedButton extends StatelessWidget {
  final String? logo;
  final String kButtonText;
  final void Function()? onPressed;
  final Color? logoColor;
  final double logoSize;
  final bool isLogoSVG;

  const SignUpOutlinedButton({
    Key? key,
    this.logo,
    required this.kButtonText,
    this.onPressed,
    this.logoColor,
    this.logoSize = 18,
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
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: kGrey700),
            shape: StadiumBorder(
              side: BorderSide(width: 3),
            ),
          ),
          onPressed: onPressed,
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              if (!isLogoSVG)
                Image.asset(
                  logo!,
                  height: logoSize,
                  width: logoSize,
                  color: logoColor,
                ),
              if (isLogoSVG)
                SvgPicture.asset(
                  logo!,
                  height: logoSize,
                  width: logoSize,
                  color: logoColor,
                ),
              Center(
                child: Text(
                  kButtonText,
                  style: TextStyles.google1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
