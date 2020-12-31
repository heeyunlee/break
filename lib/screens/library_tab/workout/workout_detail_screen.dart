import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:workout_player/common_widgets/max_width_raised_button.dart';

import '../../../common_widgets/appbar_blur_bg.dart';
import '../../../constants.dart';
import '../../../models/workout.dart';
import '../../../services/database.dart';

class WorkoutDetailScreen extends StatefulWidget {
  WorkoutDetailScreen({
    @required this.index,
    @required this.workout,
  });

  final int index;
  final Workout workout;

  // For Navigation
  static void show({
    BuildContext context,
    int index,
    Workout workout,
  }) async {
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => WorkoutDetailScreen(
          index: index,
          workout: workout,
        ),
      ),
    );
  }

  @override
  _WorkoutDetailScreenState createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  PageController _pageController = PageController();

  bool isFavorite = false;

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
        _scrollController.offset > (330 - kToolbarHeight);
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: BackgroundColor,
        body: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            _buildSliverAppBar(),
            _buildSliverToBoxAdapter(),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
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
      title:
          isShrink ? Text(widget.workout.workoutTitle, style: Subtitle1) : null,
      actions: <Widget>[
        IconButton(
          icon: (isFavorite == false)
              ? Icon(Icons.bookmark_border_rounded)
              : Icon(Icons.bookmark_rounded),
          onPressed: () {
            setState(() {
              isFavorite = !isFavorite;
            });
          },
        ),
        SizedBox(width: 8),
      ],
      backgroundColor: Colors.transparent,
      floating: false,
      pinned: true,
      snap: false,
      stretch: true,
      expandedHeight: size.height * 1 / 2,
      // bottom: TabBar(
      //   labelColor: Colors.white,
      //   unselectedLabelColor: Grey400,
      //   indicatorColor: PrimaryColor,
      //   tabs: [
      //     Tab(text: '운동'),
      //     Tab(text: '루틴'),
      //   ],
      // ),
      flexibleSpace: isShrink
          ? AppbarBlurBG()
          : FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.passthrough,
                children: [
                  Hero(
                    tag: 'workoutTagForSearch-${widget.workout.workoutId}',
                    child: (widget.workout.imageUrl == "" ||
                            widget.workout.imageUrl == null)
                        ? Image.asset(
                            'images/place_holder_workout_playlist.png')
                        : Image.network(
                            widget.workout.imageUrl,
                            fit: BoxFit.fitHeight,
                          ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.8),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      widget.workout.workoutTitle,
                      style: GoogleFonts.blackHanSans(
                        color: Colors.white,
                        fontSize: 40,
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
                                  SizedBox(height: 16),
                                  Text(
                                    widget.workout.mainMuscleGroup,
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
                                  SizedBox(height: 16),
                                  Text(
                                    widget.workout.equipmentRequired,
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
                                  SizedBox(height: 16),
                                  Text(
                                    widget.workout.secondaryMuscleGroup[0],
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

  Widget _buildSliverToBoxAdapter() {
    final database = Provider.of<Database>(context, listen: false);

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
              (widget.workout.description == null)
                  ? 'null... add description'
                  : widget.workout.description,
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
            // Center(
            //   child: FlatButton(
            //     color: Colors.grey,
            //     onPressed: () {
            //       pushNewScreen(
            //         context,
            //         screen: EditWorkoutScreen(
            //           database: database,
            //           workout: widget.workout,
            //         ),
            //         withNavBar: false,
            //       );
            //     },
            //     child: Text(
            //       '수정하기',
            //       style: ButtonText,
            //     ),
            //   ),
            // )
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

  // Widget _showModalBottomSheet(BuildContext context) {
  //   return CupertinoActionSheet(
  //     actions: <Widget>[
  //       CupertinoActionSheetAction(
  //         child: Text('운동 수정'),
  //         onPressed: () =>
  //             EditWorkoutScreen.show(context, workout: widget.workout),
  //         // onPressed: () {
  //         //   pushNewScreen(
  //         //     context,
  //         //     pageTransitionAnimation: PageTransitionAnimation.slideUp,
  //         //     screen: EditWorkoutScreen(
  //         //       workout: widget.workout,
  //         //     ),
  //         //     withNavBar: false,
  //         //   );
  //         // },
  //         isDefaultAction: true,
  //       ),
  //     ],
  //     cancelButton: CupertinoActionSheetAction(
  //       isDestructiveAction: true,
  //       child: Text('취소'),
  //       onPressed: () {
  //         Navigator.of(context).pop();
  //       },
  //     ),
  //   );
  // }
}
