import 'package:flutter/material.dart';
import 'package:workout_player/models/combined/routine_detail_screen_class.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/combined/auth_and_database.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/view/screens/add_workouts_to_routine_screen.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/view/widgets/widgets.dart';

class RoutineWorkoutsTab extends StatefulWidget {
  final RoutineDetailScreenClass data;
  final AuthBase auth;
  final Database database;

  const RoutineWorkoutsTab({
    Key? key,
    required this.data,
    required this.auth,
    required this.database,
  }) : super(key: key);

  @override
  _RoutineWorkoutsTabState createState() => _RoutineWorkoutsTabState();
}

class _RoutineWorkoutsTabState extends State<RoutineWorkoutsTab> {
  @override
  Widget build(BuildContext context) {
    final bool isOwner =
        widget.auth.currentUser!.uid == widget.data.routine?.routineOwnerId;

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
          routine: widget.data.routine!,
          routineWorkouts: widget.data.routineWorkouts!,
        ),
      ),
      const SizedBox(height: 8),
      ReorderRoutineWorkoutsButton(
        routine: widget.data.routine!,
        list: widget.data.routineWorkouts!,
      ),
    ];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomListViewBuilder<RoutineWorkout>(
              items: widget.data.routineWorkouts!,
              itemBuilder: (context, item, i) => RoutineWorkoutCard(
                index: i,
                authAndDatabase: AuthAndDatabase(
                  auth: widget.auth,
                  database: widget.database,
                ),
                routine: widget.data.routine!,
                routineWorkout: item,
              ),
            ),
            if (isOwner) ...routineOwnerWidgets,
            const SizedBox(height: 160),
          ],
        ),
      ),
    );
  }
}
