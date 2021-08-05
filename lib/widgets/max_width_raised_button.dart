import 'package:flutter/material.dart';
import 'package:workout_player/styles/text_styles.dart';

class MaxWidthRaisedButton extends StatelessWidget {
  final Color? color;
  final String buttonText;
  final Widget? icon;
  final void Function()? onPressed;
  final double? width;
  final double? radius;

  const MaxWidthRaisedButton({
    Key? key,
    required this.buttonText,
    this.color = Colors.grey,
    this.icon,
    this.onPressed,
    this.width,
    this.radius = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.grey;
            } else {
              return color!;
            }
          },
        ),
        minimumSize: MaterialStateProperty.resolveWith<Size>(
          (_) => Size(width ?? size.width, 48),
        ),
        shape: MaterialStateProperty.resolveWith(
          (_) => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius!),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (icon != null) icon ?? Container(),
          if (icon != null) const SizedBox(width: 16),
          Text(buttonText, style: TextStyles.button1),
        ],
      ),
    );
  }
}
