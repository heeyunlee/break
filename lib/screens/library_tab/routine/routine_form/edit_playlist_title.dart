import 'package:flutter/material.dart';

import '../../../../constants.dart';

class EditPlaylistTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.cancel_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('제목 수정', style: Subtitle1),
        actions: [
          IconButton(
            icon: Icon(Icons.done_rounded),
            onPressed: () {},
          ),
          SizedBox(width: 4),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 32),
          Container(
            height: 48,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            padding: EdgeInsets.all(8),
            // color: CardColor
            child: TextFormField(
              style: Subtitle1,
              autofocus: true,
              decoration: InputDecoration(
                hintStyle: SearchBarHintStyle,
                hintText: '제목을 입력해 주세요',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: PrimaryColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
