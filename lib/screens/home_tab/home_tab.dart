import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/common_widgets/horz_list_item_builder.dart';
import 'package:workout_player/format.dart';
import 'package:workout_player/models/main_muscle_group.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/screens/home_tab/start_workout_shortcut_screen.dart';
import 'package:workout_player/screens/library_tab/routine/routine_detail_screen.dart';
import 'package:workout_player/screens/library_tab/workout/workout_detail_screen.dart';
import 'package:workout_player/services/database.dart';

import '../../constants.dart';
import 'announcement_card_page_view.dart';
import 'long_height_card_widget.dart';
import 'muscle_group_card/muscle_group_card_widget.dart';
import 'muscle_group_card/muscle_group_search_screen.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint('scaffold building...');

    final database = Provider.of<Database>(context, listen: false);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Image.asset(
          'assets/logos/playerh_logo.png',
          height: 36,
          width: 36,
        ),
        flexibleSpace: AppbarBlurBG(),
      ),
      backgroundColor: BackgroundColor,
      body: Builder(
        builder: (BuildContext context) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Scaffold.of(context).appBarMaxHeight + 8),
                _homeScreenBody(database, context),
              ],
            ),
          );
        },
      ),
      floatingActionButton: _buildFAB(context),
    );
  }

  Widget _homeScreenBody(Database database, BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AnnouncementCardPageView(),
        const SizedBox(height: 36),
        _GridViewChildWidget(),
        const SizedBox(height: 48),
        const Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: const Text('New Chest Routines', style: Headline6w900),
        ),
        StreamBuilder<List<Routine>>(
          stream: database.routinesSearchStream3(
            limit: 5,
            searchCategory: 'mainMuscleGroup',
            arrayContains: 'Chest',
          ),
          builder: (context, snapshot) {
            return Container(
              height: size.width,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: HoriListItemBuilder<Routine>(
                  isEmptyContentWidget: false,
                  snapshot: snapshot,
                  emptyContentTitle: 'Empty...',
                  itemBuilder: (context, routine) {
                    final duration = Format.durationInMin(routine.duration);

                    return LongHeightCardWidget(
                      tag: 'horizListTag1-${routine.routineId}',
                      imageUrl: routine.imageUrl,
                      title: routine.routineTitle,
                      subtitle: routine.routineOwnerUserName,
                      thirdLineSubtitle: duration,
                      onTap: () => RoutineDetailScreen.show(
                        context,
                        isRootNavigation: false,
                        routine: routine,
                        tag: 'horizListTag1-${routine.routineId}',
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 48),
        const Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: const Text('Back Workouts for you', style: Headline6w900),
        ),
        StreamBuilder<List<Workout>>(
          stream: database.workoutsSearchStream(
            limit: 5,
            searchCategory: 'mainMuscleGroup',
            arrayContains: 'Lower Back',
          ),
          builder: (context, snapshot) {
            return Container(
              height: size.width,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: HoriListItemBuilder<Workout>(
                  isEmptyContentWidget: false,
                  snapshot: snapshot,
                  emptyContentTitle: 'Empty...',
                  itemBuilder: (context, workout) {
                    final difficulty = Format.difficulty(workout.difficulty);

                    return LongHeightCardWidget(
                      tag: 'workoutTag1-${workout.workoutId}',
                      imageUrl: workout.imageUrl,
                      title: workout.workoutTitle,
                      subtitle: workout.equipmentRequired[0],
                      thirdLineSubtitle: difficulty,
                      onTap: () => WorkoutDetailScreen.show(
                        context,
                        isRootNavigation: false,
                        workout: workout,
                        tag: 'workoutTag1-${workout.workoutId}',
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 48),
        const Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: const Text('Routines for your QUAD', style: Headline6w900),
        ),
        StreamBuilder<List<Routine>>(
          stream: database.routinesSearchStream(
            limit: 5,
            searchCategory: 'mainMuscleGroup',
            arrayContains: 'Leg',
          ),
          builder: (context, snapshot) {
            return Container(
              height: size.width,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: HoriListItemBuilder<Routine>(
                  isEmptyContentWidget: false,
                  snapshot: snapshot,
                  emptyContentTitle: 'Empty...',
                  itemBuilder: (context, routine) {
                    final duration = Format.durationInMin(routine.duration);

                    return LongHeightCardWidget(
                      tag: 'routineTag2-${routine.routineId}',
                      imageUrl: routine.imageUrl,
                      title: routine.routineTitle,
                      subtitle: duration,
                      onTap: () => RoutineDetailScreen.show(
                        context,
                        isRootNavigation: false,
                        routine: routine,
                        tag: 'routineTag2-${routine.routineId}',
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFAB(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: PrimaryColor,
      icon: const Icon(
        Icons.play_arrow_rounded,
        color: Colors.white,
      ),
      label: const Text('Start Workout!'),
      onPressed: () => StartWorkoutShortcutScreen.show(context),
    );
  }
}

class _GridViewChildWidget extends StatefulWidget {
  @override
  __GridViewChildWidgetState createState() => __GridViewChildWidgetState();
}

class __GridViewChildWidgetState extends State<_GridViewChildWidget> {
  List<String> _mainMuscleGroup = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < MainMuscleGroup.values.length; i++) {
      var value = MainMuscleGroup.values[i].label;
      _mainMuscleGroup.add(value);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> gridTiles = new List();

    for (int i = 0; i < _mainMuscleGroup.length; i++) {
      Widget card = MuscleGroupCardWidget(
        text: _mainMuscleGroup[i],
        onTap: () => MuscleGroupSearchScreen.show(
          context: context,
          isEqualTo: _mainMuscleGroup[i],
          searchCategory: 'mainMuscleGroup',
        ),
      );

      gridTiles.add(card);
    }

    final size = MediaQuery.of(context).size;

    final double itemWidth = size.width / 2;
    final double itemHeight = size.width / 4;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        childAspectRatio: (itemWidth / itemHeight),
        crossAxisCount: 3,
        padding: const EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: gridTiles,
      ),
    );
  }
}
