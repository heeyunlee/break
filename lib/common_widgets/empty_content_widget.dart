import 'package:flutter/material.dart';

import '../constants.dart';

class EmptyContentWidget extends StatelessWidget {
  final String imageUrl;
  final String bodyText;
  final Function onPressed;

  const EmptyContentWidget({
    Key key,
    this.imageUrl,
    this.bodyText,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: size.height * 2 / 3,
      child: Stack(
        overflow: Overflow.visible,
        children: [
          Image.asset(
            imageUrl,
            width: size.width,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 48,
            left: 24,
            child: Container(
              width: size.width / 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(bodyText, style: BodyText1Height),
                  const SizedBox(height: 36),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    color: PrimaryColor,
                    child: const Text('Start Now', style: ButtonText),
                    onPressed: onPressed,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
