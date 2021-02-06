import 'package:flutter/material.dart';

import '../../constants.dart';
import 'search_screen_body.dart';

class SearchTab extends StatefulWidget {
  static const routeName = '/search';

  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
