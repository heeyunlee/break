import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:workout_player/common_widgets/max_width_raised_button.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/services/database.dart';

import '../../../common_widgets/appbar_blur_bg.dart';
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
    // Database database,
    // UserSavedWorkout userSavedWorkout,
  }) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
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
        _scrollController.offset > (280 - kToolbarHeight);
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
      stream: database.workoutStream(workoutId: widget.workout.workoutId),
      // stream: model.userSavedWorkoutStream(widget.workout.workoutId),
      builder: (context, snapshot) {
        final workout = snapshot.data;
        return Scaffold(
          backgroundColor: BackgroundColor,
          body: CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: <Widget>[
              _buildSliverAppBar(context, workout),
              _buildSliverToBoxAdapter(workout),
            ],
          ),
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
      centerTitle: true,
      title: isShrink ? Text(workout.workoutTitle, style: Subtitle1) : null,
      actions: (isShrink == false)
          ? <Widget>[
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
            ]
          : null,
      backgroundColor: Colors.transparent,
      floating: false,
      pinned: true,
      snap: false,
      stretch: true,
      expandedHeight: size.height * 2 / 5,
      flexibleSpace: isShrink
          ? AppbarBlurBG()
          : FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.passthrough,
                children: [
                  // Hero(
                  //   tag: 'workout${widget.workout.workoutId}',
                  //   child: (workout.imageUrl == "" || workout.imageUrl == null)
                  //       ? Container()
                  //       : Image.network(
                  //           workout.imageUrl,
                  //           fit: BoxFit.fitHeight,
                  //         ),
                  // ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: size.width - 32,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          workout.workoutTitle,
                          style: GoogleFonts.blackHanSans(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              width: 80,
                              child: Column(
                                children: <Widget>[
                                  // TODO: Add icon for Main Muscle Group
                                  ConstrainedBox(
                                    child: Placeholder(
                                      color: Colors.white,
                                    ),
                                    constraints: BoxConstraints(
                                      maxHeight: 24,
                                      maxWidth: 24,
                                    ),
                                  ),
                                  // TODO: Add icon for Main Muscle Group
                                  SizedBox(height: 16),
                                  Text(
                                    workout.mainMuscleGroup,
                                    style: Subtitle2,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 80,
                              child: Column(
                                children: <Widget>[
                                  // TODO: Add icon for Equipment Required
                                  Icon(
                                    Icons.fitness_center_rounded,
                                    color: Colors.white,
                                  ),
                                  // TODO: Add icon for Equipment Required
                                  SizedBox(height: 16),
                                  Text(
                                    workout.equipmentRequired,
                                    style: Subtitle2,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 80,
                              child: Column(
                                children: <Widget>[
                                  // TODO: Add icon for Secondary Muscle Group
                                  ConstrainedBox(
                                    child: Placeholder(
                                      color: Colors.white,
                                    ),
                                    constraints: BoxConstraints(
                                      maxHeight: 24,
                                      maxWidth: 24,
                                    ),
                                  ),
                                  // TODO: Add icon for Secondary Muscle Group
                                  SizedBox(height: 16),
                                  Text(
                                    workout.secondaryMuscleGroup[0],
                                    style: Subtitle2,
                                    maxLines: 1,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
            SizedBox(height: 8),
            MaxWidthRaisedButton(
              color: Grey800,
              icon: Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 20,
              ),
              buttonText: '루틴에 운동 추가하기',
              onPressed: () {},
            ),
            SizedBox(height: 24),
            Text(
              (workout.description == null)
                  ? 'null... add description'
                  : workout.description,
              style: Subtitle2,
              maxLines: 3,
            ),
            SizedBox(height: 24),
            Divider(
              endIndent: 8,
              indent: 8,
              color: Grey700,
            ),
            SizedBox(height: 24),
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
