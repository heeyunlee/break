import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/providers.dart';

import 'package:workout_player/view/widgets/home/indexed_home_tabs.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/home_screen_model.dart';

import 'miniplayer_screen.dart';

class Home extends ConsumerStatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref.read(homeScreenModelProvider).updateUser(context);
    ref.read(homeScreenModelProvider).setMiniplayerHeight(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          resizeToAvoidBottomInset: false,
          extendBody: true,
          key: HomeScreenModel.homeScreenNavigatorKey,
          body: Stack(
            children: const [
              IndexedHomeTabs(),
              MiniplayerScreen(),
            ],
          ),
          bottomNavigationBar: const BottomNavigationTab(),
        ),
        SpeedDial.create(),
      ],
    );
  }
}
