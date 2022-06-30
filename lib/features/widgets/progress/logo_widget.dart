import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:workout_player/styles/text_styles.dart';

class LogoWidget extends StatelessWidget {
  final double gridWidth;
  final double gridHeight;

  const LogoWidget({
    Key? key,
    required this.gridWidth,
    required this.gridHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: gridWidth,
      height: gridHeight,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/svgs/break_logo.svg',
              width: 32,
            ),
            const SizedBox(height: 24),
            const Text('break', style: TextStyles.body1Menlo),
          ],
        ),
      ),
    );
  }
}
