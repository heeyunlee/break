import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/max_width_raised_button.dart';
import 'package:workout_player/dummy_data.dart';
import 'package:workout_player/format.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../../constants.dart';
import 'add_workout_to_routine_screen.dart';
import 'edit_workout/edit_workout_screen.dart';

class WorkoutDetailScreen extends StatefulWidget {
  WorkoutDetailScreen({
    @required this.workout,
    @required this.database,
    @required this.user,
    this.tag = 'tag',
  });

  final Workout workout;
  final Database database;
  final User user;
  final String tag;

  // For Navigation
  static void show(
    BuildContext context, {
    Workout workout,
    bool isRootNavigation,
    String tag,
  }) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);

    HapticFeedback.mediumImpact();

    if (!isRootNavigation) {
      await Navigator.of(context, rootNavigator: false).push(
        CupertinoPageRoute(
          builder: (context) => WorkoutDetailScreen(
            workout: workout,
            database: database,
            user: auth.currentUser,
            tag: tag,
          ),
        ),
      );
    } else {
      await Navigator.of(context, rootNavigator: true).pushReplacement(
        CupertinoPageRoute(
          builder: (context) => WorkoutDetailScreen(
            workout: workout,
            database: database,
            user: auth.currentUser,
            tag: tag,
          ),
        ),
      );
    }
  }

  @override
  _WorkoutDetailScreenState createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  // PageController _pageController = PageController();

  @override
  void initState() {
    // TODO: implement initState
    debugPrint('workout detail screen init');
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    debugPrint('workout detail screen dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return StreamBuilder<Workout>(
      initialData: workoutDummyData,
      stream: database.workoutStream(workoutId: widget.workout.workoutId),
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
        icon: const Icon(
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
      // title: isShrink ? Text(workout.workoutTitle, style: Subtitle1) : null,
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
        if (widget.user.uid == workout.workoutOwnerId)
          IconButton(
            icon: const Icon(Icons.edit_rounded, color: Colors.white),
            onPressed: () => EditWorkoutScreen.show(
              context: context,
              workout: workout,
            ),
          ),
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
        const SizedBox(width: 8),
      ],
      flexibleSpace: _buildFlexibleSpace(workout),
    );
  }

  Widget _buildFlexibleSpace(Workout workout) {
    final workoutTitle = workout?.workoutTitle ?? 'NULL';
    final mainMuscleGroup = workout?.mainMuscleGroup[0] ?? 'NULL';
    final equipmentRequired = workout?.equipmentRequired[0] ?? 'NULL';
    final difficulty = Format.difficulty(workout.difficulty);
    final description = workout?.description ?? 'Add description';

    return FlexibleSpaceBar(
      background: Stack(
        fit: StackFit.passthrough,
        children: [
          Hero(
            tag: widget.tag,
            child: CachedNetworkImage(
              imageUrl: widget.workout.imageUrl,
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.0, -0.5),
                end: Alignment.bottomCenter,
                colors: [
                  BackgroundColor.withOpacity(0.5),
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
                          const Text('Muscle Group', style: Caption1Grey),
                          const SizedBox(height: 8),
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
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                    ),

                    // Equipment Required
                    Container(
                      width: 88,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text('Equipment', style: Caption1Grey),
                          const SizedBox(height: 8),
                          Text(equipmentRequired, style: Subtitle2),
                        ],
                      ),
                    ),

                    Container(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                      height: 40,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                    ),

                    // Experience Level
                    Container(
                      width: 88,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text('Difficulty', style: Caption1Grey),
                          const SizedBox(height: 8),
                          Text(difficulty, style: Subtitle2),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  description,
                  style: BodyText2LightGrey,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
                const SizedBox(height: 24),
                MaxWidthRaisedButton(
                  color: Grey800,
                  icon: const Icon(
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
                // SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildSliverToBoxAdapter(Workout workout) {
  //   return SliverToBoxAdapter(
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           _buildInstructions(),
  //           SizedBox(height: 24),
  //           _buildWorkoutHistory(),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildInstructions() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text('Instructions', style: Headline6),
  //       const SizedBox(height: 8),
  //       Container(
  //         height: 500,
  //         child: PageView(
  //           controller: _pageController,
  //           children: <Widget>[
  //             Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 const Text(
  //                   '1. Vestibulum non suscipit lacus',
  //                   style: Subtitle1,
  //                 ),
  //                 const SizedBox(height: 4),
  //                 const Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: const Center(child: Placeholder()),
  //                 ),
  //               ],
  //             ),
  //             Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 const Text(
  //                   '2. eget maximus lacus. Vestibulum',
  //                   style: Subtitle1,
  //                 ),
  //                 const SizedBox(height: 4),
  //                 const Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: const Center(child: Placeholder()),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ),
  //       const SizedBox(height: 16),
  //       Container(
  //         height: 24,
  //         alignment: Alignment.center,
  //         child: SmoothPageIndicator(
  //           controller: _pageController,
  //           count: 2,
  //           effect: ScrollingDotsEffect(
  //             activeDotScale: 1.5,
  //             dotHeight: 8,
  //             dotWidth: 8,
  //             dotColor: Colors.white.withOpacity(0.3),
  //             activeDotColor: PrimaryColor,
  //           ),
  //         ),
  //       ),
  //       SizedBox(height: 16),
  //     ],
  //   );
  // }

  // Widget _buildWorkoutHistory() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: <Widget>[
  //       const Text('History', style: Headline6),
  //       const SizedBox(height: 8),
  //       Container(
  //         child: Card(
  //           color: CardColor,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(10),
  //           ),
  //           child: const Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: const Placeholder(),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
