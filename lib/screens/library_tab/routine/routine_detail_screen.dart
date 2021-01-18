import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/show_flush_bar.dart';

import '../../../common_widgets/appbar_blur_bg.dart';
import '../../../common_widgets/list_item_builder.dart';
import '../../../common_widgets/max_width_raised_button.dart';
import '../../../constants.dart';
import '../../../models/routine.dart';
import '../../../models/routine_workout.dart';
import '../../../services/database.dart';
import 'add_workouts_to_routine.dart';
import 'edit_playlist_screen.dart';
import 'workout_medium_card.dart';

class RoutineDetailScreen extends StatefulWidget {
  static const routeName = '/playlist-detail';
  RoutineDetailScreen({
    @required this.routineId,
    this.database,
  });

  final String routineId;
  final Database database;

  // For Navigation
  static void show(BuildContext context, String routineId) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context, rootNavigator: false).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => RoutineDetailScreen(
          database: database,
          routineId: routineId,
        ),
      ),
    );
  }

  @override
  _RoutineDetailScreenState createState() => _RoutineDetailScreenState();
}

class _RoutineDetailScreenState extends State<RoutineDetailScreen> {
  // For SnackBars
  // final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  final isFavorite = false;

  // For SliverApp to Work
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
        _scrollController.offset > (340 - kToolbarHeight);
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
  // For SliverApp to Work

  // Favorite
  Future<void> _toggleFavorites(BuildContext context, bool isFavorite) {
    if (isFavorite == false) HapticFeedback.mediumImpact();
    setState(() {
      isFavorite = !isFavorite;
    });
    showFlushBar(
      context: context,
      message: (isFavorite == false)
          ? 'Removed from Favorites'
          : 'Saved to Favorites',
    );
  }

  @override
  Widget build(BuildContext context2) {
    return StreamBuilder<Routine>(
        stream: widget.database.routineStream(routineId: widget.routineId),
        builder: (context, snapshot) {
          final routine = snapshot.data;

          return Scaffold(
            // key: scaffoldKey,
            backgroundColor: BackgroundColor,
            body: Stack(
              children: [
                CustomScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    _buildSliverAppBar(routine),
                    _buildSliverToBoxAdapter(routine),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Widget _buildSliverAppBar(Routine routine) {
    final size = MediaQuery.of(context).size;

    final routineTitle = routine?.routineTitle ?? 'Add Title';
    final tag = routine?.routineId ?? 'routineId';
    debugPrint('tag is $tag');
    final imageUrl = routine?.imageUrl ?? '';
    final mainMuscleGroup = routine?.mainMuscleGroup ?? 'Main Muscle Group';
    final equipmentRequired = routine?.equipmentRequired ?? 'equipmentRequired';
    final secondMuscleGroup = routine?.secondMuscleGroup ?? 'secondMuscleGroup';

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
      title: isShrink ? Text(routineTitle, style: Subtitle1) : null,
      actions: (isShrink == false)
          ? <Widget>[
              IconButton(
                icon: Icon(
                  (isFavorite == true)
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: (isFavorite == true) ? PrimaryColor : Colors.white,
                ),
                onPressed: () => _toggleFavorites(context, isFavorite),
              ),
              // TODO: Add share button
              // IconButton(
              //   icon: Icon(Icons.ios_share),
              //   onPressed: () {},
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
                  Hero(
                    tag: 'playlist${widget.routineId}',
                    child: (imageUrl == "" || imageUrl == null)
                        ? Container()
                        : Image.network(
                            imageUrl,
                            fit: BoxFit.fitHeight,
                          ),
                  ),
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
                          routineTitle,
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
                                  SizedBox(height: 16),
                                  Text(
                                    mainMuscleGroup,
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
                                  Text(equipmentRequired, style: Subtitle2),
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
                                    secondMuscleGroup,
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
                  SizedBox(height: 16),
                ],
              ),
            ),
    );
  }

  Widget _buildSliverToBoxAdapter(Routine routine) {
    final database = Provider.of<Database>(context, listen: false);
    final routineOwnerUserName =
        routine?.routineOwnerUserName ?? 'routineOwnerUserName';
    final duration = routine?.duration ?? '0';
    final description = routine?.description ?? 'description';

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(routineOwnerUserName, style: Subtitle2Bold),
                    SizedBox(height: 4),
                    Row(
                      children: <Widget>[
                        Text(
                          '5,455 Players',
                          style: BodyText2Light,
                        ),
                        SizedBox(width: 8),
                        Text('•', style: BodyText2Light),
                        SizedBox(width: 8),
                        Text('총 $duration 분', style: BodyText2Light),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.edit_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    EditPlaylistScreen.show(
                      context,
                      routine: routine,
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(description, style: BodyText2LightGrey, maxLines: 3),
            // SizedBox(height: 16),
            // MaxWidthRaisedButton(
            //   color: Primary400Color,
            //   icon: Icon(
            //     Icons.play_arrow_rounded,
            //     color: Colors.white,
            //   ),
            //   // TODO: ADD ONPRESSED NAVIGATION
            //   onPressed: () {},
            //   buttonText: '운동 시작하기',
            // ),
            SizedBox(height: 16),
            Divider(
              endIndent: 8,
              indent: 8,
              color: Colors.white.withOpacity(0.1),
            ),
            SizedBox(height: 8),
            StreamBuilder<List<RoutineWorkout>>(
              stream: database.routineWorkoutsStream(routine),
              builder: (context, snapshot) {
                return ListItemBuilder<RoutineWorkout>(
                  emptyContentTitle: '루틴에 운동을 추가하세요!',
                  snapshot: snapshot,
                  itemBuilder: (context, routineWorkout) => WorkoutMediumCard(
                    database: database,
                    routine: routine,
                    routineWorkout: routineWorkout,
                  ),
                );
              },
            ),
            SizedBox(height: 8),
            Divider(
              endIndent: 8,
              indent: 8,
              color: Colors.white.withOpacity(0.1),
            ),
            SizedBox(height: 16),
            MaxWidthRaisedButton(
              icon: Icon(
                Icons.add_rounded,
                color: Colors.white,
              ),
              buttonText: '운동 추가하기',
              color: CardColor,
              onPressed: () {
                AddWorkoutsToRoutine.show(
                  context,
                  routine: routine,
                );
              },
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
