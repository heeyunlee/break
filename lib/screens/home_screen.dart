import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/screens/home_tab/home_tab.dart';
import 'package:workout_player/screens/progress_tab/progress_tab.dart';
import 'package:workout_player/screens/search_tab/search_tab.dart';
import 'package:workout_player/screens/tab_item.dart';
import 'package:workout_player/widgets/speed_dial/expandable_fab.dart';

import 'bottom_navigation_tab.dart';
import 'library_tab/library_tab.dart';

ValueNotifier<Routine?> currentRoutine = ValueNotifier(null);
typedef BoolCallback = void Function(bool value);

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TabItem _currentTab = TabItem.home;

  late GlobalKey<NavigatorState> _miniplayerNavigatorKey;
  MiniplayerController miniplayerController = MiniplayerController();

  void _selectTab(TabItem tabItem) {
    // Navigating to original Tab Screen when you press Nav Tab
    if (tabItem == _currentTab) {
      _tabNavigatorKeys[tabItem]!
          .currentState!
          .popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _currentTab = tabItem;
      });
    }
  }

  final Map<TabItem, GlobalKey<NavigatorState>> _tabNavigatorKeys = {
    TabItem.home: GlobalKey<NavigatorState>(),
    TabItem.search: GlobalKey<NavigatorState>(),
    TabItem.library: GlobalKey<NavigatorState>(),
    TabItem.progress: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, dynamic> get widgetBuilders {
    return {
      TabItem.home: (_) => HomeTab(),
      TabItem.search: (_) => SearchTab(),
      TabItem.library: (_) => LibraryTab(),
      TabItem.progress: (_) => ProgressTab(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return MiniplayerWillPopScope(
      onWillPop: () async {
        final NavigatorState navigator = _miniplayerNavigatorKey.currentState!;
        if (!navigator.canPop()) return true;
        navigator.pop();

        return false;
      },
      // Preventing from closing the app on Android
      child: WillPopScope(
        onWillPop: () async =>
            !await _tabNavigatorKeys[_currentTab]!.currentState!.maybePop(),
        child: Scaffold(
          body: Stack(
            children: [
              Stack(
                children: [
                  _buildOffstageNavigator(TabItem.home),
                  _buildOffstageNavigator(TabItem.search),
                  _buildOffstageNavigator(TabItem.progress),
                  _buildOffstageNavigator(TabItem.library),
                ],
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: ExpandableFAB(
            distance: 136,
          ),
          bottomNavigationBar: BottomNavigationTab(
            currentTab: _currentTab,
            onSelectTab: _selectTab,
          ),
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(TabItem tabItem) {
    return Offstage(
      offstage: _currentTab != tabItem,
      child: CupertinoTabView(
        navigatorKey: _tabNavigatorKeys[tabItem],
        builder: (context) => widgetBuilders[tabItem](context),
      ),
    );
  }
}
