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
