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
import 'miniplayer/provider/workout_miniplayer_provider.dart';

double percentageFromValueInRange({required final double min, max, value}) {
  return (value - min) / (max - min);
}

final Map<TabItem, GlobalKey<NavigatorState>> tabNavigatorKeys = {
  TabItem.home: GlobalKey<NavigatorState>(),
  TabItem.search: GlobalKey<NavigatorState>(),
  TabItem.library: GlobalKey<NavigatorState>(),
  TabItem.progress: GlobalKey<NavigatorState>(),
};
TabItem currentTab = TabItem.home;

// For Miniplayer
final GlobalKey<NavigatorState> miniplayerNavigatorKey =
    GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  MiniplayerController miniplayerController = MiniplayerController();

  void _selectTab(TabItem tabItem) {
    // Navigating to original Tab Screen when you press Nav Tab
    if (tabItem == currentTab) {
      tabNavigatorKeys[tabItem]!
          .currentState!
          .popUntil((route) => route.isFirst);
    } else {
      setState(() {
        currentTab = tabItem;
      });
    }
  }

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
        onWillPop: () async => !await tabNavigatorKeys[currentTab]!
            .currentState!
            .maybePop(), // Preventing from closing the app on Android
        child: Scaffold(
          extendBody: true,
          resizeToAvoidBottomInset: false,
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
                  );
                },
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Consumer(
            builder: (context, watch, child) {
              final selectedRoutine = watch(selectedRoutineProvider).state;

              if (selectedRoutine == null) {
                return ExpandableFAB(distance: 136);
              } else {
                return ValueListenableBuilder(
                  valueListenable: miniplayerExpandProgress,
                  builder:
                      (BuildContext context, double height, Widget? child) {
                    final size = MediaQuery.of(context).size;

                    final value = percentageFromValueInRange(
                      min: miniplayerMinHeight,
                      max: size.height,
                      value: height,
                    );

                    return Transform.translate(
                      offset:
                          Offset(0.0, kBottomNavigationBarHeight * value * 2),
                      child: ExpandableFAB(distance: 136),
                    );
                  },
                );
              }
            },
          ),
          bottomNavigationBar: Consumer(
            builder: (context, watch, child) {
              final selectedRoutine = watch(selectedRoutineProvider).state;

              if (selectedRoutine == null) {
                return BottomNavigationTab(
                  currentTab: currentTab,
                  onSelectTab: _selectTab,
                );
              } else {
                return ValueListenableBuilder(
                  valueListenable: miniplayerExpandProgress,
                  builder:
                      (BuildContext context, double height, Widget? child) {
                    final size = MediaQuery.of(context).size;

                    final value = percentageFromValueInRange(
                      min: miniplayerMinHeight,
                      max: size.height,
                      value: height,
                    );

                    return Transform.translate(
                      offset:
                          Offset(0.0, kBottomNavigationBarHeight * value * 2),
                      child: BottomNavigationTab(
                        currentTab: currentTab,
                        onSelectTab: _selectTab,
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(TabItem tabItem) {
    return Offstage(
      offstage: currentTab != tabItem,
      child: CupertinoTabView(
        navigatorKey: tabNavigatorKeys[tabItem],
        builder: (context) => widgetBuilders[tabItem](context),
      ),
    );
  }
}
