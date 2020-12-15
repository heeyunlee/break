import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'saved_playlist.dart';
import 'saved_workouts.dart';

class LibraryTab extends StatefulWidget {
  @override
  _LibraryTabState createState() => _LibraryTabState();
}

class _LibraryTabState extends State<LibraryTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: BackgroundColor,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                floating: true,
                pinned: true,
                snap: false,
                title: Text('운동 창고', style: Subtitle1),
                flexibleSpace: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
                    child: Container(
                      decoration:
                          BoxDecoration(color: Colors.black.withOpacity(0.35)),
                    ),
                  ),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                bottom: TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Grey400,
                  indicatorColor: PrimaryColor,
                  tabs: [
                    Tab(text: '운동'),
                    Tab(text: '플레이리스트'),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [SavedWorkout(), SavedPlaylist()],
          ),
        ),
      ),
    );
  }
}
