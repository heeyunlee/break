import 'package:flutter/material.dart';

import '../../constants.dart';

class CardioEntryScreen extends StatelessWidget {
  static const routeName = '/cardio-entry';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: BackgroundColor,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 200),
            Image.network(
              'https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/271/building-construction_1f3d7-fe0f.png',
            ),
            SizedBox(height: 36),
            Text(
              '열심히 만들고 있습니다!',
              style: BodyText2,
            ),
          ],
        ),
      ),
    );
  }
}
