import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/common_widgets/custom_floating_action_button.dart';
import 'package:workout_player/common_widgets/list_item_builder.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/screens/settings/settings_screen.dart';
import 'package:workout_player/services/database.dart';

import '../../constants.dart';
import 'daily_summary_card.dart';
import 'daily_summary_detail_screen.dart';
import 'overall_summary_with_page_control.dart';

class HomeTab extends StatefulWidget {
  static const routeName = '/home-tab';

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      appBar: _buildAppBar(context),
      floatingActionButton: CustomFloatingActionButton(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            WorkoutSummaryWithPageControlScreen(),
            SizedBox(height: 16),
            _workoutDailySummaryBuilder(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return AppBar(
      flexibleSpace: AppbarBlurBG(),
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: Text('플레이어 H', style: Subtitle1),
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
          snapshot: snapshot,
          itemBuilder: (context, routineHistory) => DailySummaryCard(
            date: routineHistory.workedOutTime,
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
                index: index,
                routineHistory: routineHistory,
              );
            },
          ),
        );
      },
    );
  }
}
