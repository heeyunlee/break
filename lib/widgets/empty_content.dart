import 'package:flutter/material.dart';
import 'package:workout_player/services/main_provider.dart';

import '../constants.dart';

class EmptyContent extends StatelessWidget {
  final String? message;
  final Widget? button;
  final num sizeFactor;
  final Object? e;

  const EmptyContent({
    Key? key,
    this.message,
    this.button,
    this.sizeFactor = 3,
    this.e,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    logger.e(e);

    return Container(
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 36),
          if (message != null) Text(message!, style: kSubtitle1Bold),
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
