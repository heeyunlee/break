import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';

// enum TabItem { progress, search, library, settings }
enum TabItem { progress, search, watch, library }

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
    TabItem.progress: TabItemData(
      label: S.current.progress,
      selectedIcon: Icons.equalizer_rounded,
      size: 24,
    ),
    TabItem.search: TabItemData(
      label: S.current.search,
      selectedIcon: Icons.search_rounded,
      size: 24,
      rightPadding: 32,
    ),
    TabItem.library: TabItemData(
      label: S.current.library,
      selectedIcon: Icons.collections_bookmark_rounded,
      size: 24,
    ),
    TabItem.watch: TabItemData(
      label: 'Watch',
      selectedIcon: Icons.smart_display_rounded,
      size: 24,
      leftPadding: 32,
    ),
    // TabItem.settings: TabItemData(
    //   label: S.current.settingsScreenTitle,
    //   selectedIcon: Icons.settings_rounded,
    //   size: 24,
    // ),
  };
}
