import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';

import 'navigation_tab/bottom_navigation_tab.dart';
import 'home_screen_model.dart';
import 'home_screen_tabs.dart';
import 'miniplayer/workout_miniplayer.dart';
import 'speed_dial/widgets/speed_dial_widget.dart';

class HomeScreen extends StatefulWidget {
  final HomeScreenModel model;

  const HomeScreen({Key? key, required this.model}) : super(key: key);

  static Widget create() {
    return Consumer(
      builder: (context, watch, child) => HomeScreen(
        model: watch(homeScreenModelProvider),
      ),
    );
  }

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    widget.model.updateUser(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MiniplayerWillPopScope(
      onWillPop: widget.model.onWillPopMiniplayer,
      child: WillPopScope(
        onWillPop: widget.model.onWillPopHomeScreen,
        child: Scaffold(
          key: widget.model.homeScreenNavigatorKey,
          extendBody: true,
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              HomeScreenTabs(model: widget.model),
              WorkoutMiniplayer.create(context),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: SpeedDialWidget.create(),
          bottomNavigationBar: const BottomNavigationTab(),
        ),
      ),
    );
  }
}
