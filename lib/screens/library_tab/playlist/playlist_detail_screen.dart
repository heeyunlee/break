import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/common_widgets/list_item_builder.dart';
import 'package:workout_player/common_widgets/max_width_raised_button.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/services/database.dart';

import '../../../constants.dart';
import 'add_workouts_to_routine.dart';
import 'edit_playlist_screen.dart';
import 'workout_medium_card.dart';

class PlaylistDetailScreen extends StatefulWidget {
  static const routeName = '/playlist-detail';
  PlaylistDetailScreen({
    @required this.index,
    @required this.routine,
  });

  final int index;
  final Routine routine;

  // For Navigation
  static void show({
    BuildContext context,
    int index,
    Routine routine,
  }) async {
    await Navigator.of(context).push(
      CupertinoPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (context) => PlaylistDetailScreen(
          index: index,
          routine: routine,
        ),
      ),
    );
  }

  @override
  _PlaylistDetailScreenState createState() => _PlaylistDetailScreenState();
}

class _PlaylistDetailScreenState extends State<PlaylistDetailScreen> {
  bool isFavorite = false;

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
  // For SliverApp to Work

  @override
  Widget build(BuildContext context2) {
    return Scaffold(
      backgroundColor: BackgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildSliverAppBar(),
              _buildSliverToBoxAdapter(),
            ],
          ),
        ],
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
      title:
          isShrink ? Text(widget.routine.routineTitle, style: Subtitle1) : null,
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            (isFavorite == true)
                ? Icons.favorite_rounded
                : Icons.favorite_border_rounded,
            color: (isFavorite == true) ? PrimaryColor : Colors.white,
          ),
          onPressed: () {
            if (isFavorite == false) HapticFeedback.mediumImpact();
            setState(() {
              isFavorite = !isFavorite;
            });
          },
        ),
        if (isShrink == false)
          IconButton(
            icon: Icon(
              Icons.more_vert_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              EditPlaylistScreen.show(
                context,
                routine: widget.routine,
              );
            },
          ),
        // TODO: Add share button
        // IconButton(
        //   icon: Icon(Icons.ios_share),
        //   onPressed: () {},
        // ),
        SizedBox(width: 8),
      ],
      backgroundColor: Colors.transparent,
      floating: false,
      pinned: true,
      snap: false,
      stretch: true,
      expandedHeight: size.height / 3,
      flexibleSpace: isShrink
          ? AppbarBlurBG()
          : FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.passthrough,
                children: [
                  Hero(
                    tag: 'playlist${widget.routine.routineId}',
                    child: (widget.routine.imageUrl == "" ||
                            widget.routine.imageUrl == null)
                        ? Container()
                        : Image.network(
                            widget.routine.imageUrl,
                            fit: BoxFit.fitHeight,
                          ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0.2),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  if (widget.routine.imageUrl == "" ||
                      widget.routine.imageUrl == null)
                    FlatButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_a_photo_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(width: 16),
                          Text(
                            'Add a cover photo',
                            style: ButtonText,
                          ),
                        ],
                      ),
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                      },
                    ),
                  Positioned(
                    left: 16,
                    bottom: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.routine.routineTitle, style: Headline5Bold),
                        SizedBox(height: 8),
                        Text(widget.routine.routineOwnerId,
                            style: Subtitle1BoldGrey),
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
        padding: const EdgeInsets.all(16),
        child: Stack(
          overflow: Overflow.visible,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row(
                //   children: <Widget>[
                //     Text(
                //       '평균 약 ${widget.routine.duration}분',
                //       style: BodyText2Light,
                //     ),
                //     Text(' • ', style: BodyText2Light),
                //     Text(
                //       '${widget.routine.totalWeights} Kg',
                //       style: BodyText2Light,
                //     ),
                //   ],
                // ),
                SizedBox(height: 4),
                Text(
                  widget.routine.description,
                  style: Subtitle2,
                  maxLines: 3,
                ),
                SizedBox(height: 8),
                // Row(
                //   children: [
                //     TagWidget(widget.routine.secondMuscleGroup[0]),
                //     SizedBox(width: 8),
                //     if (widget.routine.secondMuscleGroup[1] != null)
                //       TagWidget(widget.routine.secondMuscleGroup[1]),
                //     SizedBox(width: 8),
                //     if (widget.routine.secondMuscleGroup[2] != null)
                //       TagWidget(widget.routine.secondMuscleGroup[2]),
                //   ],
                // ),
                SizedBox(height: 24),
                MaxWidthRaisedButton(
                  color: Primary400Color,
                  icon: Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                  ),
                  // TODO: ADD ONPRESSED NAVIGATION
                  onPressed: () {},
                  buttonText: '운동 시작하기',
                ),
                SizedBox(height: 16),
                Divider(
                  endIndent: 8,
                  indent: 8,
                  color: Colors.white.withOpacity(0.1),
                ),
                SizedBox(height: 8),
                StreamBuilder<List<RoutineWorkout>>(
                  stream: database.routineWorkoutsStream(widget.routine),
                  builder: (context, snapshot) {
                    return ListItemBuilder<RoutineWorkout>(
                      emptyContentTitle: '루틴에 운동을 추가하세요!',
                      snapshot: snapshot,
                      itemBuilder: (context, routineWorkout) =>
                          WorkoutMediumCard(
                        workoutTitle: routineWorkout.workoutTitle,
                        numberOfSets: routineWorkout.numberOfSets,
                        numberOfReps: routineWorkout.numberOfReps,
                        sets: routineWorkout.sets,
                      ),
                    );
                  },
                ),
                SizedBox(height: 16),
                Divider(
                  endIndent: 8,
                  indent: 8,
                  color: Colors.white.withOpacity(0.1),
                ),
                SizedBox(height: 24),
                MaxWidthRaisedButton(
                  icon: Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                  ),
                  buttonText: '운동 추가하기',
                  color: CardColor,
                  onPressed: () {
                    AddWorkoutsToRoutine.show(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
