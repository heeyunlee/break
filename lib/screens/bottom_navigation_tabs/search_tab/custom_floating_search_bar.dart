import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

import '../../../constants.dart';
import 'search_screen_body.dart';

class CustomFloatingSearchBar extends StatefulWidget {
  @override
  _CustomFloatingSearchBarState createState() =>
      _CustomFloatingSearchBarState();
}

class _CustomFloatingSearchBarState extends State<CustomFloatingSearchBar> {
  final controller = FloatingSearchBarController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FloatingSearchBar(
        leadingActions: [SizedBox(width: 0)],
        margins: EdgeInsets.all(16),
        padding: EdgeInsets.all(0),
        controller: controller,
        borderRadius: BorderRadius.circular(10),
        backdropColor: BackgroundColor,
        hint: '운동을 검색해보세요!',
        transitionDuration: const Duration(milliseconds: 300),
        physics: const BouncingScrollPhysics(),
        transitionCurve: Curves.easeInOutCubic,
        debounceDelay: const Duration(milliseconds: 300),
        builder: (context, _) => _buildExpandableBody(),
        body: SearchScreenBody(),
      ),
    );
  }

  Widget _buildExpandableBody() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('workouts').snapshots(),
      builder: (context, workoutSnapshot) {
        if (workoutSnapshot.connectionState == ConnectionState.waiting) {
          return CupertinoActivityIndicator();
        }

        final workoutDocs = workoutSnapshot.data.documents;
        return Column(
          children: [
            // Container(
            //   color: Colors.white,
            //   height: 64,
            // ),
            // ListView.builder(
            //   padding: EdgeInsets.all(0),
            //   shrinkWrap: true,
            //   physics: NeverScrollableScrollPhysics(),
            //   itemCount: workoutDocs.length,
            //   itemBuilder: (context, index) => WorkoutSmallCard(
            //     workoutDocs[index]['title'],
            //     key: ValueKey(workoutDocs[index].documentID),
            //   ),
            // ),
          ],
        );
      },
    );
  }
}
