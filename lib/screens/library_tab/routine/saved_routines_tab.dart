import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/widgets/custom_list_tile_64.dart';
import 'package:workout_player/widgets/empty_content.dart';
import 'package:workout_player/widgets/empty_content_widget.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';

import '../../../models/routine.dart';
import '../../../services/database.dart';
import 'create_routine/create_new_routine_screen.dart';
import 'create_routine/create_new_routine_widget.dart';
import 'routine_detail_screen.dart';
import 'saved_routines/saved_routines_tile_widget.dart';

class SavedRoutinesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    var query = database.routinesPaginatedUserQuery();

    return PaginateFirestore(
      shrinkWrap: true,
      query: query,
      physics: const BouncingScrollPhysics(),
      itemBuilderType: PaginateBuilderType.listView,
      emptyDisplay: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            SavedRoutinesTileWidget(),
            EmptyContentWidget(
              imageUrl: 'assets/images/saved_routines_empty_bg.png',
              bodyText: S.current.savedRoutineEmptyText,
              onPressed: () => CreateNewRoutineScreen.show(context),
            ),
          ],
        ),
      ),
      itemsPerPage: 10,
      header: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          if (query.snapshots() != null) CreateNewRoutineWidget(),
          SavedRoutinesTileWidget(),
        ],
      ),
      footer: const SizedBox(height: 16),
      onError: (error) => EmptyContent(
        message: '${S.current.somethingWentWrong} \n error message: $error',
      ),
      itemBuilder: (index, context, documentSnapshot) {
        final documentId = documentSnapshot.id;
        final data = documentSnapshot.data();
        final routine = Routine.fromMap(data, documentId);
        final subtitle = MainMuscleGroup.values
            .firstWhere((e) => e.toString() == routine.mainMuscleGroup[0])
            .translation;
        return CustomListTile64(
          tag: 'savedRoutines-${routine.routineId}',
          title: routine.routineTitle,
          subtitle: subtitle,
          imageUrl: routine.imageUrl,
          onTap: () => RoutineDetailScreen.show(
            context,
            routine: routine,
            isRootNavigation: false,
            tag: 'savedRoutines-${routine.routineId}',
          ),
        );
      },
      isLive: true,
    );
  }
}
