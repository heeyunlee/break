import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:workout_player/view/widgets/home/bottom_navigation_tab.dart';
import 'package:workout_player/view/widgets/home/tab_item.dart';
import 'package:workout_player/view/widgets/speed_dial/speed_dial.dart';
import 'package:workout_player/view_models/main_model.dart';

import '../../view_models/home_screen_model.dart';
import 'library/library_tab.dart';
import 'progress_tab.dart';
import 'search_tab.dart';
import 'settings_tab.dart';
import 'workout_miniplayer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Map<TabItem, dynamic> get widgetBuilders {
    return {
      TabItem.library: (_) => LibraryTab(),
      TabItem.search: (_) => SearchTab(),
      TabItem.progress: (_) => ProgressTab.create(),
      TabItem.settings: (_) => SettingsTab(),
    };
  }

  void updateUserData(BuildContext context) {
    // SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
    //   context.read(homeScreenModelProvider).updateUser(context);
    // });
    context.read(homeScreenModelProvider).updateUser(context);
  }

  @override
  Widget build(BuildContext context) {
    logger.d('[HomeScreen] rebuilding... ');
    updateUserData(context);

    return MiniplayerWillPopScope(
      onWillPop: context.read(homeScreenModelProvider).onWillPopMiniplayer,
      child: Scaffold(
        key: HomeScreenModel.homeScreenNavigatorKey,
        extendBody: true,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Consumer(
              builder: (context, watch, child) {
                final model = watch(homeScreenModelProvider);
                return IndexedStack(
                  index: model.currentTabIndex,
                  children: [
                    _buildOffstageNavigator(context, TabItem.progress),
                    _buildOffstageNavigator(context, TabItem.search),
                    _buildOffstageNavigator(context, TabItem.library),
                    _buildOffstageNavigator(context, TabItem.settings),
                  ],
                );
              },
            ),
            WorkoutMiniplayer.create(context),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: SpeedDial.create(),
        bottomNavigationBar: const BottomNavigationTab(),
      ),
    );
  }

  Widget _buildOffstageNavigator(BuildContext context, TabItem tabItem) {
    return Offstage(
      offstage: context.read(homeScreenModelProvider).currentTab != tabItem,
      child: CupertinoTabView(
        navigatorKey: HomeScreenModel.tabNavigatorKeys[tabItem],
        builder: (context) => widgetBuilders[tabItem](context),
      ),
    );
  }
}
