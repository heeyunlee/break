import 'package:flutter/cupertino.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'home_screen_model.dart';
import 'library_tab/library_tab.dart';
import 'progress_tab/progress_tab.dart';
import 'search_tab/search_tab.dart';
import 'settings_tab/settings_tab.dart';
import 'tab_item.dart';

class HomeScreenTabs extends StatelessWidget {
  final HomeScreenModel model;

  const HomeScreenTabs({Key? key, required this.model}) : super(key: key);

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
    return Stack(
      children: [
        _buildOffstageNavigator(TabItem.progress, model),
        _buildOffstageNavigator(TabItem.search, model),
        _buildOffstageNavigator(TabItem.library, model),
        _buildOffstageNavigator(TabItem.settings, model),
      ],
    );
  }

  Widget _buildOffstageNavigator(TabItem tabItem, HomeScreenModel model) {
    return Offstage(
      offstage: model.currentTab != tabItem,
      child: CupertinoTabView(
        navigatorKey: model.tabNavigatorKeys[tabItem],
        builder: (context) => widgetBuilders[tabItem](context),
      ),
    );
  }
}
