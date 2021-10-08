import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_player/view/widgets/home/indexed_home_tabs.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/home_screen_model.dart';
import 'package:workout_player/view_models/main_model.dart';

import 'miniplayer_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read(homeScreenModelProvider).updateUser(context);
    context.read(homeScreenModelProvider).setMiniplayerHeight();
  }

  @override
  Widget build(BuildContext context) {
    logger.d('[HomeScreen] building... ');

    return Stack(
      // return MiniplayerWillPopScope(
      //   onWillPop: context.read(homeScreenModelProvider).onWillPopMiniplayer,
      //   child: Stack(
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
      // ),
    );
  }
}
