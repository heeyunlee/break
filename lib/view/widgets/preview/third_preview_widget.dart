import 'package:flutter/material.dart';

class ThirdPreviewWidget extends StatelessWidget {
  const ThirdPreviewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: const [
          Placeholder(),
          Placeholder(),
          Placeholder(),
        ],
      ),
    );
  }
}
