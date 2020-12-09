import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

import '../search/search_screen_body.dart';
import 'workout_card_listview.dart';

class CustomFloatingSearchBar extends StatefulWidget {
  @override
  _CustomFloatingSearchBarState createState() =>
      _CustomFloatingSearchBarState();
}

class _CustomFloatingSearchBarState extends State<CustomFloatingSearchBar> {
  final controller = FloatingSearchBarController();

  @override
  Widget build(BuildContext context) {
    return FloatingSearchBar(
      padding: EdgeInsets.all(0),
      controller: controller,
      borderRadius: BorderRadius.circular(10),
      backdropColor: Colors.transparent,
      hint: '운동을 검색해보세요!',
      transitionDuration: const Duration(milliseconds: 300),
      physics: const BouncingScrollPhysics(),
      transitionCurve: Curves.easeInOutCubic,
      debounceDelay: const Duration(milliseconds: 300),
      builder: (context, _) => _buildExpandableBody(),
      body: SearchScreenBody(),
    );
  }

  Widget _buildExpandableBody() {
    return Material(
      color: Colors.black,
      elevation: 4.0,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        child: buildItem(context),
      ),
    );
  }

  Widget buildItem(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (BuildContext context, _) {
        return WorkoutCardListView();
      },
    );
  }
}
