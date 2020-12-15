import 'package:flutter/material.dart';

import '../constants.dart';
import 'bottom_navigation_tabs/home_tab/home_tab.dart';
import 'bottom_navigation_tabs/library_tab/library_tab.dart';
import 'bottom_navigation_tabs/search_tab/search_tab.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [HomeTab(), SearchTab(), LibraryTab()];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        onTap: _onTap,
        currentIndex: _currentIndex,
        backgroundColor: Colors.grey.withOpacity(0.1),
        selectedItemColor: PrimaryColor,
        unselectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_rounded),
            label: '검색',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center_rounded),
            label: '내 기록',
          ),
        ],
      ),
    );
  }
}
