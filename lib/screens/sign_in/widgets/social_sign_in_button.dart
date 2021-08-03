import 'package:flutter/material.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/widgets/sliding_opacity_container.dart';

class SocialSignInButton extends StatelessWidget {
  final Offset beginOffset;
  final double beginInterval;
  final double endInterval;
  final Color color;
  final String kButtonText;
  final String? logo;
  final Color textColor;
  final void Function()? onPressed;
  final IconData? iconData;

  const SocialSignInButton({
    Key? key,
    required this.beginOffset,
    required this.beginInterval,
    required this.endInterval,
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

    return SlidingOpacityContainer(
      beginOffset: beginOffset,
      beginInterval: beginInterval,
      endInterval: endInterval,
      child: Padding(
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
            shape: MaterialStateProperty.resolveWith((_) => StadiumBorder()),
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
                  style: TextStyles.google1.copyWith(color: textColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
