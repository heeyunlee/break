import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';

import 'package:workout_player/view/screens/watch_tab.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/home_screen_model.dart';
import 'package:workout_player/view_models/main_model.dart';

import 'library/library_tab.dart';
import 'miniplayer_screen.dart';
import 'progress_tab.dart';
import 'search_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<TabItem, Widget Function()> get widgetBuilders {
    return {
      TabItem.progress: () => ProgressTab.create(),
      TabItem.search: () => const SearchTab(),
      TabItem.watch: () => const WatchTab(),
      TabItem.library: () => const LibraryTab(),
    };
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read(homeScreenModelProvider).updateUser(context);
    context.read(homeScreenModelProvider).setMiniplayerHeight();
  }

  @override
  Widget build(BuildContext context) {
    logger.d('[HomeScreen] building... ');

    return MiniplayerWillPopScope(
      onWillPop: context.read(homeScreenModelProvider).onWillPopMiniplayer,
      child: Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: false,
            extendBody: true,
            key: HomeScreenModel.homeScreenNavigatorKey,
            body: Stack(
              children: [
                _buildIndexedStack(),
                const MiniplayerScreen(),
              ],
            ),
            bottomNavigationBar: const BottomNavigationTab(),
          ),
          SpeedDial.create(),
        ],
      ),
    );
  }

  Widget _buildIndexedStack() {
    return Consumer(
      builder: (context, watch, child) {
        final model = watch(homeScreenModelProvider);

        return IndexedStack(
          index: model.currentTabIndex,
          children: TabItem.values.map((tabItem) {
            return CupertinoTabView(
              navigatorKey: HomeScreenModel.tabNavigatorKeys[tabItem],
              builder: (context) => widgetBuilders[tabItem]!(),
            );
          }).toList(),
        );
      },
    );
  }
}
