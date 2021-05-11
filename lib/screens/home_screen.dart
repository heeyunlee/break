import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/screens/home_tab/home_tab.dart';
import 'package:workout_player/screens/progress_tab/progress_tab.dart';
import 'package:workout_player/screens/search_tab/search_tab.dart';
import 'package:workout_player/screens/tab_item.dart';
import 'package:workout_player/widgets/speed_dial_fab.dart';
import 'package:workout_player/widgets/speed_dial_fab2.dart';

import 'bottom_navigation_tab.dart';
import 'custom_bottom_app_bar.dart';
import 'library_tab/library_tab.dart';

ValueNotifier<Routine?> currentRoutine = ValueNotifier(null);

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TabItem _currentTab = TabItem.home;
  // FABItem _currentTab = FABItem.home;

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

  // void _selectTab(FABItem tabItem) {
  //   // Navigating to original Tab Screen when you press Nav Tab
  //   if (tabItem == _currentTab) {
  //     _tabNavigatorKeys[tabItem]!
  //         .currentState!
  //         .popUntil((route) => route.isFirst);
  //   } else {
  //     setState(() {
  //       _currentTab = tabItem;
  //     });
  //   }
  // }

  final Map<TabItem, GlobalKey<NavigatorState>> _tabNavigatorKeys = {
    TabItem.home: GlobalKey<NavigatorState>(),
    TabItem.search: GlobalKey<NavigatorState>(),
    // TabItem.create: GlobalKey<NavigatorState>(),
    TabItem.library: GlobalKey<NavigatorState>(),
    TabItem.progress: GlobalKey<NavigatorState>(),
    // TabItem.settings: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, dynamic> get widgetBuilders {
    return {
      TabItem.home: (_) => HomeTab(),
      TabItem.search: (_) => SearchTab(),
      // TabItem.create: (_) => SearchTab(),
      // TabItem.create: (_) => showModalBottomSheet(
      //     context: context,
      //     builder: (context) {
      //       return Container(
      //         height: 200,
      //         child: Center(
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             mainAxisSize: MainAxisSize.min,
      //             children: <Widget>[
      //               const Text('Modal BottomSheet'),
      //               ElevatedButton(
      //                 onPressed: () => Navigator.pop(context),
      //                 child: const Text('Close BottomSheet'),
      //               )
      //             ],
      //           ),
      //         ),
      //       );
      //     }),
      TabItem.library: (_) => LibraryTab(),
      TabItem.progress: (_) => ProgressTab(),
      // TabItem.settings: (_) => SettingsTab(),
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
                  // _buildOffstageNavigator(TabItem.create),
                  _buildOffstageNavigator(TabItem.progress),
                  _buildOffstageNavigator(TabItem.library),
                  // _buildOffstageNavigator(TabItem.settings),
                ],
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          // floatingActionButton: Align(
          //   alignment: Alignment(0, -0.9),
          //   child: SpeedDialFAB(),
          // ),
          floatingActionButton: Padding(
            padding: const EdgeInsets.all(0),
            child: SpeedDialFAB2(
              dials: [],
              distance: 96,
            ),
          ),
          // floatingActionButton: SpeedDialFAB(),
          // bottomNavigationBar: FABBottomAppBar(
          //   currentTab: _currentTab,
          //   onSelectTab: _selectTab,
          // ),
          // bottomNavigationBar: BottomAppBar(

          //   shape: CircularNotchedRectangle(),
          //   color: Colors.blueGrey,
          //   child: Row(
          //     mainAxisSize: MainAxisSize.max,
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: <Widget>[],
          //   ),
          // ),
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
