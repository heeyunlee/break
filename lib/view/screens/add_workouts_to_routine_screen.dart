import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import '../../view_models/add_workouts_to_routine_model.dart';

class AddWorkoutsToRoutineScreen extends StatefulWidget {
  final Routine routine;
  final List<RoutineWorkout> routineWorkouts;
  final AddWorkoutsToRoutineScreenModel model;

  const AddWorkoutsToRoutineScreen({
    Key? key,
    required this.routine,
    required this.routineWorkouts,
    required this.model,
  }) : super(key: key);

  static void show(
    BuildContext context, {
    required Routine routine,
    required List<RoutineWorkout> routineWorkouts,
  }) {
    customPush(
      context,
      rootNavigator: true,
      builder: (context) => Consumer(
        builder: (context, ref, child) => AddWorkoutsToRoutineScreen(
          routine: routine,
          routineWorkouts: routineWorkouts,
          model: ref.watch(addWorkoutsToRoutineScreenModelProvider),
        ),
      ),
    );
  }

  @override
  _AddWorkoutsToRoutineScreenState createState() =>
      _AddWorkoutsToRoutineScreenState();
}

class _AddWorkoutsToRoutineScreenState
    extends State<AddWorkoutsToRoutineScreen> {
  @override
  void initState() {
    super.initState();
    widget.model.init(widget.routine);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, _) {
          return <Widget>[_appBarWidget(context)];
        },
        body: _buildBody(context),
      ),
      floatingActionButton: SizedBox(
        width: size.width - 32,
        child: FloatingActionButton.extended(
          onPressed: (widget.model.selectedWorkouts.isEmpty)
              ? null
              : () => widget.model.addWorkoutsToRoutine(
                    context,
                    widget.routine,
                    widget.routineWorkouts,
                  ),
          backgroundColor: (widget.model.selectedWorkouts.isEmpty)
              ? Colors.grey
              : theme.colorScheme.secondary,
          label: Text(
            S.current.addWorkoutFABTitle(widget.model.selectedWorkouts.length),
            style: TextStyles.button1,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 8),
          CustomStreamBuilder<List<Workout>>(
            stream: widget.model.stream,
            errorWidget: const EmptyContent(),
            loadingWidget: const ListViewShimmer(),
            builder: (context, data) => CustomListViewBuilder<Workout>(
              items: data,
              emptyContentTitle: S.current.noWorkoutEmptyContent(
                widget.model.selectedChipTranslated,
              ),
              itemBuilder: (context, workout, index) {
                return LibraryListTile(
                  tag: UniqueKey().toString(),
                  selected: widget.model.selectedWorkouts.contains(workout),
                  leadingString: Formatter.difficulty(workout.difficulty),
                  title: Formatter.localizedTitle(
                    workout.workoutTitle,
                    workout.translated,
                  ),
                  imageUrl: workout.imageUrl,
                  subtitle: Formatter.getJoinedEquipmentsRequired(
                    workout.equipmentRequired,
                  ),
                  onTap: () => widget.model.selectWorkout(context, workout),
                );
              },
            ),
          ),
          const SizedBox(height: kBottomNavigationBarHeight + 48),
        ],
      ),
    );
  }

  Widget _appBarWidget(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      centerTitle: true,
      title: Text(S.current.addWorkoutkButtonText, style: TextStyles.subtitle1),
      leading: const AppBarCloseButton(),
      bottom: ChoiceChipsAppBarWidget(
        selectedChip: widget.model.selectedMainMuscleGroup,
        onSelected: widget.model.onSelectChoiceChip,
      ),
    );
  }
}
