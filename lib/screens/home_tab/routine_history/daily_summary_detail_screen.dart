import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/common_widgets/list_item_builder.dart';
import 'package:workout_player/common_widgets/max_width_raised_button.dart';
import 'package:workout_player/common_widgets/show_adaptive_modal_bottom_sheet.dart';
import 'package:workout_player/common_widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/common_widgets/show_flush_bar.dart';
import 'package:workout_player/constants.dart';
import 'package:workout_player/models/images.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/screens/home_tab/routine_history/activity_list_tile.dart';
import 'package:workout_player/screens/home_tab/routine_history/summary_row_widget.dart';
import 'package:workout_player/services/database.dart';

class DailySummaryDetailScreen extends StatefulWidget {
  const DailySummaryDetailScreen({Key key, this.routineHistory, this.database})
      : super(key: key);

  final RoutineHistory routineHistory;
  final Database database;

  static void show({
    BuildContext context,
    RoutineHistory routineHistory,
    Database database,
  }) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => DailySummaryDetailScreen(
          routineHistory: routineHistory,
          database: database,
        ),
      ),
    );
  }

  @override
  _DailySummaryDetailScreenState createState() =>
      _DailySummaryDetailScreenState();
}

class _DailySummaryDetailScreenState extends State<DailySummaryDetailScreen> {
  FocusNode focusNode1;
  var _textController1 = TextEditingController();

  String _notes;

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
    focusNode1 = FocusNode();
    _notes = widget.routineHistory.notes;
    _textController1 = TextEditingController(text: _notes);
  }

  @override
  void dispose() {
    focusNode1.dispose();
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }
  // For SliverApp to Work

  // Delete Routine Method
  Future<void> _delete(
      BuildContext context, RoutineHistory routineHistory) async {
    try {
      await widget.database.deleteRoutineHistory(routineHistory);
      Navigator.of(context).popUntil((route) => route.isFirst);
      showFlushBar(
        context: context,
        message: 'Routine Deleted',
      );
    } on FirebaseException catch (e) {
      ShowExceptionAlertDialog(
        context,
        title: 'Operation Failed',
        exception: e,
      );
    }
  }

  //Update Notes
  Future<void> _submit() async {
    final data = {
      'notes': _notes,
    };
    await widget.database.updateRoutineHistory(widget.routineHistory, data);
  }

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
    final imageIndex = widget.routineHistory?.imageIndex ?? 0;

    return SliverAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_rounded,
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
                  Image.asset(
                    ImageList[imageIndex],
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
                          '$formattedDate',
                          style: Subtitle1.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.routineHistory.routineTitle,
                          maxLines: 1,
                          style: Headline4.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          softWrap: false,
                          overflow: TextOverflow.fade,
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
              'Quick Summary',
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
            SizedBox(height: 32),
            Divider(color: Grey700),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Notes',
                style: Headline6.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            SizedBox(height: 8),
            Card(
              color: CardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              // child: Container(
              //   height: 104,
              //   width: size.width,
              //   child: Padding(
              //     padding: const EdgeInsets.all(16),
              //     child: Text(
              //       notes,
              //       style: BodyText2LightGrey,
              //       maxLines: 6,
              //     ),
              //   ),
              // ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  textInputAction: TextInputAction.done,
                  controller: _textController1,
                  style: BodyText2,
                  focusNode: focusNode1,
                  decoration: InputDecoration(
                    hintText: 'Add Notes',
                    hintStyle: BodyText2.copyWith(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                  onFieldSubmitted: (value) {
                    _notes = value;
                    _submit();
                  },
                  onChanged: (value) => _notes = value,
                  onSaved: (value) => _notes = value,
                ),
              ),
            ),
            SizedBox(height: 48),
            MaxWidthRaisedButton(
              color: Colors.red,
              buttonText: 'DELETE',
              onPressed: () async {
                await _showModalBottomSheet(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showModalBottomSheet(BuildContext context) {
    return showAdaptiveModalBottomSheet(
      context: context,
      title: Text('Are you sure?'),
      message: Text(
        'It will delete your data permanently. You can\'t undo this process',
      ),
      firstActionText: 'Delete History',
      isFirstActionDefault: false,
      firstActionOnPressed: () => _delete(context, widget.routineHistory),
      cancelText: 'Cancel',
      isCancelDefault: true,
    );
  }
}
