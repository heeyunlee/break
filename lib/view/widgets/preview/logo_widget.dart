import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Hero(
        tag: 'logo',
        child: SvgPicture.asset(
          'assets/svgs/herakles_icon.svg',
          height: 40,
          width: 40,
        ),
      ),
    );
  }
}
