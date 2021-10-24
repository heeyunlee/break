import 'package:flutter/material.dart';
import 'package:workout_player/view/screens/settings_tab.dart';
import 'package:workout_player/view_models/main_model.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/generated/l10n.dart';

import 'routines_tab.dart';
import 'workouts_tab.dart';

class LibraryTab extends StatelessWidget {
  const LibraryTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.d('[LibraryTab] building...');

    return DefaultTabController(
      length: 2,
      child: Scaffold(
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
              // YoutubeVideosTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    final theme = Theme.of(context);

    return SliverAppBar(
      floating: true,
      pinned: true,
      centerTitle: true,
      title: Text(S.current.library, style: TextStyles.subtitle2),
      actions: [
        IconButton(
          onPressed: () => SettingsTab.show(context),
          icon: const Icon(Icons.settings_rounded),
        ),
        const SizedBox(width: 8),
      ],
      bottom: TabBar(
        indicatorSize: TabBarIndicatorSize.label,
        unselectedLabelColor: Colors.white,
        labelColor: theme.primaryColor,
        indicatorColor: theme.primaryColor,
        tabs: [
          Tab(text: S.current.routines),
          Tab(text: S.current.workouts),
          // Tab(text: 'Videos'),
        ],
      ),
    );
  }
}
