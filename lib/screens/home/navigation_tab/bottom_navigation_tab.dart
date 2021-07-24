import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

import '../home_screen_model.dart';
import '../miniplayer/miniplayer_model.dart';
import 'tab_item.dart';

class BottomNavigationTab extends StatelessWidget {
  const BottomNavigationTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: miniplayerExpandProgress,
      builder: (BuildContext context, double height, Widget? child) {
        final size = MediaQuery.of(context).size;

        final value = percentageFromValueInRange(
          min: miniplayerMinHeight,
          max: size.height,
          value: height,
        );

        return Transform.translate(
          offset: Offset(
            0.0,
            kBottomNavigationBarHeight * value * 2,
          ),
          child: Theme(
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
              child: Consumer(
                builder: (context, watch, child) {
                  final model = watch(homeScreenModelProvider);

                  return BottomNavigationBar(
                    showSelectedLabels: true,
                    showUnselectedLabels: true,
                    unselectedItemColor: Colors.white,
                    currentIndex: model.currentTabIndex,
                    selectedLabelStyle: TextStyles.overline_primary,
                    unselectedLabelStyle: TextStyles.overline,
                    backgroundColor: kBottomNavBarColor,
                    selectedItemColor: kPrimaryColor,
                    type: BottomNavigationBarType.fixed,
                    items: <BottomNavigationBarItem>[
                      _buildItem(TabItem.progress),
                      _buildItem(TabItem.search),
                      _buildItem(TabItem.library),
                      _buildItem(TabItem.settings),
                    ],
                    onTap: model.onSelectTab,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    final itemData = TabItemData.allTabs[tabItem]!;

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
          size: itemData.size,
        ),
      ),
    );
  }
}
