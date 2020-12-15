import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'workout_small_card.dart';

class WorkoutCardListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('workouts').snapshots(),
        builder: (context, workoutSnapshot) {
          if (workoutSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final workoutDocs = workoutSnapshot.data.documents;
          return ListView.builder(
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: workoutDocs.length,
            itemBuilder: (context, index) => WorkoutSmallCard(
              workoutDocs[index]['title'],
              key: ValueKey(workoutDocs[index].documentID),
            ),
          );
        });
  }
}
