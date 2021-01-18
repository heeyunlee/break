import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';

import '../../../../constants.dart';
import 'edit_playlist_title.dart';

class CreateNewWorkoutPlaylistForm extends StatelessWidget {
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
              flexibleSpace: AppbarBlurBG(),
              // flexibleSpace: Container(
              //   color: Grey600,
              // ),
              actions: <Widget>[
                FlatButton(
                  child: Text('완료', style: ButtonText),
                  onPressed: () {},
                ),
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
                        pushNewScreen(
                          context,
                          screen: EditPlaylistTitle(),
                          pageTransitionAnimation:
                              PageTransitionAnimation.slideUp,
                        );
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
