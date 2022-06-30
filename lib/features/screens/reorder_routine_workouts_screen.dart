import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/styles/theme_colors.dart';
import 'package:workout_player/features/widgets/widgets.dart';

import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/styles/text_styles.dart';

import '../../view_models/reorder_routine_workouts_screen_model.dart';

class ReorderRoutineWorkoutsScreen extends StatefulWidget {
  final Routine routine;
  final List<RoutineWorkout?> routineWorkouts;
  final ReorderRoutineWorkoutsScreenModel model;

  const ReorderRoutineWorkoutsScreen({
    Key? key,
    required this.routineWorkouts,
    required this.model,
    required this.routine,
  }) : super(key: key);

  static void show(
    BuildContext context, {
    required Routine routine,
    required List<RoutineWorkout?> routineWorkouts,
  }) {
    customPush(
      context,
      rootNavigator: true,
      builder: (context) => Consumer(
        builder: (context, ref, child) => ReorderRoutineWorkoutsScreen(
          routine: routine,
          routineWorkouts: routineWorkouts,
          model: ref.watch(reorderRoutineWorkoutsScreenModelProvider),
        ),
      ),
    );
  }

  @override
  State<ReorderRoutineWorkoutsScreen> createState() =>
      _ReorderRoutineWorkoutsScreenState();
}

class _ReorderRoutineWorkoutsScreenState
    extends State<ReorderRoutineWorkoutsScreen> {
  @override
  void initState() {
    super.initState();
    widget.model.initList(widget.routineWorkouts);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          S.current.editRoutineWorkoutOrder,
          style: TextStyles.subtitle2,
        ),
        leading: const AppBarCloseButton(),
      ),
      body: _buildBody(),
      floatingActionButton: SizedBox(
        width: size.width - 32,
        child: FloatingActionButton.extended(
          onPressed: widget.model.areMapsEqual
              ? null
              : () => widget.model.onSubmit(context, widget.routine),
          backgroundColor: widget.model.areMapsEqual
              ? ThemeColors.grey700
              : theme.colorScheme.secondary,
          label: Text(S.current.save, style: TextStyles.button1Bold),
        ),
      ),
    );
  }

  Widget _buildBody() {
    final locale = Intl.getCurrentLocale();

    if (widget.routineWorkouts.isNotEmpty) {
      return ReorderableListView.builder(
        proxyDecorator: widget.model.proxyDecorator,
        itemCount: widget.model.newList.length,
        onReorder: widget.model.onReorder,
        header: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              S.current.reorderRoutineWorkoutsHeader,
              style: TextStyles.body2Grey,
            ),
          ),
        ),
        itemBuilder: (context, index) {
          final indexToString = '${index + 1}.';

          return Padding(
            key: ValueKey(widget.routineWorkouts[index]!.routineWorkoutId),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: SizedBox(
                height: 56,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Text(indexToString, style: TextStyles.body2),
                      const SizedBox(width: 4),
                      Text(
                        widget.routineWorkouts[index]!.translated[locale]
                            .toString(),
                        style: TextStyles.body2,
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.reorder_rounded,
                        color: Colors.white24,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    } else {
      return EmptyContent(message: S.current.noWorkoutsWereAddedYet);
    }
  }
}
