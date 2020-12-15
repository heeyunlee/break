import 'dart:ui';

import 'package:flutter/material.dart';

import '../../constants.dart';
import 'edit_playlist_title.dart';

class NewWorkoutPlaylistForm extends StatelessWidget {
  static const routeName = '/new-workout-playlist';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.transparent,
              floating: true,
              pinned: true,
              snap: false,
              // expandedHeight: 300,
              title: Text('새로운 운동 루틴 생성', style: Subtitle1),
              flexibleSpace: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
                  child: Container(
                    decoration:
                        BoxDecoration(color: Colors.black.withOpacity(0.35)),
                  ),
                ),
              ),
              // flexibleSpace: Container(
              //   color: Grey600,
              // ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {},
                  child: Text(
                    '완료',
                    style: ButtonText,
                  ),
                )
              ],
            ),
          ];
        },
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('12월 15일 화요일 오전', style: BodyText2),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: Row(
                  children: [
                    Text('새로운 운동 루틴', style: Headline4),
                    Spacer(),
                    IconButton(
                      icon: Icon(
                        Icons.edit_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(EditPlaylistTitle.routeName);
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
