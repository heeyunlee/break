import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/screens/home_tab/home_tab.dart';
import 'package:workout_player/screens/miniplayer/workout_miniplayer.dart';
import 'package:workout_player/screens/progress_tab/progress_tab.dart';
import 'package:workout_player/screens/search_tab/search_tab.dart';
import 'package:workout_player/screens/tab_item.dart';
import 'package:workout_player/widgets/speed_dial/expandable_fab.dart';

import 'bottom_navigation_tab.dart';
import 'library_tab/library_tab.dart';

// For Miniplayer
final GlobalKey<NavigatorState> miniplayerNavigatorKey =
    GlobalKey<NavigatorState>();
final selectedRoutineProvider =
    StateProvider.autoDispose<Routine?>((ref) => null);
final selectedRoutineWorkoutsProvider =
    StateProvider.autoDispose<List<RoutineWorkout>?>((ref) => null);
final miniplayerControllerProvider =
    StateProvider.autoDispose<MiniplayerController>(
  (ref) => MiniplayerController(),
);

class BoolNotifier extends ChangeNotifier {
  bool _isWorkoutPaused = false;
  bool get isWorkoutPaused => _isWorkoutPaused;

  void toggleBoolValue() {
    _isWorkoutPaused = !_isWorkoutPaused;
    notifyListeners();
  }

  void setBoolean(bool value) {
    _isWorkoutPaused = value;
    notifyListeners();
  }
}

final isWorkoutPausedProvider =
    ChangeNotifierProvider.autoDispose((ref) => BoolNotifier());

final double miniplayerMinHeight = 144.0;

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
                    child: WorkoutMiniplayer.create(context),
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
