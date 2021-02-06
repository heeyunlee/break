import 'package:flutter/material.dart';

class AppPreviewWidget extends StatelessWidget {
  const AppPreviewWidget({Key key, this.imageRoot}) : super(key: key);

  final String imageRoot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Image.asset(
        '$imageRoot',
      ),
    );
  }
}
