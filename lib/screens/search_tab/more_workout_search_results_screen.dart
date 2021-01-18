import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/common_widgets/custom_list_tile_style2.dart';
import 'package:workout_player/common_widgets/list_item_builder.dart';
import 'package:workout_player/constants.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/screens/library_tab/workout/workout_detail_screen.dart';
import 'package:workout_player/services/database.dart';

class MoreWorkoutSearchResultScreen extends StatelessWidget {
  static void show({BuildContext context}) async {
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => MoreWorkoutSearchResultScreen(),
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
        title: Text('운동', style: Subtitle1),
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
      child: StreamBuilder<List<Workout>>(
        stream: database.workoutsStream(),
        builder: (context, snapshot) {
          return ListItemBuilder<Workout>(
            snapshot: snapshot,
            itemBuilder: (context, workout) => CustomListTileStyle2(
              imageUrl: workout.imageUrl,
              title: workout.workoutTitle,
              subtitle: workout.mainMuscleGroup,
              onTap: () => WorkoutDetailScreen.show(
                context: context,
                // index: index,
                // workout: workout,
              ),
            ),
          );
        },
      ),
    );
  }
}
