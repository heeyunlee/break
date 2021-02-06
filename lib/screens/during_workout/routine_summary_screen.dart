import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/common_widgets/list_item_builder.dart';
import 'package:workout_player/constants.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/screens/home_tab/routine_history/activity_list_tile.dart';
import 'package:workout_player/screens/home_tab/routine_history/summary_row_widget.dart';
import 'package:workout_player/services/database.dart';

class RoutineSummaryScreen extends StatefulWidget {
  const RoutineSummaryScreen({Key key, this.routineHistory}) : super(key: key);

  final RoutineHistory routineHistory;

  static void show({
    BuildContext context,
    RoutineHistory routineHistory,
  }) async {
    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => RoutineSummaryScreen(
          routineHistory: routineHistory,
        ),
      ),
    );
  }

  @override
  _RoutineSummaryScreenState createState() => _RoutineSummaryScreenState();
}

class _RoutineSummaryScreenState extends State<RoutineSummaryScreen> {
  // For SliverApp to Work
  ScrollController _scrollController;
  bool lastStatus = true;

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (300 - kToolbarHeight);
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }
  // For SliverApp to Work

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      body: Stack(
        children: <Widget>[
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverApp(),
              _buildSliverBody(),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSliverApp() {
    final size = MediaQuery.of(context).size;

    // Date Formatting
    final timestamp = widget.routineHistory.workoutStartTime;
    final date = timestamp.toDate();
    final formattedDate = DateFormat.MMMMEEEEd().format(date);

    // Data
    final title = widget.routineHistory?.routineTitle ?? 'Title';
    final mainMuscleGroup = widget.routineHistory?.mainMuscleGroup[0] ?? 'Null';
    final secondMuscleGroup =
        widget.routineHistory?.secondMuscleGroup[0] ?? 'Null';

    return SliverAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.close_rounded,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      centerTitle: true,
      title: isShrink ? Text(title, style: Subtitle1) : null,
      backgroundColor: Colors.transparent,
      floating: false,
      pinned: true,
      snap: false,
      stretch: true,
      expandedHeight: size.height * 1 / 3,
      flexibleSpace: (isShrink)
          ? AppbarBlurBG()
          : FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.passthrough,
                children: <Widget>[
                  Image.network(
                    'https://miro.medium.com/max/14144/1*toyr_4D7HNbvnynMj5XjXw.jpeg',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        // begin: Alignment.center,
                        begin: Alignment(0.0, -0.5),
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          BackgroundColor,
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          'Here is your Workout Summary:',
                          style: Subtitle1.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.routineHistory.routineTitle,
                          maxLines: 1,
                          style:
                              Headline4.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Chip(
                              label: Text('$mainMuscleGroup Workout',
                                  style: ButtonText),
                              backgroundColor: PrimaryColor,
                            ),
                            SizedBox(width: 16),
                            Chip(
                              label: Text('$secondMuscleGroup Workout',
                                  style: ButtonText),
                              backgroundColor: PrimaryColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSliverBody() {
    final database = Provider.of<Database>(context);
    final size = MediaQuery.of(context).size;

    // Number Formatting
    final weights = widget.routineHistory.totalWeights;
    final duration = widget.routineHistory.totalDuration;
    final calories = widget.routineHistory.totalCalories;
    final f1 = NumberFormat('#,###.##');
    final f2 = NumberFormat('#,###');
    final formattedWeight = f1.format(weights);
    final formattedDuration = f1.format(duration);
    final formattedCalories = f2.format(calories);

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 16),
            Text(
              'Stats',
              style: Headline6.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 8),
            SummaryRowWidget(
              title: formattedWeight,
              subtitle: ' kg  Lifted',
              image:
                  'https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/271/person-lifting-weights_1f3cb-fe0f.png',
            ),
            SizedBox(height: 16),
            SummaryRowWidget(
              title: formattedDuration,
              subtitle: ' min  Spent',
              image:
                  'https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/271/stopwatch_23f1-fe0f.png',
            ),
            // SizedBox(height: 16),
            // SummaryRowWidget(
            //   title: formattedCalories,
            //   subtitle: ' Kcal  Burnt',
            //   image:
            //       'https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/271/fire_1f525.png',
            // ),
            SizedBox(height: 32),
            Divider(color: Grey700),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Activities',
                style: Headline6.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            StreamBuilder<List<RoutineWorkout>>(
              stream: database.routineWorkoutsStreamForHistory(
                widget.routineHistory,
              ),
              builder: (context, snapshot) {
                return ListItemBuilder<RoutineWorkout>(
                    snapshot: snapshot,
                    itemBuilder: (context, routineWorkout) {
                      final sets = routineWorkout.numberOfSets;
                      final totalWeights = routineWorkout.totalWeights;
                      final f1 = NumberFormat('#,###.##');
                      final formattedSets = f1.format(sets);
                      final formattedWeights = f1.format(totalWeights);
                      final subtitle = (routineWorkout.isBodyWeightWorkout &&
                              routineWorkout.totalWeights == 0)
                          ? '$formattedSets sets  •  Bodyweight'
                          : (routineWorkout.isBodyWeightWorkout)
                              ? '$formattedSets sets  •  Bodyweight + $formattedWeights kg'
                              : '$formattedSets sets  • $formattedWeights kg';

                      return ActivityListTile(
                        index: routineWorkout.index,
                        title: routineWorkout.workoutTitle,
                        subtitle: subtitle,
                      );
                    });
              },
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
