import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/models.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/view/screens/choose_title_screen.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/create_new_routine_model.dart';
import 'package:workout_player/view_models/main_model.dart';

import 'routine_detail_screen.dart';
import 'saved_routines_screen.dart';

/// Creates a tab that displays a list of routines, either saved or created by
/// the user.
///
/// ## Roadmap
///
/// ### Refactoring
///
/// ### Enhancement
/// * Paginate list of [Routine]
///
class RoutinesTab extends ConsumerWidget {
  const RoutinesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ref.watch(databaseProvider);

    logger.d('[RoutinesTab] tab...');

    return CustomStreamBuilder<List<Routine>>(
      stream: database.userRoutinesStream(),
      emptyWidget: SingleChildScrollView(
        child: _buildHeader(context, isHeader: false),
      ),
      builder: (context, data) {
        return SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context, isHeader: true),
              CustomListViewBuilder<Routine>(
                items: data,
                itemBuilder: (context, routine, i) {
                  return LibraryListTile(
                    tag: 'savedRoutines-${routine.routineId}',
                    title: routine.routineTitle,
                    subtitle: Formatter.getJoinedMainMuscleGroups(
                      routine.mainMuscleGroup,
                      routine.mainMuscleGroupEnum,
                    ),
                    imageUrl: routine.imageUrl,
                    onTap: () => RoutineDetailScreen.show(
                      context,
                      routine: routine,
                      tag: 'savedRoutines-${routine.routineId}',
                    ),
                  );
                },
              ),
              const SizedBox(height: kBottomNavigationBarHeight + 48),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, {required bool isHeader}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),
        CreateListTile(
          title: S.current.createNewRoutine,
          onTap: () => ChooseTitleScreen.show<CreateNewRoutineModel>(
            context,
            formKey: CreateNewRoutineModel.formKey,
            provider: createNewROutineModelProvider,
            appBarTitle: S.current.routineTitleTitle,
            hintText: S.current.routineTitleHintText,
          ),
        ),
        SavedListTile<Routine>(
          onTap: (user) => SavedRoutinesScreen.show(context, user: user),
          title: S.current.savedRoutines,
        ),
        if (!isHeader)
          EmptyContent(
            message: S.current.savedRoutineEmptyText,
          ),
      ],
    );
  }
}
