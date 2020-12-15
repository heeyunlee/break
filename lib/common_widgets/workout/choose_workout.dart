import 'package:flutter/material.dart';

import '../../constants.dart';
import 'workout_card_listview.dart';
import 'workout_filter_button.dart';

class ChooseWorkout extends StatefulWidget {
  static const routeName = '/choose-workout';

  @override
  _ChooseWorkoutState createState() => _ChooseWorkoutState();
}

class _ChooseWorkoutState extends State<ChooseWorkout> {
  int _isAddedCount = 0;

  void _incrementCounter() {
    setState(() {
      _isAddedCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: BackgroundColor,
      // body: CustomFloatingSearchBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 0),
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
                      WorkoutFilterButton(filterName: '가슴'),
                      SizedBox(width: 16),
                      WorkoutFilterButton(filterName: '등'),
                      SizedBox(width: 16),
                      WorkoutFilterButton(filterName: '어깨'),
                      SizedBox(width: 16),
                      WorkoutFilterButton(filterName: '하체'),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      WorkoutFilterButton(filterName: '스쿼트'),
                      SizedBox(width: 16),
                      WorkoutFilterButton(filterName: '덤벨 운동'),
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
      ),
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
