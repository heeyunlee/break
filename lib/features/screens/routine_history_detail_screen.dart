import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/features/widgets/watch/youtube_workout_list_tile.dart';
import 'package:workout_player/features/widgets/widgets.dart';

import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/models/workout_history.dart';
import 'package:workout_player/view_models/home_screen_model.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/widgets/widgets.dart';

List<WorkoutHistory> workoutHistories = [];

class RoutineHistoryDetailScreen extends ConsumerStatefulWidget {
  const RoutineHistoryDetailScreen({
    Key? key,
    required this.routineHistory,
  }) : super(key: key);

  final RoutineHistory routineHistory;

  static void show(
    BuildContext context, {
    required RoutineHistory routineHistory,
  }) {
    customPush(
      context,
      rootNavigator: false,
      builder: (context) => RoutineHistoryDetailScreen(
        routineHistory: routineHistory,
      ),
    );
  }

  @override
  ConsumerState<RoutineHistoryDetailScreen> createState() =>
      _RoutineHistoryDetailScreenState();
}

class _RoutineHistoryDetailScreenState
    extends ConsumerState<RoutineHistoryDetailScreen>
    with TickerProviderStateMixin {
  late FocusNode focusNode1;
  late TextEditingController _textController1;

  late String _notes;
  late bool _isPublic;

  late List<String> _musclesAndEquipment;

  // For SliverApp to Work
  late AnimationController _colorAnimationController;
  late AnimationController _textAnimationController;
  late Animation<Color?> _colorTween;
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

    final theme = Theme.of(context);

    _colorAnimationController =
        AnimationController(vsync: this, duration: Duration.zero);
    _textAnimationController =
        AnimationController(vsync: this, duration: Duration.zero);
    _colorTween = ColorTween(
      begin: Colors.transparent,
      end: theme.appBarTheme.backgroundColor,
    ).animate(_colorAnimationController);
    _transTween = Tween(begin: const Offset(-10, 40), end: const Offset(-10, 0))
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
      final database = ref.watch(databaseProvider);
      await database.deleteRoutineHistory(routineHistory);
      await database.batchDeleteWorkoutHistories(workoutHistories);

      final homeScreenModel = ref.read(homeScreenModelProvider);

      if (!mounted) return;

      homeScreenModel.popUntilRoot(context);

      // TODO(heeyunlee): add snackbar
      // getSnackbarWidget(
      //   S.current.deleteRoutineHistorySnackbarTitle,
      //   S.current.deleteRoutineHistorySnackbar,
      // );
    } on FirebaseException catch (e) {
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
      final database = ref.watch(databaseProvider);
      await database.updateRoutineHistory(
        widget.routineHistory,
        routineHistory,
      );

      // getSnackbarWidget(
      //   S.current.updateRoutineHistoryNotesSnackbarTitle,
      //   S.current.updateRoutineHistoryNotesSnackbar,
      // );
    } on FirebaseException catch (e) {
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
      await ref.read(databaseProvider).updateRoutineHistory(
            widget.routineHistory,
            routineHistory,
          );

      // getSnackbarWidget(
      //   S.current.isPublicRoutineHistorySnackbarTitle,
      //   _isPublic
      //       ? S.current.makeRoutineHistoryPublicSnackbar
      //       : S.current.makeRoutineHistoryPrivateSnackbar,
      // );
    } on FirebaseException catch (e) {
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }
  }

  void dataFormat(RoutineHistory routineHistory) {
    _musclesAndEquipment = Formatter.getListOfEquipments(
          routineHistory.equipmentRequired,
          routineHistory.equipmentRequiredEnum,
        ) +
        Formatter.getListOfMainMuscleGroup(
          routineHistory.mainMuscleGroup,
          routineHistory.mainMuscleGroupEnum,
        );
  }

  @override
  Widget build(BuildContext context) {
    dataFormat(widget.routineHistory);

    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: _scrollListener,
        child: CustomScrollView(
          slivers: [
            _buildSliverAppBar(context),
            _buildSliverBody(),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _colorAnimationController,
      builder: (context, child) => SliverAppBar(
        leading: const AppBarBackButton(),
        centerTitle: true,
        title: Transform.translate(
          offset: _transTween.value,
          child: Text(
            widget.routineHistory.routineTitle,
            style: TextStyles.subtitle2,
          ),
        ),
        backgroundColor: _colorTween.value,
        // floating: false,
        pinned: true,
        // snap: false,
        stretch: true,
        expandedHeight: size.height / 3,
        flexibleSpace: FlexibleSpaceBar(
          background: Stack(
            fit: StackFit.passthrough,
            children: <Widget>[
              AdaptiveCachedNetworkImage(
                imageUrl: widget.routineHistory.imageUrl,
                errorWidgetBuilder: (context, url, error) =>
                    const Icon(Icons.error),
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: const Alignment(0.0, -0.5),
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      theme.backgroundColor,
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
                      Formatter.date(widget.routineHistory.workoutStartTime),
                      style: TextStyles.subtitle1Bold,
                    ),
                    Text(
                      widget.routineHistory.routineTitle,
                      maxLines: 1,
                      style: TextStyles.headline4Bold,
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
    final theme = Theme.of(context);
    final database = ref.watch(databaseProvider);

    final routineHistory = widget.routineHistory;

    final notes = widget.routineHistory.notes ?? S.current.notesHintText;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 16),
            Text(S.current.quickSummary, style: TextStyles.headline6W900),
            const SizedBox(height: 8),
            if (routineHistory.routineHistoryType == null ||
                routineHistory.routineHistoryType == 'routine')
              SummaryRowWidget(
                title: Formatter.routineHistoryWeights(routineHistory),
                imageUrl:
                    'https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/271/person-lifting-weights_1f3cb-fe0f.png',
              ),

            SummaryRowWidget(
              title: Formatter.durationInMin(routineHistory.totalDuration),
              imageUrl:
                  'https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/271/stopwatch_23f1-fe0f.png',
            ),
            if (routineHistory.routineHistoryType == 'youtube')
              SummaryRowWidget(
                title: Formatter.numWithOrWithoutDecimal(
                  routineHistory.totalCalories,
                ),
                subtitle: ' Kcal  ${S.current.burnt}',
                imageUrl:
                    'https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/271/fire_1f525.png',
              ),
            const SizedBox(height: 32),
            Divider(color: Colors.grey[800]!),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(S.current.routines, style: TextStyles.headline6W900),
            ),
            _buildListView(),
            const SizedBox(height: 32),
            Divider(color: Colors.grey[800]!),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(S.current.notes, style: TextStyles.headline6W900),
            ),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: (widget.routineHistory.userId == database.uid)
                    ? TextFormField(
                        maxLines: 4,
                        textInputAction: TextInputAction.done,
                        controller: _textController1,
                        style: TextStyles.body2,
                        focusNode: focusNode1,
                        decoration: InputDecoration(
                          hintText: S.current.notesHintText,
                          hintStyle: TextStyles.body2Grey,
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
            if (widget.routineHistory.userId == database.uid)
              const SizedBox(height: 32),
            if (widget.routineHistory.userId == database.uid)
              Divider(color: Colors.grey[800]!),
            if (widget.routineHistory.userId == database.uid)
              const SizedBox(height: 16),
            if (widget.routineHistory.userId == database.uid)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    S.current.makeItVisibleTo,
                    style: TextStyles.body2Light,
                  ),
                  SizedBox(
                    width: 72,
                    child: Text(
                      _isPublic ? S.current.everyone : S.current.justMe,
                      style: TextStyles.body2W900,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _isPublic ? Icons.public_rounded : Icons.public_off_rounded,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  Switch(
                    value: _isPublic,
                    activeColor: theme.primaryColor,
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
            if (widget.routineHistory.userId == database.uid)
              const SizedBox(height: 24),
            if (widget.routineHistory.userId == database.uid)
              Divider(color: Colors.grey[800]!),
            if (widget.routineHistory.userId == database.uid)
              const SizedBox(height: 24),
            if (widget.routineHistory.userId == database.uid)
              MaxWidthRaisedButton(
                width: double.infinity,
                color: Colors.red,
                buttonText: S.current.delete,
                onPressed: () async {
                  await _showModalBottomSheet(
                    HomeScreenModel.homeScreenNavigatorKey.currentContext!,
                  );
                },
              ),
            const SizedBox(height: 160),
          ],
        ),
      ),
    );
  }

  Widget _buildListView() {
    if (widget.routineHistory.routineHistoryType == null ||
        widget.routineHistory.routineHistoryType == 'routine') {
      return CustomStreamBuilder<List<WorkoutHistory>>(
        stream: ref.read(databaseProvider).workoutHistoriesStream(
              widget.routineHistory.routineHistoryId,
            ),
        builder: (context, snapshot) {
          return CustomListViewBuilder<WorkoutHistory>(
            items: snapshot,
            itemBuilder: (context, workoutHistory, index) {
              workoutHistories = snapshot;

              return WorkoutHistoryCard(
                routineHistory: widget.routineHistory,
                workoutHistory: workoutHistory,
              );
            },
          );
        },
      );
    } else {
      return ListView.builder(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.routineHistory.youtubeWorkouts!.length,
        itemBuilder: (context, index) {
          return YoutubeWorkoutListTile(
            workout: widget.routineHistory.youtubeWorkouts![index],
          );
        },
      );
    }
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
              backgroundColor: Colors.redAccent,
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _showModalBottomSheet(BuildContext context) {
    return showAdaptiveModalBottomSheet(
      context,
      title: S.current.deleteBottomSheetTitle,
      message: S.current.deleteBottomSheetMessage,
      firstActionText: S.current.deleteBottomSheetkButtonText,
      isFirstActionDefault: false,
      firstActionOnPressed: () => _delete(context, widget.routineHistory),
      cancelText: S.current.cancel,
      isCancelDefault: true,
    );
  }
}
