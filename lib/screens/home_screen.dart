import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';

import '../constants.dart';
import '../widgets/summary/daily_summary.dart';
import '../widgets/summary/overall_summary_with_page_control.dart';
import 'search_screen.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      appBar: buildAppBar('운동의 정석'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            WorkoutSummaryWithPageControlScreen(),
            SizedBox(height: 16),
            DailyWorkoutSummary('월요일 오전 운동', '11/9 월요일'),
            DailyWorkoutSummary('일요일 오후 운동', '11/8 일요일'),
            DailyWorkoutSummary('토요일 오전 운동', '11/7 토요일'),
          ],
        ),
      ),
      floatingActionButton: CustomFAB(),
    );
  }

  AppBar buildAppBar(String title) {
    return AppBar(
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.black26.withOpacity(0.1)),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: SvgPicture.asset('assets/icons/Icon-Info.svg'),
        onPressed: () {},
      ),
      title: Center(
        child: Text(
          title,
          style: TextStyle(
            fontFamily: 'NanumSquareRound',
            fontSize: 23,
            color: Colors.white,
          ),
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: SvgPicture.asset('assets/icons/Icon-Settings.svg'),
          onPressed: () {},
        ),
        SizedBox(width: 4),
      ],
    );
  }
}

class CustomFAB extends StatefulWidget {
  @override
  _CustomFABState createState() => _CustomFABState();
}

class _CustomFABState extends State<CustomFAB> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: PrimaryColor,
      child: IconButton(
        icon: Icon(
          Icons.add_rounded,
          color: Colors.white,
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          PageTransition(
            duration: Duration(milliseconds: 250),
            child: SearchScreen(),
            type: PageTransitionType.bottomToTop,
          ),
        );
      },
    );
  }
}
