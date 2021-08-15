import 'package:flutter/material.dart';
import 'package:workout_player/view_models/main_model.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view/widgets/app_bar/appbar_blur_bg.dart';
import 'package:workout_player/generated/l10n.dart';

import 'routines_tab.dart';
import 'workouts_tab.dart';

class LibraryTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    logger.d('Library Tab scaffold building...');

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
          body: const TabBarView(
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
      // elevation: 0,
      floating: true,
      pinned: true,
      snap: false,
      centerTitle: true,
      brightness: Brightness.dark,
      backgroundColor: Colors.transparent,
      flexibleSpace: const AppbarBlurBG(),
      title: Text(S.current.library, style: TextStyles.subtitle2),
      bottom: TabBar(
        indicatorSize: TabBarIndicatorSize.label,
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
