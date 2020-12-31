import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/common_widgets/custom_list_tile_style3.dart';
import 'package:workout_player/common_widgets/list_item_builder.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/services/database.dart';

import '../../../constants.dart';

class AddWorkoutsToRoutine extends StatefulWidget {
  static void show(BuildContext context) async {
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => AddWorkoutsToRoutine(),
        fullscreenDialog: true,
      ),
    );
    // await pushNewScreen(
    //   context,
    //   screen: AddWorkoutsToRoutine(),
    //   withNavBar: false,
    //   pageTransitionAnimation: PageTransitionAnimation.slideUp,
    // );
  }

  List<Workout> workouts = <Workout>[];

  @override
  _AddWorkoutsToRoutineState createState() => _AddWorkoutsToRoutineState();
}

class _AddWorkoutsToRoutineState extends State<AddWorkoutsToRoutine> {
  int index;
  int countSelected = 0;
  // bool isSelected = false;

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
            Icons.close_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: PrimaryColor,
        icon: Icon(
          Icons.add_rounded,
          color: Colors.white,
        ),
        label: Text('4개 운동 추가하기', style: ButtonText),
      ),
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
            itemBuilder: (context, workout) => CustomListTileStyle3(
              color: PrimaryColor.withOpacity(0.12),
              tag: 'workoutTagForSearch-${workout.workoutId}',
              imageUrl: workout.imageUrl,
              title: workout.workoutTitle,
              subtitle: workout.mainMuscleGroup,
              // isSelected: isSelected,
            ),
          );
        },
      ),
    );
  }
}

class ListItem<Workout> {
  bool isSelected = false;
  Workout workout;

  ListItem(this.workout);
}
