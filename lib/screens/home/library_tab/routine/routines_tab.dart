import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/classes/routine.dart';
import 'package:workout_player/screens/home/library_tab/routine/routine_detail_screen_model.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/screens/home/library_tab/widgets/library_list_tile.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/widgets/empty_content.dart';
import 'package:workout_player/widgets/empty_content_widget.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/widgets/reusable_screens/choose_title_screen.dart';

import 'create_routine/create_new_routine_list_tile.dart';
import 'create_routine/create_new_routine_model.dart';
import 'saved_routines/saved_routines_tile_widget.dart';

class RoutinesTab extends StatelessWidget {
  const RoutinesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return PaginateFirestore(
      shrinkWrap: true,
      query: database.routinesPaginatedUserQuery(),
      physics: const BouncingScrollPhysics(),
      itemBuilderType: PaginateBuilderType.listView,
      emptyDisplay: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            SavedRoutinesTileWidget(),
            EmptyContentWidget(
              imageUrl: 'assets/images/saved_routines_empty_bg.png',
              bodyText: S.current.savedRoutineEmptyText,
              onPressed: () => ChooseTitleScreen.show<CreateNewRoutineModel>(
                context,
                formKey: CreateNewRoutineModel.formKey,
                provider: createNewROutineModelProvider,
                appBarTitle: S.current.routineTitleTitle,
                hintText: S.current.routineTitleHintText,
              ),
            ),
          ],
        ),
      ),
      itemsPerPage: 10,
      header: SliverToBoxAdapter(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            const CreateNewRoutineListTile(),
            SavedRoutinesTileWidget(),
          ],
        ),
      ),
      footer: SliverToBoxAdapter(child: const SizedBox(height: 160)),
      onError: (error) => EmptyContent(
        message: '${S.current.somethingWentWrong} \n error message: $error',
      ),
      itemBuilder: (index, context, snapshot) {
        final routine = snapshot.data() as Routine;

        return LibraryListTile(
          tag: 'savedRoutines-${routine.routineId}',
          title: routine.routineTitle,
          subtitle: Formatter.getJoinedMainMuscleGroups(
            routine.mainMuscleGroup,
            routine.mainMuscleGroupEnum,
          ),
          imageUrl: routine.imageUrl,
          onTap: () => RoutineDetailScreenModel.show(
            context,
            routine: routine,
            tag: 'savedRoutines-${routine.routineId}',
          ),
        );
      },
      isLive: true,
    );
  }
}
