import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:workout_player/screens/miniplayer/workout_miniplayer.dart';
import 'package:workout_player/screens/miniplayer/miniplayer_model.dart';
import 'package:workout_player/screens/speed_dial/widgets/speed_dial_widget.dart';

import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:provider/provider.dart' as provider;

import 'bottom_navigation_tab.dart';
import 'home_screen_provider.dart';
import 'library_tab/library_tab.dart';
import 'progress_tab/progress_tab.dart';
import 'search_tab/search_tab.dart';
import 'settings_tab/settings_tab.dart';
import 'tab_item.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
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

  void _selectTabIndex(int currentIndex) {
    setState(() {
      currentTabIndex = currentIndex;
    });
  }

  Map<CustomTabItem, dynamic> get widgetBuilders {
    return {
      CustomTabItem.library: (_) => LibraryTab(),
      CustomTabItem.search: (_) => SearchTab(),
      // CustomTabItem.progress: (_) => ProgressTab(),
      CustomTabItem.progress: (_) => ProgressTab.create(context),
      CustomTabItem.settings: (_) => SettingsTab(),
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
          key: homeScreenNavigatorKey,
          extendBody: true,
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              Stack(
                children: [
                  _buildOffstageNavigator(CustomTabItem.progress),
                  _buildOffstageNavigator(CustomTabItem.search),
                  _buildOffstageNavigator(CustomTabItem.library),
                  _buildOffstageNavigator(CustomTabItem.settings),
                ],
              ),
              Consumer(
                builder: (context, ref, child) {
                  final model = ref.watch(miniplayerModelProvider);

                  return Offstage(
                    offstage: model.selectedRoutine == null,
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
            builder: (context, ref, child) {
              final model = ref.watch(miniplayerModelProvider);

              if (model.selectedRoutine == null) {
                return SpeedDialWidget(distance: 136);
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
                      offset: Offset(
                        0,
                        kBottomNavigationBarHeight * value * 2,
                      ),
                      child: SpeedDialWidget(distance: 136),
                    );
                  },
                );
              }
            },
          ),
          bottomNavigationBar: Consumer(
            builder: (context, ref, child) {
              final model = ref.watch(miniplayerModelProvider);

              if (model.selectedRoutine == null) {
                return BottomNavigationTab(
                  currentTab: currentTab,
                  onSelectTab: _selectTab,
                  onSelectTabIndex: _selectTabIndex,
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
                      offset: Offset(
                        0.0,
                        kBottomNavigationBarHeight * value * 2,
                      ),
                      child: BottomNavigationTab(
                        currentTab: currentTab,
                        onSelectTab: _selectTab,
                        onSelectTabIndex: _selectTabIndex,
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
