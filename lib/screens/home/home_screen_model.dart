import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';
import 'package:provider/provider.dart' as provider;

import 'tab_item.dart';

double percentageFromValueInRange({required final double min, max, value}) {
  return (value - min) / (max - min);
}

final homeScreenModelProvider = ChangeNotifierProvider(
  (ref) => HomeScreenModel(),
);

class HomeScreenModel with ChangeNotifier {
  TabItem _currentTab = TabItem.progress;
  int _currentTabIndex = 0;
  final Map<TabItem, GlobalKey<NavigatorState>> _tabNavigatorKeys = {
    TabItem.library: GlobalKey<NavigatorState>(),
    TabItem.search: GlobalKey<NavigatorState>(),
    TabItem.progress: GlobalKey<NavigatorState>(),
    TabItem.settings: GlobalKey<NavigatorState>(),
  };

  TabItem get currentTab => _currentTab;
  int get currentTabIndex => _currentTabIndex;
  Map<TabItem, GlobalKey<NavigatorState>> get tabNavigatorKeys =>
      _tabNavigatorKeys;

  Future<bool> onWillPopMiniplayer() async {
    final state = miniplayerNavigatorKey.currentState!;

    if (!state.canPop()) return true;
    state.pop();

    return false;
  }

  Future<bool> onWillPopHomeScreen() async {
    final state = tabNavigatorKeys[_currentTab]!.currentState!.maybePop();

    final shouldPop = await state;

    return shouldPop;
  }

  void onSelectTab(int index, TabItem tabItem) {
    _currentTabIndex = index;

    if (tabItem == currentTab) {
      _tabNavigatorKeys[tabItem]!
          .currentState!
          .popUntil((route) => route.isFirst);
    } else {
      _currentTab = tabItem;
    }

    notifyListeners();
  }

  Future<void> updateUser(BuildContext context) async {
    final database = provider.Provider.of<Database>(context, listen: false);
    final auth = provider.Provider.of<AuthBase>(context, listen: false);

    try {
      final userData = {
        'lastAppOpenedTime': Timestamp.now(),
      };

      await database.updateUser(auth.currentUser!.uid, userData);
    } on FirebaseException catch (e) {
      logger.e(e.message);

      _showErrorDialog(e, context);
    }
  }

  void popUntilRoot(BuildContext context) {
    final currentState = _tabNavigatorKeys[_currentTab]!.currentState;

    Navigator.of(context).popUntil((route) => route.isFirst);
    currentState?.popUntil((route) => route.isFirst);
  }

  void _showErrorDialog(FirebaseException exception, BuildContext context) {
    logger.e(exception);

    showExceptionAlertDialog(
      context,
      title: S.current.errorOccuredMessage,
      exception: exception.message ?? S.current.errorOccuredMessage,
    );
  }

  // Home Screen Navigator Key
  final GlobalKey<NavigatorState> homeScreenNavigatorKey =
      GlobalKey<NavigatorState>();

  // Miniplayer navigator key
  final GlobalKey<NavigatorState> miniplayerNavigatorKey =
      GlobalKey<NavigatorState>();
}
