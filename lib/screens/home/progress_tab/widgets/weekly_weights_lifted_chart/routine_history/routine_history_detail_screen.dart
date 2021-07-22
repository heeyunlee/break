import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/classes/enum/equipment_required.dart';
import 'package:workout_player/classes/enum/main_muscle_group.dart';
import 'package:workout_player/classes/routine_history.dart';
import 'package:workout_player/classes/user.dart';
import 'package:workout_player/classes/workout_history.dart';
import 'package:workout_player/screens/home/home_screen_model.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/widgets/custom_stream_builder_widget.dart';
import 'package:workout_player/widgets/get_snackbar_widget.dart';
import 'package:workout_player/widgets/list_item_builder.dart';
import 'package:workout_player/widgets/max_width_raised_button.dart';
import 'package:workout_player/widgets/show_adaptive_modal_bottom_sheet.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';

import 'summary_row_widget.dart';
import 'workout_history_card.dart';

List<WorkoutHistory> workoutHistories = [];

class RoutineHistoryDetailScreen extends StatefulWidget {
  const RoutineHistoryDetailScreen({
    Key? key,
    required this.database,
    required this.auth,
    required this.user,
    required this.routineHistory,
  }) : super(key: key);

  final RoutineHistory routineHistory;
  final Database database;
  final AuthBase auth;
  final Future<User?> user;

  static void show(
    context, {
    required RoutineHistory routineHistory,
    required Database database,
    required AuthBase auth,
    required Future<User?> user,
  }) async {
    await HapticFeedback.mediumImpact();
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => RoutineHistoryDetailScreen(
          routineHistory: routineHistory,
          database: database,
          auth: auth,
          user: user,
        ),
      ),
    );
  }

  @override
  _RoutineHistoryDetailScreenState createState() =>
      _RoutineHistoryDetailScreenState();
}

