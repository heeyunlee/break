import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppBarBackButton extends StatelessWidget {
  const AppBarBackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        HapticFeedback.mediumImpact();
        Navigator.of(context).pop();
      },
      icon: Icon(Icons.arrow_back_ios_rounded),
    );
  }
}
