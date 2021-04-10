import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/common_widgets/choice_chips_app_bar_widget.dart';
import 'package:workout_player/common_widgets/custom_list_tile_3.dart';
import 'package:workout_player/common_widgets/custom_stream_builder_widget.dart';
import 'package:workout_player/common_widgets/empty_content.dart';
import 'package:workout_player/common_widgets/list_item_builder.dart';
import 'package:workout_player/common_widgets/shimmer/list_view_shimmer.dart';
import 'package:workout_player/common_widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/format.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/equipment_required.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../../../constants.dart';

var logger = Logger();

class AddWorkoutsToRoutine extends StatefulWidget {
  const AddWorkoutsToRoutine({
    Key key,
    this.database,
    this.routine,
    this.auth,
  }) : super(key: key);

  final Database database;
  final Routine routine;
  final AuthBase auth;

  static void show(BuildContext context, {Routine routine}) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);

    await HapticFeedback.mediumImpact();
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => AddWorkoutsToRoutine(
          routine: routine,
          database: database,
          auth: auth,
        ),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _AddWorkoutsToRoutineState createState() => _AddWorkoutsToRoutineState();
}

class _AddWorkoutsToRoutineState extends State<AddWorkoutsToRoutine> {
  String _selectedChip;

  set string(String value) => setState(() => _selectedChip = value);

  String _selectedWorkoutId;
  String _selectedWorkoutTitle;
  bool _isBodyWeightWorkout;
  int _secondsPerRep;
  Map<String, dynamic> _translated;

  @override
  void initState() {
    super.initState();
    _selectedChip = widget.routine.mainMuscleGroup[0];
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      final routineWorkouts =
          await widget.database.routineWorkoutsStream(widget.routine).first;
      final index = routineWorkouts.length + 1;
      final id = documentIdFromCurrentDate();

      final routineWorkout = RoutineWorkout(
        routineWorkoutId: 'RW$id',
        workoutId: _selectedWorkoutId,
        routineId: widget.routine.routineId,
        routineWorkoutOwnerId: widget.auth.currentUser.uid,
        workoutTitle: _selectedWorkoutTitle,
        numberOfReps: 0,
        numberOfSets: 0,
        totalWeights: 0,
        index: index,
        sets: [],
        isBodyWeightWorkout: _isBodyWeightWorkout,
        duration: 0,
        secondsPerRep: _secondsPerRep,
        translated: _translated,
      );
      await widget.database.setRoutineWorkout(widget.routine, routineWorkout);
      Navigator.of(context).pop();
      // TODO: ADD SNACKBAR

    } on Exception catch (e) {
      logger.d(e);
      await showExceptionAlertDialog(
        context,
        title: 'Operation Failed',
        exception: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: BackgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              floating: true,
              pinned: true,
              snap: false,
              centerTitle: true,
              brightness: Brightness.dark,
              title: Text(S.current.addWorkoutButtonText, style: Subtitle1),
              flexibleSpace: AppbarBlurBG(),
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              bottom: ChoiceChipsAppBarWidget(
                callback: (value) {
                  setState(() {
                    _selectedChip = value;
                  });
                },
              ),
            ),
          ];
        },
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    final chip = (_selectedChip != 'All')
        ? MainMuscleGroup.values
            .firstWhere((e) => e.toString() == _selectedChip)
            .translation
        : '전부';

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: CustomStreamBuilderWidget(
        stream: (_selectedChip == 'All')
            ? database.workoutsStream()
            : database.workoutsSearchStream(
                searchCategory: 'mainMuscleGroup',
                arrayContains: _selectedChip,
              ),
        errorWidget: EmptyContent(),
        loadingWidget: ListViewShimmer(),
        hasDataWidget: (context, snapshot) => ListItemBuilder<Workout>(
          emptyContentTitle: S.current.noWorkoutEmptyContent(chip),
          snapshot: snapshot,
          itemBuilder: (context, workout) {
            final locale = Intl.getCurrentLocale();

            final difficulty = Format.difficulty(workout.difficulty);
            final leadingText = MainMuscleGroup.values
                .firstWhere((e) => e.toString() == workout.mainMuscleGroup[0])
                .translation;

            final equipment = EquipmentRequired.values
                .firstWhere((e) => e.toString() == workout.equipmentRequired[0])
                .translation;

            final title = (locale == 'ko' || locale == 'en')
                ? workout.translated[locale]
                : workout.workoutTitle;

            return CustomListTile3(
              imageUrl: workout.imageUrl,
              isLeadingDuration: false,
              leadingText: leadingText,
              title: title,
              subtitle: '$difficulty,  ${S.current.usingEquipment(equipment)}',
              onTap: () {
                setState(() {
                  _selectedWorkoutId = workout.workoutId;
                  _selectedWorkoutTitle = workout.workoutTitle;
                  _isBodyWeightWorkout = workout.isBodyWeightWorkout;
                  _secondsPerRep = workout.secondsPerRep ?? 3;
                  _translated = workout.translated;
                });
                _submit();
              },
            );
          },
        ),
      ),
    );
  }
}