class _RoutineHistoryDetailScreenState extends State<RoutineHistoryDetailScreen>
    with TickerProviderStateMixin {
  late FocusNode focusNode1;
  late TextEditingController _textController1;

  late String _notes;
  late bool _isPublic;

  final List<dynamic> _translatedMuscleGroup = [];
  final List<dynamic> _translatedEquipments = [];
  late List<dynamic> _musclesAndEquipment;

  // For SliverApp to Work
  late AnimationController _colorAnimationController;
  late AnimationController _textAnimationController;
  late Animation _colorTween;
  late Animation<Offset> _transTween;

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
    _isPublic = widget.routineHistory.isPublic;

    _colorAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    _textAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    _colorTween = ColorTween(begin: Colors.transparent, end: kAppBarColor)
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
    BuildContext context,
    RoutineHistory routineHistory,
  ) async {
    try {
      await widget.database.deleteRoutineHistory(routineHistory);
      await widget.database.batchDeleteWorkoutHistories(workoutHistories);

      final homeScreenModel = context.read(homeScreenModelProvider);

      homeScreenModel.popUntilRoot(context);

      getSnackbarWidget(
        S.current.deleteRoutineHistorySnackbarTitle,
        S.current.deleteRoutineHistorySnackbar,
      );
    } on FirebaseException catch (e) {
      logger.e(e);
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }
  }

  //Update Notes
  Future<void> _updateNotes() async {
    try {
      final routineHistory = {
        'notes': _notes,
      };
      await widget.database.updateRoutineHistory(
        widget.routineHistory,
        routineHistory,
      );

      getSnackbarWidget(
        S.current.updateRoutineHistoryNotesSnackbarTitle,
        S.current.updateRoutineHistoryNotesSnackbar,
      );
    } on FirebaseException catch (e) {
      logger.e(e);
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }
  }

  //Update Notes
  Future<void> _updateIsPublic() async {
    try {
      final routineHistory = {
        'isPublic': _isPublic,
      };
      await widget.database.updateRoutineHistory(
        widget.routineHistory,
        routineHistory,
      );

      getSnackbarWidget(
        S.current.isPublicRoutineHistorySnackbarTitle,
        _isPublic
            ? S.current.makeRoutineHistoryPublicSnackbar
            : S.current.makeRoutineHistoryPrivateSnackbar,
      );
    } on FirebaseException catch (e) {
      logger.e(e);
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }
  }

  void dataFormat(RoutineHistory routineHistory) {
    final _mainMuscleGroups = routineHistory.mainMuscleGroup;
    _mainMuscleGroups.forEach(
      (element) {
        var translated = MainMuscleGroup.values
            .firstWhere((e) => e.toString() == element)
            .translation;
        _translatedMuscleGroup.add(translated);
      },
    );
    final _equipments = routineHistory.equipmentRequired;
    _equipments.forEach(
      (element) {
        var translated = EquipmentRequired.values
            .firstWhere((e) => e.toString() == element)
            .translation;
        _translatedEquipments.add(translated);
      },
    );

    _musclesAndEquipment = _translatedMuscleGroup + _translatedEquipments;
  }

  @override
  Widget build(BuildContext context) {
    logger.d('dailySummaryDetail screen scaffold building...');
    dataFormat(widget.routineHistory);

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: NotificationListener<ScrollNotification>(
          onNotification: _scrollListener,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverAppBar(context),
              _buildSliverBody(),
            ],
          )),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Data Formatting
    final date = Formatter.date(widget.routineHistory.workoutStartTime);
    final title = widget.routineHistory.routineTitle;

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
          child: Text(title, style: TextStyles.subtitle1),
        ),
        brightness: Brightness.dark,
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
                      kBackgroundColor,
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
                    Text(date, style: kSubtitle1Bold),
                    Text(
                      widget.routineHistory.routineTitle,
                      maxLines: 1,
                      style: TextStyles.headline4_bold,
                      softWrap: false,
                      overflow: TextOverflow.fade,
                    ),
                    // TODO: FIX HERE
                    _buildChips(),
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
    // final database = Provider.of<Database>(context);
    final routineHistory = widget.routineHistory;

    final notes = widget.routineHistory.notes ?? S.current.notesHintText;

    // FORMATTING
    final weights = Formatter.weights(routineHistory.totalWeights);
    final unit = Formatter.unitOfMass(routineHistory.unitOfMass);
    final duration = Formatter.durationInMin(routineHistory.totalDuration);

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 16),
            Text(S.current.quickSummary, style: TextStyles.headline6_w900),
            const SizedBox(height: 8),
            SummaryRowWidget(
              title: '$weights $unit',
              imageUrl:
                  'https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/271/person-lifting-weights_1f3cb-fe0f.png',
            ),
            const SizedBox(height: 16),
            SummaryRowWidget(
              title: '$duration ${S.current.minutes}',
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
            const Divider(color: kGrey800),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(S.current.routines, style: TextStyles.headline6_w900),
            ),
            CustomStreamBuilderWidget<List<WorkoutHistory>>(
              stream: widget.database.workoutHistoriesStream(
                widget.routineHistory.routineHistoryId,
              ),
              hasDataWidget: (context, snapshot) {
                return ListItemBuilder<WorkoutHistory>(
                  items: snapshot,
                  // snapshot: snapshot,
                  itemBuilder: (context, workoutHistory, index) {
                    workoutHistories = snapshot;

                    return WorkoutHistoryCard(
                      routineHistory: routineHistory,
                      workoutHistory: workoutHistory,
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 32),
            const Divider(color: kGrey800),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(S.current.notes, style: TextStyles.headline6_w900),
            ),
            const SizedBox(height: 8),
            Card(
              color: kCardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: (widget.routineHistory.userId ==
                        widget.auth.currentUser!.uid)
                    ? TextFormField(
                        maxLines: 4,
                        textInputAction: TextInputAction.done,
                        controller: _textController1,
                        style: TextStyles.body2,
                        focusNode: focusNode1,
                        decoration: InputDecoration(
                          hintText: S.current.notesHintText,
                          hintStyle: TextStyles.body2_grey,
                          border: InputBorder.none,
                        ),
                        onFieldSubmitted: (value) {
                          _notes = value;
                          _updateNotes();
                        },
                        onChanged: (value) => _notes = value,
                        onSaved: (value) => _notes = value!,
                      )
                    : SizedBox(
                        width: double.infinity,
                        height: 100,
                        child: Text(
                          notes,
                          style: TextStyles.body2,
                        ),
                      ),
              ),
            ),
            if (widget.routineHistory.userId == widget.auth.currentUser!.uid)
              const SizedBox(height: 32),
            if (widget.routineHistory.userId == widget.auth.currentUser!.uid)
              const Divider(color: kGrey800),
            if (widget.routineHistory.userId == widget.auth.currentUser!.uid)
              const SizedBox(height: 16),
            if (widget.routineHistory.userId == widget.auth.currentUser!.uid)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    S.current.makeItVisibleTo,
                    style: TextStyles.body2_light,
                  ),
                  SizedBox(
                    width: 72,
                    child: Text(
                      (_isPublic) ? S.current.everyone : S.current.justMe,
                      style: TextStyles.body2_w900,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    (_isPublic)
                        ? Icons.public_rounded
                        : Icons.public_off_rounded,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Switch(
                    value: _isPublic,
                    activeColor: kPrimaryColor,
                    onChanged: (bool value) {
                      HapticFeedback.mediumImpact();
                      setState(() {
                        _isPublic = value;
                        _updateIsPublic();
                      });
                    },
                  ),
                ],
              ),
            // TODO: Change this
            if (widget.routineHistory.userId == widget.auth.currentUser!.uid)
              const SizedBox(height: 24),
            if (widget.routineHistory.userId == widget.auth.currentUser!.uid)
              const Divider(color: kGrey800),
            if (widget.routineHistory.userId == widget.auth.currentUser!.uid)
              const SizedBox(height: 24),
            if (widget.routineHistory.userId == widget.auth.currentUser!.uid)
              MaxWidthRaisedButton(
                width: double.infinity,
                color: Colors.red,
                buttonText: S.current.delete,
                onPressed: () async {
                  final homeScreenModel = context.read(homeScreenModelProvider);
                  final homeContext =
                      homeScreenModel.homeScreenNavigatorKey.currentContext!;

                  await _showModalBottomSheet(homeContext);
                },
              ),
            const SizedBox(height: 160),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showModalBottomSheet(BuildContext context) {
    return showAdaptiveModalBottomSheet(
      context,
      title: Text(S.current.deleteBottomSheetTitle),
      message: Text(S.current.deleteBottomSheetMessage),
      firstActionText: S.current.deleteBottomSheetkButtonText,
      isFirstActionDefault: false,
      firstActionOnPressed: () => _delete(context, widget.routineHistory),
      cancelText: S.current.cancel,
      isCancelDefault: true,
    );
  }

  Widget _buildChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: List.generate(
          _musclesAndEquipment.length,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Chip(
              label: Text(
                _musclesAndEquipment[index],
                style: TextStyles.button1,
              ),
              backgroundColor: kPrimaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
