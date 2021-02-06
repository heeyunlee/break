import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/common_widgets/empty_content.dart';
import 'package:workout_player/common_widgets/list_item_builder.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/screens/settings/settings_screen.dart';
import 'package:workout_player/services/database.dart';

import '../../constants.dart';
import 'routine_history/daily_summary_card.dart';
import 'routine_history/daily_summary_detail_screen.dart';
import 'start_workout_shortcut_screen.dart';

class HomeTab extends StatefulWidget {
  static const routeName = '/home-tab';

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  Map<DateTime, List<RoutineHistory>> _events;
  DateTime _selectedDay = DateTime.now();
  List<RoutineHistory> _selectedEvents;
  AnimationController _animationController;
  // CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();
    // _calendarController = CalendarController();
  }

  @override
  void dispose() {
    // _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return Scaffold(
      backgroundColor: BackgroundColor,
      appBar: _buildAppBar(context),
      floatingActionButton: _buildFAB(),
      body: StreamBuilder<List<RoutineHistory>>(
        stream: database.routineHistoriesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Map<DateTime, List<String>> mapFetch = {};
            //
            // final List<RoutineHistory> routineHistories = snapshot.data;
            // final sorted = routineHistories.toList()
            //   ..sort((a, b) => a.workoutDate.compareTo(b.workoutDate));
            //
            // print(sorted);

            // for (var i = 0; i < routineHistories.length; i++) {
            //   mapFetch[routineHistories[i].workoutDate] = [];
            // }

            // print(_events);
            // print(mapFetch);

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  // TableCalendar(
                  //   events: _events,
                  //   // builders: CalendarBuilders(
                  //   //     selectedDayBuilder: (context, date, _) {
                  //   //   return DailySummaryCard();
                  //   // }),
                  //   daysOfWeekStyle: DaysOfWeekStyle(
                  //     weekdayStyle: BodyText2,
                  //   ),
                  //   calendarStyle: CalendarStyle(
                  //       todayColor: PrimaryColor,
                  //       selectedColor: PrimaryColor.withOpacity(0.6),
                  //       weekdayStyle: BodyText2,
                  //       outsideDaysVisible: false,
                  //       eventDayStyle: BodyText2,
                  //       holidayStyle: BodyText2,
                  //       outsideStyle: BodyText2,
                  //       markersColor: Colors.redAccent),
                  //   locale: 'en_US',
                  //   calendarController: _calendarController,
                  //   headerStyle: HeaderStyle(
                  //     leftChevronIcon: Icon(
                  //       Icons.arrow_back_ios_rounded,
                  //       color: Colors.white,
                  //       size: 16,
                  //     ),
                  //     centerHeaderTitle: true,
                  //     formatButtonVisible: false,
                  //     titleTextStyle: BodyText2,
                  //     rightChevronIcon: Icon(
                  //       Icons.arrow_forward_ios_rounded,
                  //       color: Colors.white,
                  //       size: 16,
                  //     ),
                  //   ),
                  // ),
                  // WorkoutSummaryWithPageControlScreen(),
                  SizedBox(height: 16),
                  _workoutDailySummaryBuilder(),
                  SizedBox(height: 16),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            // print(snapshot.error);
            return EmptyContent(
              message: 'Errorr',
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      flexibleSpace: AppbarBlurBG(),
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: Text('Player H', style: Subtitle1),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.settings_rounded),
          onPressed: () {
            pushNewScreen(
              context,
              screen: SettingsScreen(),
              pageTransitionAnimation: PageTransitionAnimation.cupertino,
            );
          },
        ),
        SizedBox(width: 4),
      ],
    );
  }

  Widget _workoutDailySummaryBuilder() {
    final database = Provider.of<Database>(context, listen: false);

    return StreamBuilder<List<RoutineHistory>>(
      stream: database.routineHistoriesStream(),
      builder: (context, snapshot) {
        return ListItemBuilder<RoutineHistory>(
          emptyContentTitle: 'Start Working Out Today!',
          snapshot: snapshot,
          itemBuilder: (context, routineHistory) => DailySummaryCard(
            date: routineHistory.workoutStartTime,
            workoutTitle: routineHistory.routineTitle,
            weightsLifted: routineHistory.totalWeights,
            caloriesBurnt: routineHistory.totalCalories,
            totalDuration: routineHistory.totalDuration,
            earnedBadges: routineHistory.earnedBadges,
            onTap: () {
              HapticFeedback.mediumImpact();
              print('card was tapped');
              DailySummaryDetailScreen.show(
                context: context,
                // index: index,
                routineHistory: routineHistory,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton.extended(
      backgroundColor: PrimaryColor,
      icon: Icon(
        Icons.play_arrow_rounded,
        color: Colors.white,
      ),
      label: Text('Start Workout!'),
      onPressed: () => StartWorkoutShortcutScreen.show(
        context: context,
      ),
    );
  }
}
