import 'package:flutter/material.dart';
import 'package:workout_player/screens/tab_item.dart';

double percentageFromValueInRange({required final double min, max, value}) {
  return (value - min) / (max - min);
}

// Home Screen Navigator Key
final GlobalKey<NavigatorState> homeScreenNavigatorKey =
    GlobalKey<NavigatorState>();

// Tab Navigator Keys
final Map<CustomTabItem, GlobalKey<NavigatorState>> tabNavigatorKeys = {
  CustomTabItem.home: GlobalKey<NavigatorState>(),
  CustomTabItem.search: GlobalKey<NavigatorState>(),
  CustomTabItem.library: GlobalKey<NavigatorState>(),
  CustomTabItem.progress: GlobalKey<NavigatorState>(),
};
CustomTabItem currentTab = CustomTabItem.progress;

// Miniplayer Navigator Keey
final GlobalKey<NavigatorState> miniplayerNavigatorKey =
    GlobalKey<NavigatorState>();
