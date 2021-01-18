import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../../../../constants.dart';
import 'create_new_playlist_form.dart';

class CreateNewPlaylistTitle extends StatefulWidget {
  static Future<void> show(BuildContext context) async {
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => CreateNewPlaylistTitle(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _CreateNewPlaylistTitleState createState() => _CreateNewPlaylistTitleState();
}

class _CreateNewPlaylistTitleState extends State<CreateNewPlaylistTitle> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.close_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('제목 설정', style: Subtitle1),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
          SizedBox(height: 32),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              height: 48,
              child: RaisedButton(
                child: Text(
                  'CREATE',
                  style: ButtonTextBlack,
                ),
                onPressed: () {
                  pushNewScreen(
                    context,
                    screen: CreateNewWorkoutPlaylistForm(),
                    withNavBar: true,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
