import 'package:flutter/material.dart';
import 'package:workout_player/constants.dart';
import 'package:workout_player/screens/tab_item.dart';

class BottomNavigationTab extends StatelessWidget {
  final CustomTabItem currentTab;
  final ValueChanged<CustomTabItem> onSelectTab;

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
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedLabelStyle: kCaption1Primary,
          unselectedLabelStyle: kCaption1,
          backgroundColor: kBottomNavBarColor,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            _buildItem(CustomTabItem.home),
            _buildItem(CustomTabItem.search),
            _buildItem(CustomTabItem.progress),
            _buildItem(CustomTabItem.library),
          ],
          onTap: (index) => onSelectTab(
            CustomTabItem.values[index],
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildItem(CustomTabItem tabItem) {
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
