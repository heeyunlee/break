import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';

enum TabItem { move, eat, empty, expore, library }

class TabItemData {
  final String label;
  final dynamic selectedIcon;
  final double? size;
  final double leftPadding;
  final double rightPadding;

  const TabItemData({
    required this.label,
    required this.selectedIcon,
    this.leftPadding = 0,
    this.rightPadding = 0,
    this.size,
  });

  static Map<TabItem, TabItemData> allTabs = {
    TabItem.move: TabItemData(
      label: S.current.move,
      selectedIcon: Icons.local_fire_department_outlined,
      size: 24,
    ),
    TabItem.eat: TabItemData(
      label: S.current.eat,
      selectedIcon: Icons.restaurant_rounded,
      size: 24,
    ),
    TabItem.empty: const TabItemData(
      label: '',
      selectedIcon: null,
      size: 24,
    ),
    TabItem.expore: TabItemData(
      label: S.current.explore,
      selectedIcon: Icons.explore_rounded,
      size: 24,
    ),
    TabItem.library: TabItemData(
      label: S.current.library,
      selectedIcon: Icons.collections_bookmark_rounded,
      size: 24,
    ),
  };
}
