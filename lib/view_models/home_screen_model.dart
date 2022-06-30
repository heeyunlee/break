import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/features/widgets/widgets.dart';

class HomeScreenModel with ChangeNotifier {
  HomeScreenModel({required this.database});

  final Database database;

  double? _miniplayerMinHeight;

  double? get miniplayerMinHeight => _miniplayerMinHeight;

  set miniplayerMinHeight(double? height) {
    _miniplayerMinHeight = height;
    notifyListeners();
  }

  ValueNotifier<double>? valueNotifier;

  TabItem _currentTab = TabItem.move;
  int _currentTabIndex = 0;
  bool _isFirstStartup = true;
  late List<DateTime> _thisWeek;
  late List<String> _daysOfTheWeek;

  TabItem get currentTab => _currentTab;
  int get currentTabIndex => _currentTabIndex;
  bool get isFirstStartup => _isFirstStartup;
  List<DateTime> get thisWeek => _thisWeek;
  List<String> get daysOfTheWeek => _daysOfTheWeek;

  void setMiniplayerHeight(BuildContext context) {
    final safePadding = MediaQuery.of(context).padding.bottom;

    final newHeight = 64 + safePadding + 56;

    miniplayerMinHeight = newHeight;
    valueNotifier = ValueNotifier<double>(newHeight);
  }

  double getYOffset({
    required double min,
    required double max,
    required double value,
  }) {
    final percentage = (value - min) / (max - min);

    return kBottomNavigationBarHeight * percentage * 2;
  }

  Future<bool> onWillPopHomeScreen() async {
    final state = tabNavigatorKeys[_currentTab]!.currentState!;

    if (!state.canPop()) return true;
    state.pop();

    return false;
  }

  void onSelectTab(int index) {
    final TabItem tabItem = TabItem.values[index];

    _currentTabIndex = index;

    if (tabItem != TabItem.empty) {
      final NavigatorState state = tabNavigatorKeys[tabItem]!.currentState!;

      if (tabItem == _currentTab) {
        if (state.canPop()) {
          state.popUntil((route) => route.isFirst);
          notifyListeners();
        }
      } else {
        _currentTab = tabItem;
        notifyListeners();
      }
    } else {
      HapticFeedback.mediumImpact();
    }
  }

  Future<void> updateUser(BuildContext context) async {
    try {
      final user = await database.getUserDocument(database.uid!);

      if (user != null) {
        final now = Timestamp.now();

        final userData = {
          'lastAppOpenedTime': now,
        };

        await database.updateUser(database.uid!, userData);
      }
    } on FirebaseException catch (e) {
      _showErrorDialog(e, context);
    }
  }

  void toggleIsFirstStartup() {
    _isFirstStartup = !_isFirstStartup;
  }

  void _showErrorDialog(FirebaseException exception, BuildContext context) {
    showExceptionAlertDialog(
      context,
      title: S.current.errorOccuredMessage,
      exception: exception.message ?? S.current.errorOccuredMessage,
    );
  }

  void popUntilRoot(BuildContext context) {
    final currentState = tabNavigatorKeys[_currentTab]!.currentState;

    Navigator.of(context).popUntil((route) => route.isFirst);
    currentState?.popUntil((route) => route.isFirst);
  }

  static final Map<TabItem, GlobalKey<NavigatorState>> tabNavigatorKeys = {
    TabItem.move: GlobalKey<NavigatorState>(),
    TabItem.eat: GlobalKey<NavigatorState>(),
    TabItem.expore: GlobalKey<NavigatorState>(),
    TabItem.library: GlobalKey<NavigatorState>(),
  };

  static final GlobalKey<NavigatorState> homeScreenNavigatorKey =
      GlobalKey<NavigatorState>();

  static final GlobalKey<NavigatorState> miniplayerNavigatorKey =
      GlobalKey<NavigatorState>();
}
