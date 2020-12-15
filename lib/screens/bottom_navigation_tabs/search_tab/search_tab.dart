import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'search_screen_body.dart';

class SearchTab extends StatefulWidget {
  static const routeName = '/search';

  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  int _isAddedCount = 0;

  void _incrementCounter() {
    setState(() {
      _isAddedCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
      backgroundColor: BackgroundColor,
      // body: CustomFloatingSearchBar(),
      body: SearchScreenBody(),
      floatingActionButton: SizedBox(
        height: 56,
        child: FloatingActionButton.extended(
          label: Text('${_isAddedCount}개 운동 시작하기'),
          backgroundColor: PrimaryColor,
          icon: Icon(Icons.play_arrow_rounded),
          onPressed: () {},
        ),
      ),
    );
  }
}
