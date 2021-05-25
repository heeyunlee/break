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
import 'package:workout_player/widgets/speed_dial/speed_dial_widget.dart';
import 'package:provider/provider.dart' as provider;

import 'bottom_navigation_tab.dart';
import 'library_tab/library_tab.dart';
import 'miniplayer/workout_miniplayer.dart';
import 'miniplayer/provider/workout_miniplayer_provider.dart';

double percentageFromValueInRange({required final double min, max, value}) {
  return (value - min) / (max - min);
}

final Map<CustomTabItem, GlobalKey<NavigatorState>> tabNavigatorKeys = {
  CustomTabItem.home: GlobalKey<NavigatorState>(),
  CustomTabItem.search: GlobalKey<NavigatorState>(),
  CustomTabItem.library: GlobalKey<NavigatorState>(),
  CustomTabItem.progress: GlobalKey<NavigatorState>(),
};
CustomTabItem currentTab = CustomTabItem.home;

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

  void _selectTab(CustomTabItem tabItem) {
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

  Map<CustomTabItem, dynamic> get widgetBuilders {
    return {
      CustomTabItem.home: (_) => HomeTab(),
      CustomTabItem.search: (_) => SearchTab(),
      CustomTabItem.library: (_) => LibraryTab(),
      CustomTabItem.progress: (_) => ProgressTab(),
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
        child: Consumer(
          builder: (context, watch, child) {
            // final selectedRoutine = watch(selectedRoutineProvider).state;
            final routine =
                watch(miniplayerProviderNotifierProvider).selectedRoutine;

            return Scaffold(
              extendBody: true,
              resizeToAvoidBottomInset: false,
              body: Stack(
                children: [
                  Stack(
                    children: [
                      _buildOffstageNavigator(CustomTabItem.home),
                      _buildOffstageNavigator(CustomTabItem.search),
                      _buildOffstageNavigator(CustomTabItem.progress),
                      _buildOffstageNavigator(CustomTabItem.library),
                    ],
                  ),
                  Offstage(
                    offstage: routine == null,
                    child: WorkoutMiniplayer(
                      database: database,
                      user: user,
                    ),
                  ),
                ],
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: (routine == null)
                  ? SpeedDialWidget(distance: 136)
                  : ValueListenableBuilder(
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
                          offset: Offset(
                            0,
                            kBottomNavigationBarHeight * value * 2,
                          ),
                          child: SpeedDialWidget(distance: 136),
                        );
                      },
                    ),
              bottomNavigationBar: (routine == null)
                  ? BottomNavigationTab(
                      currentTab: currentTab,
                      onSelectTab: _selectTab,
                    )
                  : ValueListenableBuilder(
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
                          offset: Offset(
                            0.0,
                            kBottomNavigationBarHeight * value * 2,
                          ),
                          child: BottomNavigationTab(
                            currentTab: currentTab,
                            onSelectTab: _selectTab,
                          ),
                        );
                      },
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOffstageNavigator(CustomTabItem tabItem) {
    return Offstage(
      offstage: currentTab != tabItem,
      child: CupertinoTabView(
        navigatorKey: tabNavigatorKeys[tabItem],
        builder: (context) => widgetBuilders[tabItem](context),
      ),
    );
  }
}
