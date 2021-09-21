import 'package:flutter/material.dart';

class PreviewLogoWidget extends StatelessWidget {
  const PreviewLogoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Hero(
        tag: 'logo',
        child: Image.asset(
          'assets/logos/break_icon.png',
          width: 120,
        ),
      ),
    );
  }
}
