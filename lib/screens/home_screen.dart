import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:workout_player/screens/home_tab/home_tab.dart';
import 'package:workout_player/screens/progress_tab/progress_tab.dart';
import 'package:workout_player/screens/search_tab/search_tab.dart';
import 'package:workout_player/screens/tab_item.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/widgets/speed_dial/expandable_fab.dart';
import 'package:provider/provider.dart' as provider;

import 'bottom_navigation_tab.dart';
import 'library_tab/library_tab.dart';
import 'miniplayer/workout_miniplayer.dart';
import 'miniplayer/workout_miniplayer_provider.dart';

// For Miniplayer
final GlobalKey<NavigatorState> miniplayerNavigatorKey =
    GlobalKey<NavigatorState>();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabItem _currentTab = TabItem.home;

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
    final database = provider.Provider.of<Database>(context, listen: false);
    final auth = provider.Provider.of<AuthBase>(context, listen: false);
    final user = database.getUserDocument(auth.currentUser!.uid);

    return MiniplayerWillPopScope(
      onWillPop: () async {
        final NavigatorState navigator = miniplayerNavigatorKey.currentState!;
        if (!navigator.canPop()) return true;
        navigator.pop();

        return false;
      },
      child: WillPopScope(
        onWillPop: () async => !await _tabNavigatorKeys[_currentTab]!
            .currentState!
            .maybePop(), // Preventing from closing the app on Android
        child: Scaffold(
          extendBody: true,
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
              Consumer(
                builder: (context, watch, child) {
                  final selectedRoutine = watch(selectedRoutineProvider).state;

                  return Offstage(
                    offstage: selectedRoutine == null,
                    child: WorkoutMiniplayer(
                      database: database,
                      user: user,
                    ),
                    // child: WorkoutMiniplayer.create(context),
                  );
                },
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
