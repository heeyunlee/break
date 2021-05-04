import 'package:flutter/material.dart';
import 'package:workout_player/constants.dart';
import 'package:workout_player/screens/tab_item.dart';

class BottomNavigation extends StatelessWidget {
  BottomNavigation({@required this.currentTab, @required this.onSelectTab});
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        _buildItem(TabItem.explore),
        _buildItem(TabItem.search),
        _buildItem(TabItem.progress),
        _buildItem(TabItem.library),
        _buildItem(TabItem.settings),
      ],
      onTap: (index) => onSelectTab(
        TabItem.values[index],
      ),
    );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    final itemData = TabItemData.allTabs[tabItem];
    final color = currentTab == tabItem ? PrimaryColor : Colors.white;

    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: (itemData.isIconPNG)
            ? Image.asset(
                itemData.selectedIcon,
                width: 20,
                height: 20,
                color: color,
              )
            : Icon(
                itemData.selectedIcon,
                color: color,
              ),
      ),
      label: itemData.label,
    );
  }
}
