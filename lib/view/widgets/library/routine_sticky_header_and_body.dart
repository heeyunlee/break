import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:workout_player/generated/l10n.dart';

import 'package:workout_player/models/combined/combined_models.dart';
import 'package:workout_player/models/models.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/view/screens/add_workouts_to_routine_screen.dart';
import 'package:workout_player/view_models/routine_detail_screen_model.dart';

import '../widgets.dart';

class RoutineStickyHeaderAndBody extends StatelessWidget {
  const RoutineStickyHeaderAndBody({
    Key? key,
    required this.model,
    required this.data,
    required this.authAndDatabase,
  }) : super(key: key);

  final RoutineDetailScreenModel model;
  final RoutineDetailScreenClass data;
  final AuthAndDatabase authAndDatabase;

  @override
  Widget build(BuildContext context) {
    final bool isOwner =
        authAndDatabase.auth.currentUser!.uid == data.routine?.routineOwnerId;

    // Widgets to show only if one's routine's owner
    final List<Widget> routineOwnerWidgets = [
      kCustomDividerIndent8,
      const SizedBox(height: 16),
      MaxWidthRaisedButton(
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        buttonText: S.current.addWorkoutkButtonText,
        color: kCardColor,
        onPressed: () => AddWorkoutsToRoutineScreen.show(
          context,
          routine: data.routine!,
          routineWorkouts: data.routineWorkouts!,
        ),
      ),
      const SizedBox(height: 8),
      ReorderRoutineWorkoutsButton(
        routine: data.routine!,
        list: data.routineWorkouts!,
      ),
    ];

    return SliverStickyHeader(
      header: AnimatedBuilder(
        animation: model.sliverAnimationController,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: const Alignment(0, 0.5),
                end: Alignment.bottomCenter,
                colors: [
                  model.colorTweeen.value!,
                  model.secondColorTweeen.value!,
                ],
              ),
            ),
            height: 64,
            child: child,
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LogRoutineButton(data: data),
            const SizedBox(width: 16),
            StartRoutineButton(data: data),
          ],
        ),
      ),
      sliver: SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              CustomListViewBuilder<RoutineWorkout>(
                items: data.routineWorkouts!,
                itemBuilder: (context, item, i) => RoutineWorkoutCard(
                  index: i,
                  authAndDatabase: AuthAndDatabase(
                    auth: authAndDatabase.auth,
                    database: authAndDatabase.database,
                  ),
                  routine: data.routine!,
                  routineWorkout: item,
                ),
              ),
              const SizedBox(height: 8),
              if (isOwner) ...routineOwnerWidgets,
              const SizedBox(height: kBottomNavigationBarHeight + 8),
            ],
          ),
        ),
      ),
    );
  }
}
