import 'package:flutter/material.dart';
import 'package:workout_player/view_models/main_model.dart';
import 'package:workout_player/styles/text_styles.dart';

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

    logger.i(e);

    return SizedBox(
      width: size.width,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 36),
          Image.asset(
            'assets/images/treadmill.png',
            height: size.height / sizeFactor,
            width: size.height / sizeFactor,
          ),
          if (message != null)
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(message!, style: TextStyles.subtitle1Bold),
            ),
          if (button != null) button ?? Container(),
        ],
      ),
    );
  }
}
