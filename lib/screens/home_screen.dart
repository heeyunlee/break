import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/screens/cupertino_home_scaffold.dart';
import 'package:workout_player/screens/home_tab/home_tab.dart';
import 'package:workout_player/screens/progress_tab/progress_tab.dart';
import 'package:workout_player/screens/search_tab/search_tab.dart';
import 'package:workout_player/screens/settings_tab/settings_tab.dart';
import 'package:workout_player/screens/tab_item.dart';
// import 'package:workout_player/screens/tab_navigator.dart';

import 'library_tab/library_tab.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TabItem _currentTab = TabItem.explore;

  final Map<TabItem, GlobalKey<NavigatorState>> _tabNavigatorKeys = {
    TabItem.explore: GlobalKey<NavigatorState>(),
    TabItem.search: GlobalKey<NavigatorState>(),
    TabItem.library: GlobalKey<NavigatorState>(),
    TabItem.progress: GlobalKey<NavigatorState>(),
    TabItem.settings: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.explore: (_) => HomeTab(),
      TabItem.search: (_) => SearchTab(),
      TabItem.library: (_) => LibraryTab(),
      TabItem.progress: (_) => ProgressTab(),
      TabItem.settings: (_) => SettingsTab(),
    };
  }

  void _selectTab(TabItem tabItem) {
    // Navigating to original Tab Screen when you press Nav Tab
    if (tabItem == _currentTab) {
      _tabNavigatorKeys[tabItem]
          .currentState
          .popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentTab = tabItem;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await _tabNavigatorKeys[_currentTab].currentState.maybePop(),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectedTab: _selectTab,
        widgetBuilder: widgetBuilders,
        navigatorKeys: _tabNavigatorKeys,
      ),
      // child: Scaffold(
      //   body: Stack(
      //     children: [
      //       _buildOffstageNavigator(TabItem.explore),
      //       _buildOffstageNavigator(TabItem.search),
      //       _buildOffstageNavigator(TabItem.progress),
      //       _buildOffstageNavigator(TabItem.library),
      //       _buildOffstageNavigator(TabItem.settings),
      //     ],
      //   ),
      //   bottomNavigationBar: BottomNavigation(
      //     currentTab: _currentTab,
      //     onSelectTab: _selectTab,
      //   ),
      // ),
    );
  }

  // Widget _buildOffstageNavigator(TabItem tabItem) {
  //   return Offstage(
  //     offstage: _currentTab != tabItem,
  //     child: TabNavigator(
  //       navigatorKey: _tabNavigatorKeys[tabItem],
  //       tabItem: tabItem,
  //     ),
  //   );
  // }
}
