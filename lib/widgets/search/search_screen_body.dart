import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import 'workout_card_listview.dart';

class SearchScreenBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 120),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 64,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('오늘은', style: Subtitle1Bold),
                  SizedBox(width: 24),
                  Image.asset(
                    'images/leg.png',
                    height: 64,
                  ),
                  SizedBox(width: 24),
                  Text('뿌시는 날', style: Subtitle1Bold),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    _workoutFilter('가슴', context),
                    SizedBox(width: 16),
                    _workoutFilter('등', context),
                    SizedBox(width: 16),
                    _workoutFilter('어깨', context),
                    SizedBox(width: 16),
                    _workoutFilter('하체', context),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    _workoutFilter('스쿼트', context),
                    SizedBox(width: 16),
                    _workoutFilter('덤벨 운동', context),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 36),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            child: Text(
              '추천 운동',
              style: BodyText2,
            ),
          ),
          WorkoutCardListView(),
          RaisedButton(
            child: Text(
              'or Add custom Workout',
              style: BodyText2,
            ),
            onPressed: () {},
          ),
          SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _workoutFilter(String title, BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Primary600Color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: CupertinoButton(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text(title, style: BodyText2),
        onPressed: () {},
      ),
    );
  }
}
