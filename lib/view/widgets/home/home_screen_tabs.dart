import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../view_models/home_screen_model.dart';
import '../../screens/library/library_tab.dart';
import '../../screens/progress_tab.dart';
import '../../screens/search_tab.dart';
import '../../screens/settings_tab.dart';
import 'tab_item.dart';

class HomeScreenTabs extends StatelessWidget {
  // final HomeScreenModel model;

  const HomeScreenTabs({
    Key? key,
    // required this.model,
  }) : super(key: key);

  Map<TabItem, dynamic> get widgetBuilders {
    return {
      TabItem.library: (_) => LibraryTab(),
      TabItem.search: (_) => SearchTab(),
      TabItem.progress: (_) => ProgressTab.create(),
      TabItem.settings: (_) => SettingsTab(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: context.read(homeScreenModelProvider).currentTabIndex,
      children: [
        _buildOffstageNavigator(context, TabItem.progress),
        _buildOffstageNavigator(context, TabItem.search),
        _buildOffstageNavigator(context, TabItem.library),
        _buildOffstageNavigator(context, TabItem.settings),
      ],
    );
  }

  Widget _buildOffstageNavigator(BuildContext context, TabItem tabItem) {
    return Offstage(
      offstage: context.read(homeScreenModelProvider).currentTab != tabItem,
      child: CupertinoTabView(
        navigatorKey: HomeScreenModel.tabNavigatorKeys[tabItem],
        builder: (context) => widgetBuilders[tabItem](context),
      ),
    );
  }
}
