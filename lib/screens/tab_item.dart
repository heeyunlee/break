import 'package:flutter/material.dart';

enum TabItem { home, search, progress, library }

class TabItemData {
  const TabItemData({
    required this.label,
    @required this.selectedIcon,
    this.isIconPNG = false,
    this.size,
    required this.isTabButton,
    required this.leftPadding,
    required this.rightPadding,
  });

  final String label;
  final dynamic selectedIcon;
  final bool isIconPNG;
  final double? size;
  final bool isTabButton;
  final double leftPadding;
  final double rightPadding;

  static Map<TabItem, TabItemData> allTabs = {
    TabItem.home: TabItemData(
      label: 'Home',
      selectedIcon: Icons.home_rounded,
      isIconPNG: false,
      size: 24,
      isTabButton: false,
      leftPadding: 0,
      rightPadding: 16,
    ),
    TabItem.search: TabItemData(
      label: 'Search',
      selectedIcon: Icons.search_rounded,
      isIconPNG: false,
      size: 24,
      isTabButton: false,
      leftPadding: 0,
      rightPadding: 40,
    ),
    TabItem.progress: TabItemData(
      label: 'Progress',
      selectedIcon: Icons.bar_chart_rounded,
      isIconPNG: false,
      size: 24,
      isTabButton: false,
      leftPadding: 40,
      rightPadding: 0,
    ),
    TabItem.library: TabItemData(
      label: 'Library',
      selectedIcon: 'assets/icons/workout_collection_icon.png',
      isIconPNG: true,
      size: 24,
      isTabButton: false,
      leftPadding: 16,
      rightPadding: 0,
    ),
  };
}
