import 'package:flutter/material.dart';
import 'package:workout_player/screens/settings_tab/settings_tab.dart';
import 'package:workout_player/widgets/appbar_blur_bg.dart';
import 'package:workout_player/generated/l10n.dart';

import '../../constants.dart';
import 'routine/routines_tab.dart';
import 'workout/workouts_tab.dart';

class LibraryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint('LibraryTab scaffold building...');

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              _buildSliverAppBar(context),
            ];
          },
          body: TabBarView(
            children: [
              RoutinesTab(),
              WorkoutsTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      title: Text(S.current.library, style: kSubtitle2),
      floating: true,
      pinned: true,
      snap: false,
      centerTitle: true,
      brightness: Brightness.dark,
      flexibleSpace: const AppbarBlurBG(
        blurSigma: 10,
      ),
      backgroundColor: kAppBarColor,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(
            Icons.settings_rounded,
            color: Colors.white,
          ),
          onPressed: () => SettingsTab.show(context),
        ),
        const SizedBox(width: 8),
      ],
      bottom: TabBar(
        unselectedLabelColor: Colors.white,
        labelColor: kPrimaryColor,
        indicatorColor: kPrimaryColor,
        tabs: [
          Tab(text: S.current.routines),
          Tab(text: S.current.workouts),
        ],
      ),
    );
  }
}
