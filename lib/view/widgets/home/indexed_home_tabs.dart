import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/view/screens/library_tab.dart';
import 'package:workout_player/view/screens/eats_tab.dart';
import 'package:workout_player/view/screens/move_tab.dart';
import 'package:workout_player/view/screens/explore_tab.dart';
import 'package:workout_player/view_models/home_screen_model.dart';
import 'package:workout_player/view_models/main_model.dart';

import 'tab_item.dart';

class IndexedHomeTabs extends ConsumerWidget {
  const IndexedHomeTabs({Key? key}) : super(key: key);

  Map<TabItem, Widget Function()> get widgetBuilders {
    return {
      TabItem.move: () => MoveTab.create(),
      TabItem.eat: () => const EatsTab(),
      TabItem.empty: () => Container(),
      TabItem.expore: () => const ExploreTab(),
      TabItem.library: () => const LibraryTab(),
    };
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    logger.d('[IndexedHomeTabs] widget building');
    final model = watch(homeScreenModelProvider);

    return IndexedStack(
      index: model.currentTabIndex,
      children: TabItem.values.map((tabItem) {
        return CupertinoTabView(
          navigatorKey: HomeScreenModel.tabNavigatorKeys[tabItem],
          builder: (context) => widgetBuilders[tabItem]!(),
        );
      }).toList(),
    );
  }
}
