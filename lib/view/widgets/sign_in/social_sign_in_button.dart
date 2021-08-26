import 'package:flutter/material.dart';
import 'package:workout_player/styles/text_styles.dart';

class SocialSignInButton extends StatelessWidget {
  final Color color;
  final String kButtonText;
  final String? logo;
  final Color textColor;
  final void Function()? onPressed;
  final IconData? iconData;

  const SocialSignInButton({
    Key? key,
    required this.color,
    required this.kButtonText,
    this.logo,
    this.textColor = Colors.black,
    this.onPressed,
    this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.disabled)) {
                return color.withOpacity(0.75);
              } else {
                return color;
              }
            },
          ),
          minimumSize: MaterialStateProperty.resolveWith<Size>(
            (_) => Size(size.width, 48),
          ),
          shape: MaterialStateProperty.resolveWith(
            (_) => const StadiumBorder(),
          ),
        ),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            _getIcon(),
            Center(
              child: Text(
                kButtonText,
                style: TextStyles.google1.copyWith(color: textColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getIcon() {
    if (logo != null) {
      return Image.asset(logo!, height: 18, width: 18);
    } else {
      return Icon(iconData, color: Colors.white, size: 20);
    }
  }
}
