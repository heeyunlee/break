import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/common_widgets/custom_list_tile_style2.dart';
import 'package:workout_player/common_widgets/list_item_builder.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/screens/library_tab/routine/routine_detail_screen.dart';
import 'package:workout_player/screens/library_tab/workout/workout_detail_screen.dart';
import 'package:workout_player/services/database.dart';

import '../../constants.dart';

class MoreRoutineResult extends StatelessWidget {
  const MoreRoutineResult({
    this.tag,
    this.searchCategory,
  });

  final String tag;
  final String searchCategory;

  static void show({
    BuildContext context,
    String tag,
    String searchCategory,
  }) async {
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => MoreRoutineResult(
          searchCategory: searchCategory,
          tag: tag,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        flexibleSpace: AppbarBlurBG(),
        title: Text('더 많은 $tag 운동', style: Subtitle1),
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
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        children: <Widget>[
          SizedBox(height: 16),
          ListTile(
            tileColor: Grey800,
            title: Text(
              '루틴',
              style: TextStyle(color: Colors.white),
            ),
          ),
          _buildRoutinesStream(context),
          SizedBox(height: 48),
          ListTile(
            tileColor: Grey800,
            title: Text(
              '운동',
              style: TextStyle(color: Colors.white),
            ),
          ),
          _buildWorkoutsStream(context),
        ],
      ),
    );
  }

  _buildRoutinesStream(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    int index;

    return StreamBuilder<List<Routine>>(
      stream: database.routinesSearchStream(tag, searchCategory),
      builder: (context, snapshot) {
        return ListItemBuilder<Routine>(
          snapshot: snapshot,
          itemBuilder: (context, routine) => CustomListTileStyle2(
            title: routine.routineTitle,
            subtitle: routine.routineOwnerUserName,
            imageUrl: routine.imageUrl,
            onTap: () => RoutineDetailScreen.show(
              context: context,
              routineId: routine.routineId,
              isRootNavigation: false,
            ),
          ),
        );
      },
    );
  }

  _buildWorkoutsStream(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    int index;

    return StreamBuilder<List<Workout>>(
      stream: database.workoutsSearchStream(tag, searchCategory),
      builder: (context, snapshot) {
        return ListItemBuilder<Workout>(
          snapshot: snapshot,
          itemBuilder: (context, workout) => CustomListTileStyle2(
            title: workout.workoutTitle,
            subtitle: workout.workoutOwnerId,
            imageUrl: workout.imageUrl,
            onTap: () => WorkoutDetailScreen.show(
              // index: index,
              context: context,
              // workout: workout,
            ),
          ),
        );
      },
    );
  }
}
