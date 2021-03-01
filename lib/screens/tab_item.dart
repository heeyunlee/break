import 'package:flutter/material.dart';

// enum TabItem { home, explore, library }
enum TabItem { home, library }

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
    // TabItem.explore: TabItemData(
    //   label: 'Explore',
    //   icon: Icons.fitness_center_rounded,
    // ),
    TabItem.library: TabItemData(
      label: 'Your Gym',
      icon: Icons.person,
    ),
  };
}
