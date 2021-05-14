import 'package:flutter/material.dart';
import 'package:workout_player/constants.dart';
import 'package:workout_player/screens/tab_item.dart';

class BottomNavigationTab extends StatelessWidget {
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  BottomNavigationTab({
    required this.currentTab,
    required this.onSelectTab,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedLabelStyle: kCaption1Primary,
        unselectedLabelStyle: kCaption1,
        backgroundColor: Color(0xff1C1C1C),
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          _buildItem(TabItem.home),
          _buildItem(TabItem.search),
          _buildItem(TabItem.progress),
          _buildItem(TabItem.library),
        ],
        onTap: (index) => onSelectTab(
          TabItem.values[index],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    final itemData = TabItemData.allTabs[tabItem]!;
    final color = currentTab == tabItem ? kPrimaryColor : Colors.white;

    return BottomNavigationBarItem(
      icon: (itemData.isIconPNG)
          ? Padding(
              padding: EdgeInsets.only(
                left: itemData.leftPadding,
                right: itemData.rightPadding,
              ),
              child: Image.asset(
                itemData.selectedIcon,
                width: 20,
                height: 20,
                color: color,
              ),
            )
          : Padding(
              padding: EdgeInsets.only(
                left: itemData.leftPadding,
                right: itemData.rightPadding,
              ),
              child: Icon(
                itemData.selectedIcon,
                color: color,
                size: itemData.size,
              ),
            ),
      label: itemData.label,
    );
  }
}
