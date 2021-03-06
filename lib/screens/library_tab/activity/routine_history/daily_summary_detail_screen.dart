import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/list_item_builder.dart';
import 'package:workout_player/common_widgets/max_width_raised_button.dart';
import 'package:workout_player/common_widgets/show_adaptive_modal_bottom_sheet.dart';
import 'package:workout_player/common_widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/constants.dart';
import 'package:workout_player/format.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import 'activity_list_tile.dart';
import 'summary_row_widget.dart';

Logger logger = Logger();

class DailySummaryDetailScreen extends StatefulWidget {
  const DailySummaryDetailScreen({
    Key key,
    @required this.database,
    @required this.auth,
    @required this.user,
    this.routineHistory,
  }) : super(key: key);

  final RoutineHistory routineHistory;
  final Database database;
  final AuthBase auth;
  final User user;

  static void show({
    BuildContext context,
    RoutineHistory routineHistory,
  }) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    final user = await database.userStream(userId: auth.currentUser.uid).first;
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => DailySummaryDetailScreen(
          routineHistory: routineHistory,
          database: database,
          auth: auth,
          user: user,
        ),
      ),
    );
  }

  @override
  _DailySummaryDetailScreenState createState() =>
      _DailySummaryDetailScreenState();
}

class _DailySummaryDetailScreenState extends State<DailySummaryDetailScreen>
    with TickerProviderStateMixin {
  FocusNode focusNode1;
  var _textController1 = TextEditingController();

  String _notes;

  // For SliverApp to Work
  AnimationController _colorAnimationController;
  AnimationController _textAnimationController;
  Animation _colorTween;
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
    super.initState();

    focusNode1 = FocusNode();
    _textController1 = TextEditingController(text: widget.routineHistory.notes);

    _colorAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    _textAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    _colorTween = ColorTween(begin: Colors.transparent, end: AppBarColor)
        .animate(_colorAnimationController);
    _transTween = Tween(begin: Offset(-10, 40), end: Offset(-10, 0))
        .animate(_textAnimationController);
  }

  @override
  void dispose() {
    _colorAnimationController.dispose();
    _textAnimationController.dispose();
    focusNode1.dispose();
    _textController1.dispose();
    super.dispose();
  }

  // Delete Routine Method
  Future<void> _delete(
      BuildContext context, RoutineHistory routineHistory) async {
    try {
      // Update User Data
      final user = {
        'totalWeights': widget.user.totalWeights - routineHistory.totalWeights,
        'totalNumberOfWorkouts': widget.user.totalNumberOfWorkouts - 1,
      };

      await widget.database.deleteRoutineHistory(routineHistory).then(
        (value) async {
          await widget.database.updateUser(widget.user.userId, user);
        },
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseException catch (e) {
      logger.d(e);
      await showExceptionAlertDialog(
        context,
        title: 'Operation Failed',
        exception: e,
      );
    }
  }

  //Update Notes
  Future<void> _submit() async {
    try {
      final routineHistory = {
        'notes': _notes,
      };
      await widget.database
          .updateRoutineHistory(widget.routineHistory, routineHistory);
    } on FirebaseException catch (e) {
      logger.d(e);
      await showExceptionAlertDialog(
        context,
        title: 'Operation Failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('scaffold building...');

    return Scaffold(
      backgroundColor: BackgroundColor,
      body: NotificationListener<ScrollNotification>(
        onNotification: _scrollListener,
        child: Stack(
          children: <Widget>[
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildSliverAppBar(context),
                _buildSliverBody(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Data Formatting
    final date = Format.date(widget.routineHistory.workoutStartTime);
    final title = widget.routineHistory?.routineTitle ?? 'Title';
    final mainMuscleGroup = widget.routineHistory?.mainMuscleGroup ?? 'Null';
    final equipmentRequired =
        widget.routineHistory?.equipmentRequired[0] ?? 'Null';

    return AnimatedBuilder(
      animation: _colorAnimationController,
      builder: (context, child) => SliverAppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Transform.translate(
          offset: _transTween.value,
          child: Text(title, style: Subtitle1),
        ),
        backgroundColor: _colorTween.value,
        floating: false,
        pinned: true,
        snap: false,
        stretch: true,
        expandedHeight: size.height / 3,
        flexibleSpace: FlexibleSpaceBar(
          background: Stack(
            fit: StackFit.passthrough,
            children: <Widget>[
              CachedNetworkImage(
                imageUrl: widget.routineHistory.imageUrl,
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
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
                    Text(date, style: Subtitle1Bold),
                    Text(
                      widget.routineHistory.routineTitle,
                      maxLines: 1,
                      style: Headline4Bold,
                      softWrap: false,
                      overflow: TextOverflow.fade,
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
    final routineHistory = widget.routineHistory;

    // FORMATTING
    final weights = Format.weights(routineHistory.totalWeights);
    final unit = Format.unitOfMass(routineHistory.unitOfMass);
    final duration = Format.durationInMin(routineHistory.totalDuration);

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 16),
            const Text('Quick Summary', style: Headline6w900),
            const SizedBox(height: 8),
            SummaryRowWidget(
              title: '$weights $unit',
              subtitle: ' Lifted',
              imageUrl:
                  'https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/271/person-lifting-weights_1f3cb-fe0f.png',
            ),
            const SizedBox(height: 16),
            SummaryRowWidget(
              title: '$duration min',
              subtitle: ' Spent',
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
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text('Activities', style: Headline6w900),
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
                    final weights = Format.weights(routineWorkout.totalWeights);
                    final subtitle = (routineWorkout.isBodyWeightWorkout &&
                            routineWorkout.totalWeights == 0)
                        ? '$sets sets  •  Bodyweight'
                        : (routineWorkout.isBodyWeightWorkout)
                            ? '$sets sets  •  Bodyweight + $weights $unit'
                            : '$sets sets  • $weights $unit';

                    return ActivityListTile(
                      index: routineWorkout.index,
                      title: routineWorkout.workoutTitle,
                      subtitle: subtitle,
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 32),
            const Divider(color: Grey700),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text('Notes', style: Headline6w900),
            ),
            const SizedBox(height: 8),
            Card(
              color: CardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  textInputAction: TextInputAction.done,
                  controller: _textController1,
                  style: BodyText2,
                  focusNode: focusNode1,
                  decoration: const InputDecoration(
                    hintText: 'Add Notes',
                    hintStyle: BodyText2Grey,
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
            const SizedBox(height: 48),
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
      title: const Text('Are you sure?'),
      message: const Text(
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
