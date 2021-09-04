import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/models.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/view/screens/library/choose_title_screen.dart';
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
///
class RoutinesTab extends StatelessWidget {
  const RoutinesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.d('[RoutinesTab] tab...');

    final database = Provider.of<Database>(context, listen: false);

    return PaginateFirestore(
      isLive: true,
      shrinkWrap: true,
      itemsPerPage: 10,
      query: database.routinesPaginatedUserQuery(),
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilderType: PaginateBuilderType.listView,
      emptyDisplay: SingleChildScrollView(
        child: _buildHeader(context, isHeader: false),
      ),
      header: SliverToBoxAdapter(
        child: _buildHeader(context, isHeader: true),
      ),
      footer: const SliverToBoxAdapter(
        child: SizedBox(height: kBottomNavigationBarHeight + 48),
      ),
      onError: (error) => EmptyContent(
        message: S.current.somethingWentWrong,
        e: error,
      ),
      itemBuilder: (_, context, snapshot) {
        final routine = snapshot.data() as Routine?;

        return LibraryListTile(
          tag: 'savedRoutines-${routine!.routineId}',
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
