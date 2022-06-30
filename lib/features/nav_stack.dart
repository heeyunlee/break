import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/routes/app_routes.dart';
import 'package:workout_player/routes/nav_tab_item.dart';
import 'package:workout_player/features/screens/eats_tab.dart';
import 'package:workout_player/features/screens/explore_tab.dart';
import 'package:workout_player/features/library/library_tab.dart';
import 'package:workout_player/features/screens/move_tab.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view_models/home_screen_model.dart';

class NavStack extends ConsumerStatefulWidget {
  NavStack({required NavTabItem currentNavTab, Key? key})
      : index = NavTabItem.values.indexWhere((tab) => tab == currentNavTab),
        super(key: key) {
    assert(index != -1);
  }

  final int index;

  @override
  ConsumerState<NavStack> createState() => _NavStackState();
}

class _NavStackState extends ConsumerState<NavStack>
    with TickerProviderStateMixin {
  late int _currentTabIndex;

  @override
  void initState() {
    super.initState();
    _currentTabIndex = widget.index;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(NavStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    _currentTabIndex = widget.index;
  }

  Map<NavTabItem, Widget Function()> get widgetBuilders {
    return {
      NavTabItem.move: () => const MoveTab(),
      NavTabItem.eat: () => const EatsTab(),
      NavTabItem.expore: () => const ExploreTab(),
      NavTabItem.library: () => const LibraryTab(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(homeScreenModelProvider);
    final theme = Theme.of(context);
    const tabItems = NavTabItem.values;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: IndexedStack(
        index: _currentTabIndex,
        children: NavTabItem.values.map((tabItem) {
          return WillPopScope(
            // onWillPop: model.onWillPopHomeScreen,
            onWillPop: () async => true,
            child: CupertinoTabView(
              navigatorKey: HomeScreenModel.tabNavigatorKeys[tabItem],
              builder: (context) => widgetBuilders[tabItem]!(),
            ),
          );
        }).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedFontSize: 0,
        selectedFontSize: 10,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        unselectedItemColor: Colors.white,
        currentIndex: _currentTabIndex,
        selectedLabelStyle: TextStyles.overlinW900,
        selectedItemColor: theme.primaryColor,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          _buildItem(NavTabItem.move),
          _buildItem(NavTabItem.eat),
          _buildItem(NavTabItem.expore),
          _buildItem(NavTabItem.library),
        ],
        onTap: (index) {
          final tab = tabItems[index];

          context.goNamed(
            AppRoutes.app.name,
            extra: tab,
            params: {
              'navTab': tab.name,
            },
          );
        },
      ),
    );
  }

  BottomNavigationBarItem _buildItem(NavTabItem tabItem) {
    return BottomNavigationBarItem(
      label: tabItem.label,
      icon: Icon(
        tabItem.selectedIcon,
        size: tabItem.size.width,
      ),
    );
  }
}
