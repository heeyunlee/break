import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/add_workout_to_routine_screen_model.dart';
import 'package:workout_player/view_models/home_screen_model.dart';
import 'package:workout_player/view_models/main_model.dart';

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
class AddWorkoutToRoutineScreen extends StatelessWidget {
  final Database database;
  final Workout workout;

  const AddWorkoutToRoutineScreen({
    Key? key,
    required this.database,
    required this.workout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.d('[AddWorkoutToRoutineScreen] building...');

    return CustomScaffold(
      appBarLeading: const AppBarCloseButton(),
      appBarTitle: S.current.addWorkoutToRoutine,
      buildBody: _buildBody,
    );
  }

  Widget _buildBody(BuildContext context) {
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
                  final model =
                      context.read(addWorkoutToRoutineScreenModelProvider);
                  final homeModel = context.read(homeScreenModelProvider);
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
                    onTap: () => model.submit(
                      context,
                      currentKey.currentContext!,
                      workout: workout,
                      routine: routine,
                    ),
                  );
                },
              ),
              const SizedBox(height: kBottomNavigationBarHeight),
            ],
          ),
        );
      },
    );
    // return PaginateFirestore(
    //   shrinkWrap: true,
    //   query: database.routinesPaginatedUserQuery(),
    //   physics: const BouncingScrollPhysics(),
    //   itemBuilderType: PaginateBuilderType.listView,
    //   emptyDisplay: EmptyContent(
    //     message: S.current.emptyRoutineMessage,
    //   ),
    //   itemsPerPage: 10,
    //   header: SliverToBoxAdapter(
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         SizedBox(height: Scaffold.of(context).appBarMaxHeight! + 8),
    //       ],
    //     ),
    //   ),
    //   footer: const SliverToBoxAdapter(
    //     child: SizedBox(height: kBottomNavigationBarHeight),
    //   ),
    //   onError: (Exception error) => EmptyContent(
    //     message: '${S.current.somethingWentWrong}: $error',
    //   ),
    //   itemBuilder: (index, context, snapshot) {
    //     final routine = snapshot.data() as Routine?;
    //     final model = context.read(addWorkoutToRoutineScreenModelProvider);
    //     final homeModel = context.read(homeScreenModelProvider);
    //     // final currentKey = homeModel.tabNavigatorKeys[homeModel.currentTab]!;
    //     final currentKey =
    //         HomeScreenModel.tabNavigatorKeys[homeModel.currentTab]!;

    //     return LibraryListTile(
    //       tag: 'routine${routine!.routineId}',
    //       title: routine.routineTitle,
    //       subtitle: Formatter.getJoinedMainMuscleGroups(
    //         routine.mainMuscleGroup,
    //         routine.mainMuscleGroupEnum,
    //       ),
    //       imageUrl: routine.imageUrl,
    //       onTap: () => model.submit(
    //         context,
    //         currentKey.currentContext!,
    //         workout: workout,
    //         routine: routine,
    //       ),
    //     );
    //   },
    //   isLive: true,
    // );
  }
}
