import 'package:flutter/material.dart';
import 'package:workout_player/screens/tab_item.dart';

import '../constants.dart';

enum FABItem { home, search, progress, library }

class FABItemData {
  final String label;
  final dynamic selectedIcon;
  final bool isIconPNG;

  FABItemData({
    required this.label,
    required this.selectedIcon,
    required this.isIconPNG,
  });

  static Map<FABItem, FABItemData> allFABTabs = {
    FABItem.home: FABItemData(
      label: 'Home',
      isIconPNG: false,
      selectedIcon: Icons.home_rounded,
    ),
    FABItem.search: FABItemData(
      label: 'Search',
      isIconPNG: false,
      selectedIcon: Icons.search_rounded,
    ),
    FABItem.progress: FABItemData(
      label: 'Progress',
      isIconPNG: false,
      selectedIcon: Icons.bar_chart_rounded,
    ),
    FABItem.library: FABItemData(
      label: 'Library',
      isIconPNG: true,
      selectedIcon: 'assets/icons/workout_collection_icon.png',
    ),
  };
}

class FABBottomAppBar extends StatelessWidget {
  final FABItem currentTab;
  final ValueChanged<FABItem> onSelectTab;

  const FABBottomAppBar({
    Key? key,
    required this.currentTab,
    required this.onSelectTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      color: Colors.blueGrey,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildItem(FABItem.home),
          _buildItem(FABItem.search),
          _buildItem(FABItem.progress),
          _buildItem(FABItem.library),
        ],
      ),
    );
  }

  Widget _buildItem(FABItem fabItem) {
    final itemData = FABItemData.allFABTabs[fabItem]!;
    final color = currentTab == fabItem ? PrimaryColor : Colors.white;

    return Expanded(
      child: SizedBox(
        height: 80,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: () {},
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (itemData.isIconPNG)
                    ? Image.asset(
                        itemData.selectedIcon,
                        width: 20,
                        height: 20,
                        color: color,
                      )
                    : Icon(itemData.selectedIcon, color: color, size: 20),
                Text(
                  itemData.label,
                  style: TextStyle(color: color),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget _buildTabItem({
  //   required FABBottomAppBarItem item,
  //   required int index,
  //   required ValueChanged<int> onPressed,
  // }) {
  //   Color color = _selectedIndex == index ? PrimaryColor : Colors.white;

  //   return Expanded(
  //     child: SizedBox(
  //       height: 80,
  //       child: Material(
  //         type: MaterialType.transparency,
  //         child: InkWell(
  //           onTap: () => onPressed(index),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: <Widget>[
  //               (item.isIconPNG)
  //                   ? Image.asset(
  //                       item.selectedIcon,
  //                       width: 20,
  //                       height: 20,
  //                       color: color,
  //                     )
  //                   : Icon(item.selectedIcon, color: color, size: 20),
  //               Text(
  //                 item.label,
  //                 style: TextStyle(color: color),
  //               )
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
