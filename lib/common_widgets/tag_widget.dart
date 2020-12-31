import 'package:flutter/material.dart';

import '../constants.dart';

class TagWidget extends StatelessWidget {
  final String tag;

  const TagWidget(this.tag);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Text(
        '#$tag',
        style: Subtitle2,
      ),
    );
  }
}
