import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';

import 'miniplayer_collapsed.dart';

class Test1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class CustomMiniplayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Miniplayer(
      elevation: 8,
      minHeight: 118,
      maxHeight: 456,
      builder: (height, percentage) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(25),
            ),
            color: Color(0xff2C2C2E),
          ),
          child: MiniplayerCollapsed(),
        );
      },
    );
  }
}
