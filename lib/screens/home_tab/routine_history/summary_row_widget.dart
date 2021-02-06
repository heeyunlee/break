import 'package:flutter/material.dart';

import '../../../constants.dart';

class SummaryRowWidget extends StatelessWidget {
  const SummaryRowWidget({
    Key key,
    this.image,
    this.title,
    this.subtitle,
  }) : super(key: key);

  final String image;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.network(
          image,
          width: 36,
          height: 36,
        ),
        SizedBox(width: 16),
        RichText(
          text: TextSpan(
            style: Headline3,
            children: <TextSpan>[
              TextSpan(text: title),
              TextSpan(text: subtitle, style: Subtitle1)
            ],
          ),
        ),
      ],
    );
  }
}
