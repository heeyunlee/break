import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/custom_list_tile_64.dart';
import 'package:workout_player/common_widgets/empty_content.dart';
import 'package:workout_player/common_widgets/empty_content_widget.dart';

import '../../../models/routine.dart';
import '../../../services/database.dart';
import 'create_routine/create_new_routine_screen.dart';
import 'create_routine/create_new_routine_widget.dart';
import 'routine_detail_screen.dart';

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
      emptyDisplay: EmptyContentWidget(
        imageUrl: 'assets/images/saved_routines_empty_bg.png',
        bodyText: 'You\'re one step away from creating your personal Routine!',
        onPressed: () => CreateNewRoutineScreen.show(context),
      ),
      itemsPerPage: 10,
      header: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          if (query.snapshots() != null) CreateNewRoutineWidget(),
        ],
      ),
      footer: const SizedBox(height: 16),
      onError: (error) => EmptyContent(
        message: 'Something went wrong: $error',
      ),
      itemBuilder: (index, context, documentSnapshot) {
        final documentId = documentSnapshot.id;
        final data = documentSnapshot.data();
        final routine = Routine.fromMap(data, documentId);

        return CustomListTile64(
          tag: 'savedRoutines-${routine.routineId}',
          title: routine.routineTitle,
          subtitle: routine.mainMuscleGroup[0],
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
