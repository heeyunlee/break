import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart' as provider;

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/equipment_required.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/screens/home/library_tab/routine/add_workout/add_workouts_to_routine_model.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/widgets/appbar_blur_bg.dart';
import 'package:workout_player/widgets/custom_list_tile_3.dart';
import 'package:workout_player/widgets/custom_stream_builder_widget.dart';
import 'package:workout_player/widgets/empty_content.dart';
import 'package:workout_player/widgets/list_item_builder.dart';
import 'package:workout_player/widgets/shimmer/list_view_shimmer.dart';

class AddWorkoutsToRoutine extends StatefulWidget {
  final Routine routine;
  final AddWorkoutsToRoutineScreenModel model;

  const AddWorkoutsToRoutine({
    Key? key,
    required this.routine,
    required this.model,
  }) : super(key: key);

  static void show(BuildContext context, {required Routine routine}) async {
    await HapticFeedback.mediumImpact();
    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => Consumer(
          builder: (context, watch, child) => AddWorkoutsToRoutine(
            routine: routine,
            model: watch(addWorkoutsToRoutineScreenModelProvider),
          ),
        ),
      ),
    );
  }

  @override
  _AddWorkoutsToRoutineState createState() => _AddWorkoutsToRoutineState();
}

class _AddWorkoutsToRoutineState extends State<AddWorkoutsToRoutine> {
  @override
  void initState() {
    super.initState();
    widget.model.initSelectedChip(widget.routine);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kBackgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              floating: true,
              pinned: true,
              snap: false,
              centerTitle: true,
              brightness: Brightness.dark,
              title: Text(S.current.addWorkoutkButtonText, style: kSubtitle1),
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
              bottom: _appBarWidget(context),
            ),
          ];
        },
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final database = provider.Provider.of<Database>(context, listen: false);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: CustomStreamBuilderWidget<List<Workout>>(
        stream: (widget.model.selectedMainMuscleGroup == 'All')
            ? database.workoutsStream()
            : database.workoutsSearchStream(
                arrayContainsVariableName: 'mainMuscleGroup',
                arrayContainsValue: widget.model.selectedMainMuscleGroup,
              ),
        errorWidget: EmptyContent(),
        loadingWidget: ListViewShimmer(),
        hasDataWidget: (context, data) => ListItemBuilder<Workout>(
          items: data,
          emptyContentTitle: S.current.noWorkoutEmptyContent(
            widget.model.selectedChipTranslated,
          ),
          itemBuilder: (context, workout, index) {
            final locale = Intl.getCurrentLocale();

            final difficulty = Formatter.difficulty(workout.difficulty);
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
              tag: 'addWorkout-tag${workout.workoutId}',
              imageUrl: workout.imageUrl,
              isLeadingDuration: false,
              leadingText: leadingText!,
              title: title,
              subtitle: '$difficulty,  ${S.current.usingEquipment(equipment!)}',
              onTap: () => widget.model.submitRoutineWorkoutData(
                context,
                widget.routine,
                workout,
              ),
            );
          },
        ),
        initialData: [],
      ),
    );
  }

  PreferredSize _appBarWidget(BuildContext context) {
    final List<String> _mainMuscleGroup = MainMuscleGroup.values[0].list;
    final List<Widget> chips = _mainMuscleGroup.map(
      (e) {
        final label = MainMuscleGroup.values
            .firstWhere((element) => element.toString() == e)
            .translation!;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: ChoiceChip(
            backgroundColor: kAppBarColor,
            selectedColor: kPrimaryColor,
            label: Text(label, style: TextStyles.button1),
            labelPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            shape: StadiumBorder(
              side: BorderSide(
                color: (widget.model.selectedMainMuscleGroup == e)
                    ? kPrimary300Color
                    : Colors.grey,
                width: 1,
              ),
            ),
            selected: widget.model.selectedMainMuscleGroup == e,
            onSelected: (selected) => widget.model.onSelected(selected, e),
          ),
        );
      },
    ).toList();

    return PreferredSize(
      preferredSize: Size.fromHeight(60),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(children: chips),
        ),
      ),
    );
  }
}
