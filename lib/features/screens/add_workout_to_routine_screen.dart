import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/features/screens/routine_detail_screen.dart';
import 'package:workout_player/features/widgets/widgets.dart';
import 'package:workout_player/view_models/home_screen_model.dart';

/// Screen that is pushed when user presses `AddWorkoutToRoutine` button.
/// It lists the custom routines made by the user, and when the user presses the
/// Routine ListTile, the workout is added to that routine and routed to the
///
/// /// ## Roadmap
///
/// ### Refactoring
/// * TODO: Paginate list of [Workout] stream
///
/// ### Enhancement
///
class AddWorkoutToRoutine extends ConsumerStatefulWidget {
  const AddWorkoutToRoutine({
    required this.workout,
    super.key,
  });

  final Workout workout;

  /// Navigation
  static void show(
    BuildContext context, {
    required Workout workout,
  }) {
    customPush(
      context,
      rootNavigator: true,
      builder: (context) => AddWorkoutToRoutine(
        workout: workout,
      ),
    );
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddWorkoutToRoutineState();
}

class _AddWorkoutToRoutineState extends ConsumerState<AddWorkoutToRoutine> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarLeading: const AppBarCloseButton(),
      appBarTitle: S.current.addWorkoutToRoutine,
      buildBody: (context) => _buildBody(context, ref),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref) {
    final database = ref.watch<Database>(databaseProvider);

    return CustomStreamBuilder<List<Routine>>(
      stream: database.userRoutinesStream(),
      builder: (context, data) {
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: Scaffold.of(context).appBarMaxHeight! + 8),
              CustomListViewBuilder<Routine>(
                items: data,
                itemBuilder: (context, routine, i) {
                  final homeModel = ref.read(homeScreenModelProvider);
                  final currentKey =
                      HomeScreenModel.tabNavigatorKeys[homeModel.currentTab]!;

                  return LibraryListTile(
                    tag: 'routine${routine.routineId}',
                    title: routine.routineTitle,
                    subtitle: Formatter.getJoinedMainMuscleGroups(
                      routine.mainMuscleGroup,
                      routine.mainMuscleGroupEnum,
                    ),
                    imageUrl: routine.imageUrl,
                    // onTap: () => model.submit(
                    //   context,
                    //   currentKey.currentContext!,
                    //   workout: workout,
                    //   routine: routine,
                    // ),
                    onTap: () async {
                      final a = await ref
                          .read(addWorkoutToRoutineScreenModelProvider)
                          .submit(workout: widget.workout, routine: routine);

                      if (!mounted) return;

                      if (a.statusCode == 200) {
                        Navigator.of(context).pop();

                        RoutineDetailScreen.show(
                          currentKey.currentContext!,
                          routine: routine,
                          tag: 'addWorkoutToRoutine${routine.routineId}',
                        );
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: kBottomNavigationBarHeight),
            ],
          ),
        );
      },
    );
  }
}


// class AddWorkoutToRoutineScreen extends ConsumerWidget {
//   final Workout workout;

//   const AddWorkoutToRoutineScreen({
//     Key? key,
//     required this.workout,
//   }) : super(key: key);

//   /// Navigation
//   static void show(
//     BuildContext context, {
//     required Workout workout,
//   }) {
//     customPush(
//       context,
//       rootNavigator: true,
//       builder: (context) => AddWorkoutToRoutineScreen(
//         workout: workout,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return CustomScaffold(
//       appBarLeading: const AppBarCloseButton(),
//       appBarTitle: S.current.addWorkoutToRoutine,
//       buildBody: (context) => _buildBody(context, ref),
//     );
//   }

//   Widget _buildBody(BuildContext context, WidgetRef ref) {
//     final database = ref.watch<Database>(databaseProvider);

//     return CustomStreamBuilder<List<Routine>>(
//       stream: database.userRoutinesStream(),
//       builder: (context, data) {
//         return SingleChildScrollView(
//           child: Column(
//             children: [
//               SizedBox(height: Scaffold.of(context).appBarMaxHeight! + 8),
//               CustomListViewBuilder<Routine>(
//                 items: data,
//                 itemBuilder: (context, routine, i) {
//                   final model =
//                       ref.read(addWorkoutToRoutineScreenModelProvider);
//                   final homeModel = ref.read(homeScreenModelProvider);
//                   final currentKey =
//                       HomeScreenModel.tabNavigatorKeys[homeModel.currentTab]!;

//                   return LibraryListTile(
//                     tag: 'routine${routine.routineId}',
//                     title: routine.routineTitle,
//                     subtitle: Formatter.getJoinedMainMuscleGroups(
//                       routine.mainMuscleGroup,
//                       routine.mainMuscleGroupEnum,
//                     ),
//                     imageUrl: routine.imageUrl,
//                     // onTap: () => model.submit(
//                     //   context,
//                     //   currentKey.currentContext!,
//                     //   workout: workout,
//                     //   routine: routine,
//                     // ),
//                     onTap: () async {
//                       final a = await ref
//                           .read(addWorkoutToRoutineScreenModelProvider)
//                           .submit(workout: workout, routine: routine);

//                       if (!mounted) return;


//                       Navigator.of(context).pop();

//                       RoutineDetailScreen.show(
//                         currentTabContext,
//                         routine: routine,
//                         tag: 'addWorkoutToRoutine${routine.routineId}',
//                       );
//                     },
//                   );
//                 },
//               ),
//               const SizedBox(height: kBottomNavigationBarHeight),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
