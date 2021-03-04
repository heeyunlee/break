import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/custom_list_tile_64.dart';
import 'package:workout_player/common_widgets/empty_content_widget.dart';

import '../../../common_widgets/list_item_builder.dart';
import '../../../models/routine.dart';
import '../../../services/database.dart';
import 'create_routine/create_new_routine_screen.dart';
import 'create_routine/create_new_routine_widget.dart';
import 'routine_detail_screen.dart';

class SavedRoutinesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController;

    final database = Provider.of<Database>(context, listen: false);

    return StreamBuilder<List<Routine>>(
      stream: database.userRoutinesStream(),
      builder: (context, snapshot) {
        print(snapshot.error);

        return SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 12),
              if (snapshot.hasData && snapshot.data.isNotEmpty)
                CreateNewRoutineWidget(),
              ListItemBuilder<Routine>(
                snapshot: snapshot,
                isEmptyContentWidget: true,
                emptyContentWidget: EmptyContentWidget(
                  imageUrl: 'assets/images/saved_routines_empty_bg.png',
                  bodyText:
                      'You\'re one step away from creating your personal Routine!',
                  onPressed: () => CreateNewRoutineScreen.show(context),
                ),
                itemBuilder: (context, routine) => CustomListTile64(
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
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
