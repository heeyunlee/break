import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../common_widgets/workout/workout_card_listview.dart';
import '../../../common_widgets/workout/workout_filter_button.dart';
import '../../../constants.dart';

class SearchScreenBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 64),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 64,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('오늘은', style: Headline5Bold),
                  SizedBox(width: 24),
                  Image.asset(
                    'images/leg.png',
                    height: 64,
                  ),
                  SizedBox(width: 24),
                  Text('뿌시는 날', style: Headline5Bold),
                ],
              ),
            ),
          ),
          SizedBox(height: 64),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    WorkoutFilterButton(
                      filterName: '가슴',
                      key: key,
                    ),
                    SizedBox(width: 16),
                    WorkoutFilterButton(
                      filterName: '등',
                      key: key,
                    ),
                    SizedBox(width: 16),
                    WorkoutFilterButton(
                      filterName: '어깨',
                      key: key,
                    ),
                    SizedBox(width: 16),
                    WorkoutFilterButton(
                      filterName: '하체',
                      key: key,
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    WorkoutFilterButton(
                      filterName: '스쿼트',
                      key: key,
                    ),
                    SizedBox(width: 16),
                    WorkoutFilterButton(
                      filterName: '덤벨 운동',
                      key: key,
                    ),
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
              '오늘의 추천 운동',
              style: BodyText2,
            ),
          ),
          WorkoutCardListView(),
          FlatButton(
            child: Text(
              '새로운 운동 추가하기',
              style: BodyText2,
            ),
            onPressed: () {},
          ),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}
