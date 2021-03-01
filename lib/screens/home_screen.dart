import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/screens/cupertino_home_scaffold.dart';
import 'package:workout_player/screens/home_tab/home_tab.dart';
import 'package:workout_player/screens/tab_item.dart';

import 'library_tab/library_tab.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TabItem _currentTab = TabItem.home;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.home: GlobalKey<NavigatorState>(),
    // TabItem.explore: GlobalKey<NavigatorState>(),
    TabItem.library: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.home: (_) => HomeTab(),
      TabItem.library: (_) => LibraryTab(),
    };
  }

  void _select(TabItem tabItem) {
    // Navigating to original Tab Screen when you press Nav Tab
    if (tabItem == _currentTab) {
      navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else
      setState(() {
        _currentTab = tabItem;
      });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab].currentState.maybePop(),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectedTab: _select,
        widgetBuilder: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}
