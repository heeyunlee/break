import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/common_widgets/custom_list_tile_style2.dart';
import 'package:workout_player/common_widgets/list_item_builder.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/screens/library_tab/routine/routine_detail_screen.dart';
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
      extendBodyBehindAppBar: true,
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: AppbarBlurBG(),
        title: Text('Routines', style: Subtitle1),
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
      body: Column(
        children: [
          SizedBox(height: 104),
          _buildBody(context),
        ],
      ),
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
            emptyContentTitle: 'Empty...',
            snapshot: snapshot,
            itemBuilder: (context, routine) => CustomListTileStyle2(
              title: routine.routineTitle,
              subtitle: 'by ${routine.routineOwnerUserName}',
              imageUrl: routine.imageUrl,
              onTap: () => RoutineDetailScreen.show(
                context: context,
                routine: routine,
                isRootNavigation: false,
              ),
              imageIndex: routine.imageIndex ?? 0,
            ),
          );
        },
      ),
    );
  }
}
