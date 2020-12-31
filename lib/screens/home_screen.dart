import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import '../constants.dart';
import 'home_tab/home_tab.dart';
import 'library_tab/library_tab.dart';
import 'search_tab/search_tab.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PersistentTabController _controller;

  @override
  Widget build(BuildContext context) {
    _controller = PersistentTabController(initialIndex: 0);

    return PersistentTabView(
      context,
      controller: _controller,
      backgroundColor: Color(0xff1C1C1C),
      screens: _buildScreens(),
      items: _buildNavBar(),
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardShows: true,
      navBarStyle: NavBarStyle.simple,
      decoration: NavBarDecoration(colorBehindNavBar: Grey700),
      routeAndNavigatorSettings: RouteAndNavigatorSettings(
        routes: {
          HomeTab.routeName: (context) => HomeTab(),
          SearchTab.routeName: (context) => SearchTab(),
          LibraryTab.routeName: (context) => LibraryTab(),
        },
      ),
    );
  }

  List<Widget> _buildScreens() {
    return [
      HomeTab(),
      SearchTab(),
      LibraryTab(),
    ];
  }

  List<PersistentBottomNavBarItem> _buildNavBar() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home_rounded),
        activeColor: PrimaryColor,
        inactiveColor: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.search_rounded),
        activeColor: PrimaryColor,
        inactiveColor: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.fitness_center_rounded),
        activeColor: PrimaryColor,
        inactiveColor: Colors.white,
      ),
    ];
  }
}
