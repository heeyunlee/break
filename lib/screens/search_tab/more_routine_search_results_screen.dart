import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/common_widgets/custom_list_tile_style1.dart';
import 'package:workout_player/common_widgets/list_item_builder.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/screens/library_tab/playlist/playlist_detail_screen.dart';
import 'package:workout_player/services/database.dart';

import '../../constants.dart';

class MoreRoutineSearchResultsScreen extends StatelessWidget {
  static void show({BuildContext context}) async {
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => MoreRoutineSearchResultsScreen(),
      ),
    );
  }

  int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: AppbarBlurBG(),
        title: Text('루틴', style: Subtitle1),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: StreamBuilder<List<Routine>>(
        stream: database.routinesStream(),
        builder: (context, snapshot) {
          return ListItemBuilder<Routine>(
            snapshot: snapshot,
            itemBuilder: (context, routine) => CustomListTileStyle1(
              tag: 'routineSearchResult${routine.routineId}',
              title: routine.routineTitle,
              subtitle: routine.routineOwnerId,
              imageUrl: routine.imageUrl,
              onTap: () => PlaylistDetailScreen.show(
                index: index,
                context: context,
                routine: routine,
              ),
            ),
          );
        },
      ),
    );
  }
}
