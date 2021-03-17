import 'package:flutter/material.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/common_widgets/speed_dial_fab.dart';
import 'package:workout_player/screens/settings/settings_screen.dart';

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
      title: const Text('Library', style: Subtitle2),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.settings_rounded,
            color: Colors.white,
          ),
          onPressed: () => SettingsScreen.show(context),
        ),
        const SizedBox(width: 8),
      ],
      floating: true,
      pinned: true,
      snap: false,
      centerTitle: true,
      flexibleSpace: const AppbarBlurBG(),
      backgroundColor: AppBarColor,
      elevation: 0,
      bottom: const TabBar(
        unselectedLabelColor: Colors.white,
        labelColor: PrimaryColor,
        indicatorColor: PrimaryColor,
        tabs: [
          Tab(text: 'Routines'),
          Tab(text: 'Workouts'),
        ],
      ),
    );
  }
}
