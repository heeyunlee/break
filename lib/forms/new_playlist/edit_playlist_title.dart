import 'package:flutter/material.dart';

import '../../constants.dart';
import 'new_workout_playlist_form.dart';

class EditPlaylistTitle extends StatelessWidget {
  static const routeName = '/edit-playlist-title';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      appBar: AppBar(
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
                  Navigator.of(context)
                      .pushNamed(NewWorkoutPlaylistForm.routeName);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
