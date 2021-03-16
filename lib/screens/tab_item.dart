import 'package:flutter/material.dart';
import 'package:workout_player/my_flutter_app_icons.dart';

enum TabItem { explore, search, library, progress }

class TabItemData {
  const TabItemData({
    @required this.label,
    @required this.selectedIcon,
    this.isIconPNG,
    // @required this.unselectedIcon,
  });

  final String label;
  final dynamic selectedIcon;
  final bool isIconPNG;
  // final IconData unselectedIcon;

  static Map<TabItem, TabItemData> allTabs = {
    TabItem.explore: TabItemData(
      label: 'Explore',
      selectedIcon: Icons.home_rounded,
      isIconPNG: false,
      // unselectedIcon: Icons.home_outlined,
    ),
    TabItem.search: TabItemData(
        label: 'Search', selectedIcon: Icons.search_rounded, isIconPNG: false
        // unselectedIcon: Icons.search_rounded,
        ),
    TabItem.library: TabItemData(
      label: 'Your Gym',
      selectedIcon: 'assets/icons/workout_collection_icon.png',
      isIconPNG: true,
      // unselectedIcon: MyFlutterApp.workout_collection_icon_1,
    ),
    TabItem.progress: TabItemData(
      label: 'Progress',
      selectedIcon: Icons.bar_chart_rounded,
      isIconPNG: false,
      // unselectedIcon: Icons.bar_chart_outlined,
    ),
  };
}
