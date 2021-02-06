import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/custom_list_tile_style1.dart';
import 'package:workout_player/screens/library_tab/routine/routine_detail_screen.dart';

import '../../../common_widgets/list_item_builder.dart';
import '../../../models/routine.dart';
import '../../../services/database.dart';
import 'create_routine/create_new_routine_widget.dart';

class SavedRoutinesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: ScrollController(),
      child: Column(
        children: [
          SizedBox(height: 16),
          CreateNewRoutineWidget(),
          SizedBox(height: 8),
          _routineListBuilder(context),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _routineListBuilder(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return StreamBuilder<List<Routine>>(
      stream: database.routinesStream(),
      builder: (context, snapshot) {
        return ListItemBuilder<Routine>(
          emptyContentTitle: 'Create a new Routine',
          snapshot: snapshot,
          itemBuilder: (context, routine) => CustomListTileStyle1(
            tag: 'routine${routine.routineId}',
            title: routine.routineTitle,
            subtitle: 'by ${routine.routineOwnerUserName}',
            // imageUrl: routine.imageUrl,
            imageIndex: routine?.imageIndex ?? 0,
            onTap: () => RoutineDetailScreen.show(
              context: context,
              routine: routine,
              isRootNavigation: false,
            ),
          ),
        );
      },
    );
  }
}
