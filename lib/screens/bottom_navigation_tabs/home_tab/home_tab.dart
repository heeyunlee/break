import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../common_widgets/workout/choose_workout.dart';
import '../../../constants.dart';
import '../../settings/settings_screen.dart';
import 'daily_summary.dart';
import 'overall_summary_with_page_control.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      appBar: BuildAppBar(
        context,
        '운동 플레이리스트',
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            WorkoutSummaryWithPageControlScreen(),
            SizedBox(height: 16),
            DailyWorkoutSummary('월요일 오전 운동', '11/9 월요일'),
            DailyWorkoutSummary('일요일 오후 운동', '11/8 일요일'),
            DailyWorkoutSummary('토요일 오전 운동', '11/7 토요일'),
            SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: CustomFAB(),
    );
  }

  Widget BuildAppBar(BuildContext context, String title) {
    return AppBar(
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25.0, sigmaY: 25.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.35)),
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: SvgPicture.asset('assets/icons/Icon-Info.svg'),
        onPressed: () {},
      ),
      title: Center(
        child: Text(title, style: Subtitle1),
      ),
      actions: <Widget>[
        IconButton(
          icon: SvgPicture.asset('assets/icons/Icon-Settings.svg'),
          onPressed: () {
            Navigator.of(context).pushNamed(SettingsScreen.routeName);
          },
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
        Navigator.of(context).pushNamed(ChooseWorkout.routeName);
        // Navigator.push(
        //   context,
        //   PageTransition(
        //     duration: Duration(milliseconds: 250),
        //     child: SearchTab(),
        //     type: PageTransitionType.bottomToTop,
        //   ),
        // );
      },
    );
  }
}
