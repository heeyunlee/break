import 'package:flutter/material.dart';

enum TabItem { home, search, library }

class TabItemData {
  const TabItemData({
    @required this.label,
    @required this.icon,
  });

  final String label;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.home: TabItemData(
      label: 'Home',
      icon: Icons.home_rounded,
    ),
    TabItem.search: TabItemData(
      label: 'Search',
      icon: Icons.search_rounded,
    ),
    TabItem.library: TabItemData(
      label: 'Library',
      icon: Icons.fitness_center_rounded,
    ),
  };
}
