import 'package:flutter/material.dart';

import 'tab_item.dart';

double percentageFromValueInRange({required final double min, max, value}) {
  return (value - min) / (max - min);
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

// Home Screen Navigator Key
final GlobalKey<NavigatorState> homeScreenNavigatorKey =
    GlobalKey<NavigatorState>();

// Tab Navigator Keys
final Map<CustomTabItem, GlobalKey<NavigatorState>> tabNavigatorKeys = {
  CustomTabItem.library: GlobalKey<NavigatorState>(),
  CustomTabItem.search: GlobalKey<NavigatorState>(),
  CustomTabItem.progress: GlobalKey<NavigatorState>(),
  CustomTabItem.settings: GlobalKey<NavigatorState>(),
};
CustomTabItem currentTab = CustomTabItem.progress;
int currentTabIndex = 0;

// Miniplayer Navigator Keey
final GlobalKey<NavigatorState> miniplayerNavigatorKey =
    GlobalKey<NavigatorState>();

class HomeScreenModel with ChangeNotifier {
  double _gridHeight = 400;
  double _gridWidth = 200;

  double get gridHeight => _gridHeight;
  double get gridWidth => _gridWidth;

  void setGridSize(BuildContext context) {
    final appBarHeight = Scaffold.of(context).appBarMaxHeight!;
    final size = MediaQuery.of(context).size;

    _gridHeight = size.height - appBarHeight - 90;
    _gridWidth = size.width - 48;
  }
}
