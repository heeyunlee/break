import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:workout_player/screens/miniplayer/workout_miniplayer.dart';
import 'package:workout_player/screens/speed_dial/widgets/speed_dial_widget.dart';

import 'bottom_navigation_tab.dart';
import 'home_screen_model.dart';
import 'home_screen_tabs.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final model = watch(homeScreenModelProvider);

    return MiniplayerWillPopScope(
      onWillPop: model.onWillPopMiniplayer,
      child: WillPopScope(
        onWillPop: model.onWillPopHomeScreen,
        child: Scaffold(
          key: model.homeScreenNavigatorKey,
          extendBody: true,
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              HomeScreenTabs(model: model),
              WorkoutMiniplayer.create(context),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: const SpeedDialWidget(),
          bottomNavigationBar: const BottomNavigationTab(),
        ),
      ),
    );
  }
}
