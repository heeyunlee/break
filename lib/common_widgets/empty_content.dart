import 'package:flutter/material.dart';

import '../constants.dart';

class EmptyContent extends StatelessWidget {
  const EmptyContent({
    Key key,
    @required this.message,
    this.button,
  }) : super(key: key);

  final String message;
  final Widget button;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 36),
          Text(message, style: Subtitle1Bold),
          Image.asset(
            'assets/images/treadmill.png',
            height: 320,
            width: 320,
          ),
          if (button != null) button,
        ],
      ),
    );
  }
}
