import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:workout_player/styles/constants.dart';

class FirstPreviewWidget extends StatelessWidget {
  const FirstPreviewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      alignment: Alignment(0, 0),
      children: [
        Center(
          child: SvgPicture.asset(
            'assets/images/bg2.svg',
            width: size.width - 48,
          ),
        ),
        Positioned(
          bottom: 120,
          child: Text(
            'Herakles: Workout Player',
            style: kBodyText1MenloSpaced,
          ),
        ),
      ],
    );
  }
}
