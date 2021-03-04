import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/list_item_builder.dart';
import 'package:workout_player/constants.dart';
import 'package:workout_player/models/enum/unit_of_mass.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/screens/library_tab/activity/routine_history/activity_list_tile.dart';
import 'package:workout_player/screens/library_tab/activity/routine_history/summary_row_widget.dart';
import 'package:workout_player/services/database.dart';

class RoutineHistorySummaryScreen extends StatefulWidget {
  const RoutineHistorySummaryScreen({Key key, this.routineHistory})
      : super(key: key);

  final RoutineHistory routineHistory;

  static void show({
    BuildContext context,
    RoutineHistory routineHistory,
  }) async {
    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => RoutineHistorySummaryScreen(
          routineHistory: routineHistory,
        ),
      ),
    );
  }

  @override
  _RoutineHistorySummaryScreenState createState() =>
      _RoutineHistorySummaryScreenState();
}

class _RoutineHistorySummaryScreenState
    extends State<RoutineHistorySummaryScreen> with TickerProviderStateMixin {
  // For SliverApp to Work
  AnimationController _colorAnimationController;
  AnimationController _textAnimationController;
  Animation<Offset> _transTween;

  bool _scrollListener(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.vertical) {
      _colorAnimationController.animateTo(scrollInfo.metrics.pixels);

      _textAnimationController
          .animateTo((scrollInfo.metrics.pixels - 150) / 50);
      return true;
    }
    return false;
  }

  @override
  void initState() {
    _colorAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    _textAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    _transTween = Tween(begin: Offset(-10, 40), end: Offset(-10, 0))
        .animate(_textAnimationController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      body: NotificationListener<ScrollNotification>(
        onNotification: _scrollListener,
        child: Stack(
          children: <Widget>[
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildSliverApp(),
                _buildSliverBody(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSliverApp() {
    final size = MediaQuery.of(context).size;

    // Data
    final title = widget.routineHistory?.routineTitle ?? 'Title';
    final mainMuscleGroup = widget.routineHistory?.mainMuscleGroup ?? 'Null';
    final equipmentRequired =
        widget.routineHistory?.equipmentRequired[0] ?? 'Null';

    return AnimatedBuilder(
      animation: _colorAnimationController,
      builder: (context, child) => SliverAppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.close_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Transform.translate(
          offset: _transTween.value,
          child: Text(title, style: Subtitle1),
        ),
        backgroundColor: Colors.transparent,
        floating: false,
        pinned: true,
        snap: false,
        stretch: true,
        expandedHeight: size.height * 1 / 3,
        flexibleSpace: FlexibleSpaceBar(
          background: Stack(
            fit: StackFit.passthrough,
            children: <Widget>[
              Image.network(
                'https://miro.medium.com/max/14144/1*toyr_4D7HNbvnynMj5XjXw.jpeg',
                fit: BoxFit.cover,
              ),
              Container(
                decoration: const BoxDecoration(
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
                    const Text(
                      'Here is your Workout Summary:',
                      style: Subtitle1Bold,
                    ),
                    Text(
                      widget.routineHistory.routineTitle,
                      maxLines: 1,
                      style: Headline4Bold,
                    ),
                    Row(
                      children: [
                        Chip(
                          label: Text(
                            '$mainMuscleGroup Workout',
                            style: ButtonText,
                          ),
                          backgroundColor: PrimaryColor,
                        ),
                        const SizedBox(width: 16),
                        Chip(
                          label: Text(equipmentRequired, style: ButtonText),
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
      ),
    );
  }

  Widget _buildSliverBody() {
    final database = Provider.of<Database>(context);

    // Unit Of Mass
    final unit = UnitOfMass.values[widget.routineHistory.unitOfMass].label;

    // Number Formatting
    final weights = widget.routineHistory.totalWeights;
    final duration = widget.routineHistory.totalDuration;
    // final calories = widget.routineHistory.totalCalories;
    final f1 = NumberFormat('#,###');
    // final f2 = NumberFormat('#,###.##');
    final formattedWeight = f1.format(weights);
    final formattedDuration = f1.format(duration);
    // final formattedCalories = f2.format(calories);

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 16),
            const Text('Stats', style: Headline6w900),
            const SizedBox(height: 8),
            SummaryRowWidget(
              title: formattedWeight,
              subtitle: ' $unit  Lifted',
              imageUrl:
                  'https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/271/person-lifting-weights_1f3cb-fe0f.png',
            ),
            const SizedBox(height: 16),
            SummaryRowWidget(
              title: formattedDuration,
              subtitle: ' min  Spent',
              imageUrl:
                  'https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/271/stopwatch_23f1-fe0f.png',
            ),
            // SizedBox(height: 16),
            // SummaryRowWidget(
            //   title: formattedCalories,
            //   subtitle: ' Kcal  Burnt',
            //   image:
            //       'https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/271/fire_1f525.png',
            // ),
            const SizedBox(height: 32),
            const Divider(color: Grey700),
            const SizedBox(height: 16),
            const Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: const Text('Activities', style: Headline6w900),
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
                              ? '$formattedSets sets  •  Bodyweight + $formattedWeights $unit'
                              : '$formattedSets sets  • $formattedWeights $unit';

                      return ActivityListTile(
                        index: routineWorkout.index,
                        title: routineWorkout.workoutTitle,
                        subtitle: subtitle,
                      );
                    });
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
