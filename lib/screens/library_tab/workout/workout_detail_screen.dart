import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:workout_player/common_widgets/max_width_raised_button.dart';
import 'package:workout_player/models/images.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/screens/library_tab/workout/add_workout_to_routine_screen.dart';
import 'package:workout_player/services/database.dart';

import '../../../constants.dart';

class WorkoutDetailScreen extends StatefulWidget {
  WorkoutDetailScreen({
    // this.userSavedWorkout,
    // @required this.index,
    @required this.workout,
    @required this.database,
  });

  // final UserSavedWorkout userSavedWorkout;
  // final int index;
  final Workout workout;
  final Database database;

  // For Navigation
  static void show({
    BuildContext context,
    // int index,
    Workout workout,
    bool isRootNavigation,
    // Database database,
    // UserSavedWorkout userSavedWorkout,
  }) async {
    final database = Provider.of<Database>(context, listen: false);
    if (!isRootNavigation) {
      await Navigator.of(context, rootNavigator: false).push(
        CupertinoPageRoute(
          builder: (context) => WorkoutDetailScreen(
            // index: index,
            workout: workout,
            database: database,
            // userSavedWorkout: userSavedWorkout,
          ),
        ),
      );
    } else {
      await Navigator.of(context, rootNavigator: true).push(
        CupertinoPageRoute(
          builder: (context) => WorkoutDetailScreen(
            // index: index,
            workout: workout,
            database: database,
            // userSavedWorkout: userSavedWorkout,
          ),
        ),
      );
    }
  }

  @override
  _WorkoutDetailScreenState createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  PageController _pageController = PageController();

  // For SliverApp to work
  ScrollController _scrollController;
  bool lastStatus = true;

  _scrollListener() {
    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  bool get isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (650 - kToolbarHeight);
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }
  // For SliverApp to work

  // Future<void> _toggleFavorites(BuildContext context) async {
  //   try {
  //     final database = Provider.of<Database>(context, listen: false);
  //     await database.setSavedWorkout(SavedWorkout(
  //       isFavorite: !widget.userSavedWorkout.isSavedWorkout,
  //       workoutId: widget.userSavedWorkout.workout.workoutId,
  //     ));
  //     HapticFeedback.mediumImpact();
  //     showFlushBar(
  //       context: context,
  //       message: (widget.userSavedWorkout.isSavedWorkout)
  //           ? 'Removed from Favorites'
  //           : 'Saved to Favorites',
  //     );
  //   } on Exception catch (e) {
  //     // TODO
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    // final model = Provider.of<UserSavedWorkoutModel>(context, listen: false);

