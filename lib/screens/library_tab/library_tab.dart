import 'package:flutter/material.dart';

import '../../common_widgets/appbar_blur_bg.dart';
import '../../constants.dart';
import 'routine/saved_routines_tab.dart';
import 'workout/saved_workouts.dart';

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
                title: Text('Workout Library', style: Subtitle1),
                flexibleSpace: AppbarBlurBG(),
                backgroundColor: Colors.transparent,
                elevation: 0,
                bottom: TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Grey400,
                  indicatorColor: PrimaryColor,
                  tabs: [
                    Tab(text: 'Workouts'),
                    Tab(text: 'Routines'),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              SavedWorkoutsTab.create(context),
              SavedRoutinesTab(),
            ],
          ),
        ),
      ),
    );
  }
}
