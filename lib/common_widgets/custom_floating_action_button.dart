import 'package:flutter/material.dart';

import '../constants.dart';

class CustomFloatingActionButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: PrimaryColor,
      child: IconButton(
        icon: Icon(
          Icons.add_rounded,
          color: Colors.white,
        ),
      ),
      onPressed: () {},
    );
  }
}
