import 'package:flutter/material.dart';
import 'package:workout_player/widgets/appbar_blur_bg.dart';
import 'package:workout_player/widgets/speed_dial_fab.dart';
import 'package:workout_player/generated/l10n.dart';

import '../../constants.dart';
import 'routine/saved_routines_tab.dart';
import 'workout/saved_workouts_tab.dart';

class LibraryTab extends StatelessWidget {
  static const routeName = 'library';

  @override
  Widget build(BuildContext context) {
    debugPrint('LibraryTab scaffold building...');

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: BackgroundColor,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              _buildSliverAppBar(context),
            ];
          },
          body: TabBarView(
            children: [
              SavedRoutinesTab(),
              SavedWorkoutsTab(),
            ],
          ),
        ),
        floatingActionButton: SpeedDialFAB(),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      title: Text(S.current.library, style: Subtitle2),
      floating: true,
      pinned: true,
      snap: false,
      centerTitle: true,
      brightness: Brightness.dark,
      flexibleSpace: const AppbarBlurBG(),
      backgroundColor: AppBarColor,
      elevation: 0,
      bottom: TabBar(
        unselectedLabelColor: Colors.white,
        labelColor: PrimaryColor,
        indicatorColor: PrimaryColor,
        tabs: [
          Tab(text: S.current.routines),
          Tab(text: S.current.workouts),
        ],
      ),
    );
  }
}
