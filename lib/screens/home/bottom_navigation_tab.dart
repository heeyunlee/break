import 'package:flutter/material.dart';
import 'package:workout_player/styles/constants.dart';

import 'home_screen_provider.dart';
import 'tab_item.dart';

class BottomNavigationTab extends StatelessWidget {
  final CustomTabItem currentTab;
  final ValueChanged<CustomTabItem> onSelectTab;
  final ValueChanged<int> onSelectTabIndex;

  BottomNavigationTab({
    required this.currentTab,
    required this.onSelectTab,
    required this.onSelectTabIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey[800]!,
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
            showSelectedLabels: true,
            showUnselectedLabels: true,
            unselectedItemColor: Colors.white,
            currentIndex: currentTabIndex,
            selectedLabelStyle: kOverlinePrimary,
            unselectedLabelStyle: kOverline,
            backgroundColor: kBottomNavBarColor,
            selectedItemColor: kPrimaryColor,
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              _buildItem(CustomTabItem.progress),
              _buildItem(CustomTabItem.search),
              _buildItem(CustomTabItem.library),
              _buildItem(CustomTabItem.settings),
            ],
            onTap: (index) {
              onSelectTabIndex(index);
              onSelectTab(CustomTabItem.values[index]);
            }),
      ),
    );
  }

  BottomNavigationBarItem _buildItem(CustomTabItem tabItem) {
    final itemData = TabItemData.allTabs[tabItem]!;
    // final color = currentTab == tabItem ? kPrimaryColor : Colors.white;

    return BottomNavigationBarItem(
      // ignore: deprecated_member_use
      title: Padding(
        padding: EdgeInsets.only(
          left: itemData.leftPadding,
          right: itemData.rightPadding,
        ),
        child: Text(itemData.label),
      ),
      icon: Padding(
        padding: EdgeInsets.only(
          left: itemData.leftPadding,
          right: itemData.rightPadding,
        ),
        child: Icon(
          itemData.selectedIcon,
          // color: color,
          size: itemData.size,
        ),
      ),
      // label: itemData.label,
    );
  }
}
