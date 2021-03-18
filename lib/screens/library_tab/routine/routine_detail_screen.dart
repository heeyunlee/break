import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/screens/during_workout/during_workout_screen.dart';
import 'package:workout_player/services/auth.dart';

import '../../../common_widgets/list_item_builder.dart';
import '../../../common_widgets/max_width_raised_button.dart';
import '../../../constants.dart';
import '../../../dummy_data.dart';
import '../../../format.dart';
import '../../../models/routine.dart';
import '../../../models/routine_workout.dart';
import '../../../services/database.dart';
import 'add_workouts_to_routine.dart';
import 'edit_routine/edit_routine_screen.dart';
import 'workout_medium_card.dart';

Logger logger = Logger();

class RoutineDetailScreen extends StatefulWidget {
  static const routeName = '/playlist-detail';
  RoutineDetailScreen({
    this.database,
    this.routine,
    this.tag,
    this.auth,
  });

  final Database database;
  final Routine routine;
  final String tag;
  final AuthBase auth;

  // For Navigation
  static Future<void> show(
    BuildContext context, {
    Routine routine,
    bool isRootNavigation = false,
    String tag,
  }) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);

    await HapticFeedback.mediumImpact();

    if (!isRootNavigation) {
      await Navigator.of(context, rootNavigator: false).push(
        CupertinoPageRoute(
          builder: (context) => RoutineDetailScreen(
            database: database,
            routine: routine,
            auth: auth,
            tag: tag,
          ),
        ),
      );
    } else {
      await Navigator.of(context, rootNavigator: true).pushReplacement(
        CupertinoPageRoute(
          fullscreenDialog: false,
          builder: (context) => RoutineDetailScreen(
            database: database,
            routine: routine,
            auth: auth,
          ),
        ),
      );
    }
  }

  @override
  _RoutineDetailScreenState createState() => _RoutineDetailScreenState();
}