    return StreamBuilder<Workout>(
      initialData: widget.workout,
      stream: database.workoutStream(workoutId: widget.workout.workoutId),
      // stream: model.userSavedWorkoutStream(widget.workout.workoutId),
      builder: (context, snapshot) {
        final workout = snapshot.data;

        // return DefaultTabController(
        //   length: 2,
        //   child: Scaffold(
        return Scaffold(
          backgroundColor: BackgroundColor,
          body: Stack(
            children: [
              CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildSliverAppBar(context, workout),
                  // _buildSliverToBoxAdapter(workout),
                ],
              ),
            ],
          ),
          // body: NestedScrollView(
          //   controller: _scrollController,
          //   headerSliverBuilder:
          //       (BuildContext context, bool innerBoxIsScrolled) {
          //     return <Widget>[
          //       _buildSliverAppBar(context, workout),
          //     ];
          //   },
          //   body: TabBarView(
          //     children: [
          //       Placeholder(),
          //       Placeholder(),
          //     ],
          //   ),
          // ),
          // ),
        );
      },
    );
  }

  Widget _buildSliverAppBar(BuildContext context, Workout workout) {
    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_rounded,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      backgroundColor: BackgroundColor,
      floating: false,
      pinned: true,
      snap: false,
      stretch: true,
      expandedHeight: size.height * 4 / 5,
      centerTitle: true,
      title: isShrink ? Text(workout.workoutTitle, style: Subtitle1) : null,
      // bottom: TabBar(
      //   labelColor: Colors.white,
      //   unselectedLabelColor: Grey400,
      //   indicatorColor: PrimaryColor,
      //   tabs: [
      //     Tab(text: 'Instructions'),
      //     Tab(text: 'Histories'),
      //   ],
      // ),
      actions: <Widget>[
        // IconButton(
        //   // icon: Icon(Icons.favorite_border_rounded),
        //   icon: Icon(
        //     (widget.userSavedWorkout.isSavedWorkout)
        //         ? Icons.favorite_rounded
        //         : Icons.favorite_border_rounded,
        //     color: (widget.userSavedWorkout.isSavedWorkout)
        //         ? PrimaryColor
        //         : Colors.white,
        //   ),
        //   onPressed: () => _toggleFavorites(context),
        // ),
        SizedBox(width: 8),
      ],
      flexibleSpace: _buildFlexibleSpace(workout),
    );
  }

  Widget _buildFlexibleSpace(Workout workout) {
    final size = MediaQuery.of(context).size;

    final workoutTitle = workout?.workoutTitle ?? 'NULL';
    final mainMuscleGroup = workout?.mainMuscleGroup[0] ?? 'NULL';
    final equipmentRequired = workout?.equipmentRequired[0] ?? 'NULL';
    final difficultyString = difficulty.values[workout?.difficulty ?? 2].label;
    final workoutOwnerUserName = workout?.workoutOwnerUserName ?? 'NULL';
    final description = workout?.description ?? 'Add description';
    final imageIndex = workout?.imageIndex ?? 0;

    return FlexibleSpaceBar(
      background: Stack(
        fit: StackFit.passthrough,
        children: [
          Hero(
            tag: 'workout${widget.workout.workoutId}',
            child: Image.asset(
              ImageList[imageIndex],
              fit: BoxFit.fitHeight,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.0, -0.5),
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  BackgroundColor,
                ],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                workoutTitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.blackHanSans(
                  color: Colors.white,
                  fontSize: 40,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    // Main Muscle Group
                    Container(
                      width: 88,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Muscle Group',
                            style: Caption1Grey,
                          ),
                          SizedBox(height: 8),
                          Text(
                            mainMuscleGroup,
                            style: Subtitle2,
                          ),
                        ],
                      ),
                    ),

                    Container(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                      height: 40,
                      margin: EdgeInsets.symmetric(horizontal: 8),
                    ),

                    // Equipment Required
                    Container(
                      width: 88,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Equipment',
                            style: Caption1Grey,
                          ),
                          SizedBox(height: 8),
                          Text(equipmentRequired, style: Subtitle2),
                        ],
                      ),
                    ),

                    Container(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                      height: 40,
                      margin: EdgeInsets.symmetric(horizontal: 8),
                    ),

                    // Experience Level
                    Container(
                      width: 88,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Difficulty',
                            style: Caption1Grey,
                          ),
                          SizedBox(height: 8),
                          Text(difficultyString, style: Subtitle2),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Text(
                  description,
                  style: BodyText2LightGrey,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
                SizedBox(height: 24),
                MaxWidthRaisedButton(
                  color: Grey800,
                  icon: Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  buttonText: 'Add workout to the routine',
                  onPressed: () => AddWorkoutToRoutineScreen.show(
                    context,
                    workout: workout,
                  ),
                ),
                SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverToBoxAdapter(Workout workout) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInstructions(),
            SizedBox(height: 24),
            _buildWorkoutHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Instructions', style: Headline6),
        SizedBox(height: 8),
        Container(
          height: 500,
          child: PageView(
            controller: _pageController,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '1. Vestibulum non suscipit lacus',
                    style: Subtitle1,
                  ),
                  SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Placeholder()),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '2. eget maximus lacus. Vestibulum',
                    style: Subtitle1,
                  ),
                  SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Placeholder()),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 16),
        Container(
          height: 24,
          alignment: Alignment.center,
          child: SmoothPageIndicator(
            controller: _pageController,
            count: 2,
            effect: ScrollingDotsEffect(
              activeDotScale: 1.5,
              dotHeight: 8,
              dotWidth: 8,
              dotColor: Colors.white.withOpacity(.3),
              activeDotColor: PrimaryColor,
            ),
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildWorkoutHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('History', style: Headline6),
        SizedBox(height: 8),
        Container(
          child: Card(
            color: CardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Placeholder(),
            ),
          ),
        ),
      ],
    );
  }
}
