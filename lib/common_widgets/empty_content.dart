import 'package:flutter/material.dart';

import '../constants.dart';

class EmptyContent extends StatelessWidget {
  const EmptyContent({
    Key key,
    this.title = '저장된 운동이 없습니다...',
    // this.message = '운동을 즐겨찾기 하거나 새로운 운동을 만들어 보세요!',
  }) : super(key: key);

  final String title;
  // final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          'images/treadmill.png',
          height: 400,
          width: 400,
        ),
        Text(title, style: Subtitle1.copyWith(fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
      ],
    );
  }
}
