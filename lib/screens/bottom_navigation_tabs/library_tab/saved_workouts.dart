import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../common_widgets/workout/create_new_workout_widget.dart';
import '../../../constants.dart';
import '../../details/workout_detail_screen.dart';

class SavedWorkout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 16),
          CreateNewWorkoutWidget(
            '새로운 운동 추가',
            () {},
          ),
          SizedBox(height: 4),
          StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('workouts').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final workoutDocs = snapshot.data.documents;
                return ListView.builder(
                  padding: EdgeInsets.all(0),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: workoutDocs.length,
                  itemBuilder: (context, index) => Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    // child: WorkoutListTile(
                    //   workoutDocs[index]['title'],
                    //   workoutDocs[index]['mainMuscleGroup'],
                    //   index,
                    // ),
                    child: ListTile(
                      // tileColor: CardColor,
                      // leading: ConstrainedBox(
                      //   constraints: BoxConstraints(
                      //       maxWidth: 56, maxHeight: 56, minHeight: 56, minWidth: 56),
                      //   child: Image.asset('images/leg.png'),
                      // ),
                      leading: Hero(
                        tag: 'heroTag$index',
                        child: Container(
                          width: 56,
                          height: 56,
                          child: Image.asset(
                              'images/place_holder_workout_playlist.png'),
                        ),
                      ),

                      title: Text(
                        workoutDocs[index]['title'],
                        style: BodyText1Bold,
                      ),
                      subtitle: Text(
                        workoutDocs[index]['mainMuscleGroup'],
                        style: BodyText2Light,
                      ),
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(WorkoutDetailScreen.routeName);
                        // Navigator.push(
                        //   context,
                        //   CupertinoPageRoute(
                        //     builder: (context) => WorkoutDetailScreen(index),
                        //   ),
                        // );
                      },
                      onLongPress: () {},
                    ),
                  ),
                );
              }),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
