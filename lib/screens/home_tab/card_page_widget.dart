import 'package:flutter/material.dart';

import '../../constants.dart';

class CardPageWidget extends StatelessWidget {
  const CardPageWidget({
    Key key,
    this.color,
    this.title,
    this.summary,
    this.subtitle,
  }) : super(key: key);

  final Color color;
  final String title;
  final String summary;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 1,
      color: color,
      child: Column(
        children: [
          SizedBox(height: 8),
          Text(
            title,
            style: BodyText2,
          ),
          SizedBox(height: 8),
          Text(
            summary,
            style: Headline3,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Placeholder(fallbackHeight: 240),
          ),
          Text(
            subtitle,
            style: BodyText2,
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