class _RoutineDetailScreenState extends State<RoutineDetailScreen>
    with TickerProviderStateMixin {
  // Database database;
  // AuthBase auth;

  // For SliverApp to Work
  AnimationController _colorAnimationController;
  AnimationController _textAnimationController;
  Animation _colorTween;
  Animation<Offset> _transTween;

  bool _scrollListener(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.vertical) {
      _colorAnimationController.animateTo(scrollInfo.metrics.pixels);

      _textAnimationController
          .animateTo((scrollInfo.metrics.pixels - 130) / 50);
      return true;
    }
    return false;
  }

  @override
  void initState() {
    // database = Provider.of<Database>(context, listen: false);
    // auth = Provider.of<AuthBase>(context, listen: false);

    _colorAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    _textAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    _colorTween = ColorTween(begin: Colors.transparent, end: AppBarColor)
        .animate(_colorAnimationController);
    _transTween = Tween(begin: Offset(-10, 40), end: Offset(-10, 0))
        .animate(_textAnimationController);
    super.initState();
  }

  @override
  void dispose() {
    _colorAnimationController.dispose();
    _textAnimationController.dispose();
    super.dispose();
  }
  // For SliverApp to Work

  @override
  Widget build(BuildContext context) {
    debugPrint('scaffold building...');

    return StreamBuilder<Routine>(
        initialData: routineDummyData,
        stream: widget.database.routineStream(
          routineId: widget.routine.routineId,
        ),
        builder: (context, snapshot) {
          final routine = snapshot.data;

          return Scaffold(
            backgroundColor: BackgroundColor,
            body: NotificationListener<ScrollNotification>(
              onNotification: _scrollListener,
              child: Stack(
                children: [
                  CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      _buildSliverAppBar(routine),
                      _buildSliverToBoxAdaptor(context, routine),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildSliverAppBar(Routine routine) {
    debugPrint('_buildSliverAppBar');

    final size = MediaQuery.of(context).size;

    final routineTitle = routine?.routineTitle ?? 'Add Title';

    return AnimatedBuilder(
      animation: _colorAnimationController,
      builder: (context, child) => SliverAppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Transform.translate(
          offset: _transTween.value,
          child: Text(routineTitle, style: Subtitle1),
        ),
        backgroundColor: _colorTween.value,
        floating: false,
        pinned: true,
        snap: false,
        stretch: true,
        expandedHeight: size.height * 1 / 5,
        flexibleSpace: _FlexibleSpaceBarWidget(
          routine: widget.routine,
          tag: widget.tag,
        ),
      ),
    );
  }

  Widget _buildSliverToBoxAdaptor(BuildContext context, Routine routine) {
    final routineTitle = routine?.routineTitle ?? 'Add Title';
    final routineOwnerUserName =
        routine?.routineOwnerUserName ?? 'routineOwnerUserName';
    final description =
        (routine.description == null || routine.description.isNotEmpty
            ? 'Add description'
            : routine.description);
    final lastEditedDate = Format.dateShort(routine.lastEditedDate);
    final weights = Format.weights(routine.totalWeights);
    final unitOfMass = Format.unitOfMass(routine.initialUnitOfMass);

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(
              routineTitle,
              style: GoogleFonts.blackHanSans(
                color: Colors.white,
                fontSize: 34,
              ),
              maxLines: 1,
              overflow: TextOverflow.fade,
              softWrap: false,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      routineOwnerUserName,
                      style: Subtitle2Bold,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: <Widget>[
                        Text(
                          weights + ' ' + unitOfMass,
                          style: BodyText2Light,
                        ),
                        const SizedBox(width: 8),
                        const Text('•', style: BodyText2Light),
                        const SizedBox(width: 8),
                        Text(
                          'Last Edited on $lastEditedDate',
                          style: BodyText2Light,
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                if (widget.auth.currentUser.uid == routine.routineOwnerId)
                  IconButton(
                    icon: const Icon(
                      Icons.edit_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () => EditRoutineScreen.show(
                      context: context,
                      routine: routine,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: BodyText2LightGrey,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
            ),
            const SizedBox(height: 24),
            MaxWidthRaisedButton(
              color: PrimaryColor,
              icon: const Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
              ),
              onPressed: () => DuringWorkoutScreen.show(
                context,
                routine: routine,
                // user: snapshot.data,
              ),
              buttonText: 'Start Workout',
            ),
            if (widget.auth.currentUser.uid != routine.routineOwnerId)
              const SizedBox(height: 16),
            if (widget.auth.currentUser.uid != routine.routineOwnerId)
              MaxWidthRaisedButton(
                color: Primary400Color,
                onPressed: () => DuringWorkoutScreen.show(
                  context,
                  routine: routine,
                ),
                buttonText: 'Copy this Routine',
              ),
            const SizedBox(height: 16),
            Divider(
              endIndent: 8,
              indent: 8,
              color: Grey800,
            ),
            const SizedBox(height: 8),
            StreamBuilder<List<RoutineWorkout>>(
                stream: widget.database.routineWorkoutsStream(routine),
                builder: (context, snapshot) {
                  return Column(
                    children: [
                      ListItemBuilder<RoutineWorkout>(
                        emptyContentTitle: 'Add workouts to your routine',
                        snapshot: snapshot,
                        itemBuilder: (context, routineWorkout) =>
                            WorkoutMediumCard(
                          database: widget.database,
                          routine: routine,
                          routineWorkout: routineWorkout,
                          // user: user,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (widget.auth.currentUser.uid == routine.routineOwnerId)
                        Divider(
                          endIndent: 8,
                          indent: 8,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      const SizedBox(height: 16),
                      if (widget.auth.currentUser.uid == routine.routineOwnerId)
                        MaxWidthRaisedButton(
                          icon: const Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                          ),
                          buttonText: 'Add workout',
                          color: CardColor,
                          onPressed: () {
                            AddWorkoutsToRoutine.show(
                              context,
                              routine: routine,
                            );
                          },
                        ),
                      const SizedBox(height: 38),
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }
}

class _FlexibleSpaceBarWidget extends StatelessWidget {
  final String tag;
  final Routine routine;

  const _FlexibleSpaceBarWidget({Key key, this.tag, this.routine})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final mainMuscleGroup = routine?.mainMuscleGroup[0] ?? 'Main Muscle Group';
    final equipmentRequired =
        routine?.equipmentRequired[0] ?? 'equipmentRequired';
    final duration = Format.durationInMin(routine.duration);

    return FlexibleSpaceBar(
      background: Stack(
        alignment: Alignment.center,
        fit: StackFit.passthrough,
        children: [
          Hero(
            tag: tag,
            child: CachedNetworkImage(
              imageUrl: routine.imageUrl,
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.0, -0.3),
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  BackgroundColor,
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            child: SizedBox(
              width: size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // Main Muscle Group
                  Column(
                    children: <Widget>[
                      SvgPicture.asset(
                        'assets/icons/icon_bicep.svg',
                        width: 24,
                        height: 24,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        mainMuscleGroup,
                        style: Subtitle2,
                      ),
                    ],
                  ),

                  // Equipment Required
                  Column(
                    children: <Widget>[
                      FaIcon(
                        FontAwesomeIcons.dumbbell,
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(height: 16),
                      Text(equipmentRequired, style: Subtitle2),
                    ],
                  ),

                  // Duration
                  Column(
                    children: <Widget>[
                      FaIcon(
                        FontAwesomeIcons.clock,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '$duration min',
                        style: Subtitle2,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
