import 'package:flutter/material.dart';

enum TabItem { explore, search, library }
// enum TabItem { home, library }

class TabItemData {
  const TabItemData({
    @required this.label,
    @required this.icon,
  });

  final String label;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.explore: TabItemData(
      label: 'Explore',
      icon: Icons.home_rounded,
    ),
    TabItem.search: TabItemData(
      label: 'Search',
      icon: Icons.search_rounded,
    ),
    TabItem.library: TabItemData(
      label: 'Your Gym',
      icon: Icons.person,
    ),
  };
}
