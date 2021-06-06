import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';

enum CustomTabItem { progress, search, library, settings }
// enum CustomTabItem { progress, library }

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

  static Map<CustomTabItem, TabItemData> allTabs = {
    CustomTabItem.progress: TabItemData(
      label: S.current.progress,
      selectedIcon: Icons.equalizer_rounded,
      size: 24,
    ),
    CustomTabItem.search: TabItemData(
      label: S.current.search,
      selectedIcon: Icons.search_rounded,
      size: 24,
      rightPadding: 32,
    ),
    CustomTabItem.library: TabItemData(
      label: S.current.library,
      selectedIcon: Icons.collections_bookmark_rounded,
      size: 24,
      leftPadding: 32,
    ),
    CustomTabItem.settings: TabItemData(
      label: S.current.settingsScreenTitle,
      selectedIcon: Icons.settings_rounded,
      size: 24,
    ),
  };
}
