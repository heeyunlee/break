import 'package:flutter/material.dart';

import '../constants.dart';
import '../widgets/search/custom_floating_search_bar.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      body: CustomFloatingSearchBar(),
      floatingActionButton: SizedBox(
        height: 56,
        child: FloatingActionButton.extended(
          label: Text('0개 운동 시작하기'),
          backgroundColor: PrimaryColor,
          icon: Icon(Icons.play_arrow_rounded),
          onPressed: () {},
        ),
      ),
    );
  }
}
