import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/styles/text_styles.dart';

import 'tab_item.dart';

class BottomNavigationTab extends ConsumerWidget {
  const BottomNavigationTab({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(homeScreenModelProvider);

    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return ValueListenableBuilder<double>(
      valueListenable: model.valueNotifier!,
      builder: (context, height, child) => Transform.translate(
        offset: Offset(
          0.0,
          model.getYOffset(
            min: model.miniplayerMinHeight!,
            max: size.height,
            value: model.valueNotifier!.value,
          ),
        ),
        child: child,
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
          unselectedFontSize: 0,
          selectedFontSize: 10,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          unselectedItemColor: Colors.white,
          currentIndex: model.currentTabIndex,
          selectedLabelStyle: TextStyles.overlinW900,
          selectedItemColor: theme.primaryColor,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            _buildItem(TabItem.move),
            _buildItem(TabItem.eat),
            _buildItem(TabItem.empty),
            _buildItem(TabItem.expore),
            _buildItem(TabItem.library),
          ],
          onTap: model.onSelectTab,
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    final itemData = TabItemData.allTabs[tabItem]!;

    return BottomNavigationBarItem(
      label: itemData.label,
      icon: (itemData.selectedIcon != null)
          ? Icon(
              itemData.selectedIcon as IconData,
              size: itemData.size,
            )
          : Container(),
    );
  }
}
