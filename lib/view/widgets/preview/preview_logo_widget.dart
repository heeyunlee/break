import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PreviewLogoWidget extends StatelessWidget {
  const PreviewLogoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Hero(
        tag: 'logo',
        child: SvgPicture.asset(
          'assets/svgs/break_logo.svg',
          width: 24,
        ),
      ),
    );
  }
}
