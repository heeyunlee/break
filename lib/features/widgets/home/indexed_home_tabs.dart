import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/features/library/library_tab.dart';
import 'package:workout_player/features/screens/eats_tab.dart';
import 'package:workout_player/features/screens/move_tab.dart';
import 'package:workout_player/features/screens/explore_tab.dart';
import 'package:workout_player/view_models/home_screen_model.dart';

import 'tab_item.dart';

class IndexedHomeTabs extends ConsumerWidget {
  const IndexedHomeTabs({Key? key}) : super(key: key);

  Map<TabItem, Widget Function()> get widgetBuilders {
    return {
      TabItem.move: () => const MoveTab(),
      TabItem.eat: () => const EatsTab(),
      TabItem.empty: () => Container(),
      TabItem.expore: () => const ExploreTab(),
      TabItem.library: () => const LibraryTab(),
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(homeScreenModelProvider);

    return IndexedStack(
      index: model.currentTabIndex,
      children: TabItem.values.map((tabItem) {
        return WillPopScope(
          onWillPop: model.onWillPopHomeScreen,
          child: CupertinoTabView(
            navigatorKey: HomeScreenModel.tabNavigatorKeys[tabItem],
            builder: (context) => widgetBuilders[tabItem]!(),
          ),
        );
      }).toList(),
    );
  }
}
