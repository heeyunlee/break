import 'package:flutter/cupertino.dart';
import 'package:workout_player/view/widgets/navigation_tab/tab_item.dart';

import '../../../view_models/home_screen_model.dart';
import '../../screens/library_tab.dart';
import '../../screens/progress_tab.dart';
import '../../screens/search_tab.dart';
import '../../screens/settings_tab.dart';

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
