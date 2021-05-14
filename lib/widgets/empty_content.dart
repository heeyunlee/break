import 'package:flutter/material.dart';

import '../constants.dart';

class EmptyContent extends StatelessWidget {
  const EmptyContent({
    Key? key,
    this.message,
    this.button,
    this.sizeFactor = 3,
  }) : super(key: key);

  final String? message;
  final Widget? button;
  final num sizeFactor;

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
          if (message != null)
            Text(message ?? 'Message', style: kSubtitle1Bold),
          Image.asset(
            'assets/images/treadmill.png',
            height: size.height / sizeFactor,
            width: size.height / sizeFactor,
          ),
          if (button != null) button ?? Container(),
        ],
      ),
    );
  }
}
