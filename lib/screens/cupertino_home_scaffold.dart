import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/screens/tab_item.dart';

import '../constants.dart';

class CupertinoHomeScaffold extends StatelessWidget {
  const CupertinoHomeScaffold({
    Key key,
    @required this.currentTab,
    @required this.onSelectedTab,
    @required this.widgetBuilder,
    @required this.navigatorKeys,
  }) : super(key: key);

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem, WidgetBuilder> widgetBuilder;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        activeColor: PrimaryColor,
        backgroundColor: Color(0xff1C1C1C),
        items: [
          _buildItem(TabItem.explore),
          _buildItem(TabItem.search),
          _buildItem(TabItem.library),
          _buildItem(TabItem.progress),
        ],
        onTap: (index) => onSelectedTab(TabItem.values[index]),
      ),
      tabBuilder: (context, index) {
        final item = TabItem.values[index];
        return CupertinoTabView(
          navigatorKey: navigatorKeys[item],
          builder: (context) => widgetBuilder[item](context),
        );
      },
    );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    final itemData = TabItemData.allTabs[tabItem];
    // final icon =
    //     currentTab == tabItem ? itemData.selectedIcon : itemData.unselectedIcon;
    final color = currentTab == tabItem ? PrimaryColor : Colors.white;
    return BottomNavigationBarItem(
      // label: itemData.label,
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
    );
  }
}
