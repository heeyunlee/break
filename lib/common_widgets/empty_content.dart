import 'package:flutter/material.dart';

import '../constants.dart';

class EmptyContent extends StatelessWidget {
  const EmptyContent({
    Key key,
    this.message = 'Haven\'t saved Any Workouts Yet...',
  }) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          'assets/images/treadmill.png',
          height: 400,
          width: 400,
        ),
        Text(message, style: Subtitle1.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
      ],
    );
  }
}
