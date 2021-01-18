import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/custom_list_tile_style1.dart';

import '../../../common_widgets/list_item_builder.dart';
import '../../../models/routine.dart';
import '../../../services/database.dart';
import 'create_new_playlist_widget.dart';
import 'routine_detail_screen.dart';

class SavedRoutinesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: ScrollController(),
      child: Column(
        children: [
          SizedBox(height: 16),
          CreateNewPlaylistWidget(),
          SizedBox(height: 8),
          _playlistBuilder(context),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _playlistBuilder(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return StreamBuilder<List<Routine>>(
      stream: database.routinesStream(),
      builder: (context, snapshot) {
        return ListItemBuilder<Routine>(
          snapshot: snapshot,
          itemBuilder: (context, routine) => CustomListTileStyle1(
            tag: 'playlist${routine.routineId}',
            title: routine.routineTitle,
            subtitle: 'by ${routine.routineOwnerUserName}',
            imageUrl: routine.imageUrl,
            onTap: () => RoutineDetailScreen.show(context, routine.routineId),
          ),
        );
      },
    );
  }
}
