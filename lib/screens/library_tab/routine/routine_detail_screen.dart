import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/custom_stream_builder_widget.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/equipment_required.dart';
import 'package:workout_player/models/enum/location.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/screens/during_workout/during_workout_screen.dart';
import 'package:workout_player/screens/library_tab/routine/log_routine/log_routine_screen.dart';
import 'package:workout_player/services/auth.dart';

import '../../../common_widgets/list_item_builder.dart';
import '../../../common_widgets/max_width_raised_button.dart';
import '../../../constants.dart';
import '../../../dummy_data.dart';
import '../../../format.dart';
import '../../../models/routine.dart';
import '../../../models/routine_workout.dart';
import '../../../services/database.dart';
import 'add_workout/add_workouts_to_routine.dart';
import 'edit_routine/edit_routine_screen.dart';
import 'widgets/workout_medium_card.dart';

Logger logger = Logger();
const _bicepImageUrl =
    'https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/320/apple/271/flexed-biceps_1f4aa.png';

class RoutineDetailScreen extends StatefulWidget {
  static const routeName = '/playlist-detail';
  RoutineDetailScreen({
    this.database,
    this.routine,
    this.tag,
    this.auth,
    this.user,
  });

  final Database database;
  final Routine routine;
  final String tag;
  final AuthBase auth;
  final User user;

  // For Navigation
  static Future<void> show(
    BuildContext context, {
    Routine routine,
    bool isRootNavigation = false,
    String tag,
  }) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    final user = await database.userDocument(auth.currentUser.uid);

    await HapticFeedback.mediumImpact();

    if (!isRootNavigation) {
      await Navigator.of(context, rootNavigator: false).push(
        CupertinoPageRoute(
          builder: (context) => RoutineDetailScreen(
            database: database,
            routine: routine,
            auth: auth,
            tag: tag,
            user: user,
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
            user: user,
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
  // For SliverApp to Work
  AnimationController _colorAnimationController;
  AnimationController _textAnimationController;
  Animation _colorTween;
  Animation<Offset> _transTween;

  bool _scrollListener(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.vertical) {
      _colorAnimationController.animateTo(scrollInfo.metrics.pixels);

      _textAnimationController.animateTo((scrollInfo.metrics.pixels - 60) / 50);
      return true;
    }
    return false;
  }

  @override
  void initState() {
    _colorAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    _textAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    _colorTween = ColorTween(begin: Colors.transparent, end: AppBarColor)
        .animate(_colorAnimationController);
    _transTween = Tween(begin: Offset(0, 40), end: Offset(0, 0))
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

    return Scaffold(
      backgroundColor: BackgroundColor,
      body: NotificationListener<ScrollNotification>(
        onNotification: _scrollListener,
        child: CustomStreamBuilderWidget<Routine>(
          initialData: routineDummyData,
          stream: widget.database
              .routineStream(
                routineId: widget.routine.routineId,
              )
              .asBroadcastStream(),
          hasDataWidget: (context, snapshot) {
            final routine = snapshot.data;

            return Stack(
              children: [
                CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    _buildSliverAppBar(routine),
                    _buildSliverToBoxAdaptor(context, routine),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(Routine routine) {
    debugPrint('_buildSliverAppBar');
    final size = MediaQuery.of(context).size;

    final routineTitle = routine.routineTitle ?? 'Add Title';

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
        brightness: Brightness.dark,
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
        actions: [
          IconButton(
            icon: const Icon(
              Icons.bookmark_border_rounded,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
          if (widget.auth.currentUser.uid == routine.routineOwnerId)
            IconButton(
              icon: const Icon(
                Icons.edit_rounded,
                color: Colors.white,
              ),
              onPressed: () => EditRoutineScreen.show(
                context,
                routine: routine,
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }

  Widget _buildSliverToBoxAdaptor(BuildContext context, Routine routine) {
    final size = MediaQuery.of(context).size;

    final trainingLevel = Format.difficulty(routine.trainingLevel);

    final duration = Format.durationInMin(routine.duration);
    final description =
        (routine.description == null || routine.description.isEmpty
            ? S.current.addDescription
            : routine.description);
    final weights = Format.weights(routine.totalWeights);
    final unitOfMass = Format.unitOfMass(routine.initialUnitOfMass);

    String _mainMuscleGroups = '';
    for (var i = 0; i < routine.mainMuscleGroup.length; i++) {
      String _mainMuscleGroup;
      if (i == 0) {
        _mainMuscleGroups = MainMuscleGroup.values
            .firstWhere((e) => e.toString() == routine.mainMuscleGroup[i])
            .translation;
      } else {
        _mainMuscleGroup = MainMuscleGroup.values
            .firstWhere((e) => e.toString() == routine.mainMuscleGroup[i])
            .translation;
        _mainMuscleGroups = _mainMuscleGroups + ', $_mainMuscleGroup';
      }
    }

    String _equipments = '';
    for (var i = 0; i < routine.equipmentRequired.length; i++) {
      String _equipment;
      if (i == 0) {
        _equipments = EquipmentRequired.values
            .firstWhere((e) => e.toString() == routine.equipmentRequired[i])
            .translation;
      } else {
        _equipment = EquipmentRequired.values
            .firstWhere((e) => e.toString() == routine.equipmentRequired[i])
            .translation;
        _equipments = _equipments + ', $_equipment';
      }
    }

    String location;
    if (routine.location != null) {
      var _location = Location.values
          .firstWhere((e) => e.toString() == routine.location)
          .translation;
      location = _location;
    }

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Text(
                    weights + ' ' + unitOfMass,
                    style: BodyText2Light,
                  ),
                  Text('  \u2022  ', style: Caption1),
                  Text(
                    '$duration ${S.current.minutes}',
                    style: BodyText2Light,
                  ),
                  Text('  \u2022  ', style: Caption1),
                  Text(trainingLevel, style: BodyText2Light)

                  // const SizedBox(width: 4),
                  // Text('  \u2022  ', style: Caption1),
                  // const SizedBox(width: 4),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 2),
                  //   child: Text('4.3', style: BodyText2Light),
                  // ),
                  // const SizedBox(width: 4),
                  // Icon(
                  //   Icons.star_rate_rounded,
                  //   size: 20,
                  //   color: Color(0xffFFD700),
                  // ),
                  // const SizedBox(width: 4),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 2),
                  //   child: Text('25 ratings', style: BodyText2Light),
                  // ),
                ],
              ),
            ),

            // Main Muscle Group
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  CachedNetworkImage(
                    imageUrl: _bicepImageUrl,
                    color: Colors.white,
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: size.width - 68,
                    child: Text(
                      _mainMuscleGroups,
                      style: BodyText1,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ],
              ),
            ),

            // Equipment Required
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.fitness_center_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: size.width - 68,
                    child: Text(
                      _equipments,
                      style: BodyText1,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ],
              ),
            ),

            // Location
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 16),
                  Text(location, style: BodyText1),
                ],
              ),
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
            Row(
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size((size.width - 48) / 2, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: BorderSide(width: 2, color: PrimaryColor),
                  ),
                  onPressed: () => LogRoutineScreen.show(
                    context,
                    routine: routine,
                  ),
                  child: Text(S.current.logRoutine, style: ButtonText),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => DuringWorkoutScreen.show(
                    context,
                    routine: routine,
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size((size.width - 48) / 2, 48),
                    primary: PrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(S.current.startRoutine, style: ButtonText),
                ),
              ],
            ),
            if (widget.auth.currentUser.uid != routine.routineOwnerId)
              const SizedBox(height: 16),
            // if (widget.auth.currentUser.uid != routine.routineOwnerId)
            //   MaxWidthRaisedButton(
            //     color: Primary400Color,
            //     onPressed: () => DuringWorkoutScreen.show(
            //       context,
            //       routine: routine,
            //     ),
            //     buttonText: 'Copy this Routine',
            //   ),
            const SizedBox(height: 16),
            const Divider(endIndent: 8, indent: 8, color: Grey800),
            const SizedBox(height: 8),
            StreamBuilder<List<RoutineWorkout>>(
                stream: widget.database
                    .routineWorkoutsStream(routine)
                    .asBroadcastStream(),
                builder: (context, snapshot) {
                  return Column(
                    children: [
                      ListItemBuilder<RoutineWorkout>(
                        emptyContentTitle: S.current.routineWorkoutEmptyText,
                        snapshot: snapshot,
                        itemBuilder: (context, routineWorkout) =>
                            WorkoutMediumCard(
                          database: widget.database,
                          routine: routine,
                          routineWorkout: routineWorkout,
                          auth: widget.auth,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (widget.auth.currentUser.uid == routine.routineOwnerId)
                        const Divider(
                          endIndent: 8,
                          indent: 8,
                          color: Colors.white12,
                        ),
                      const SizedBox(height: 16),
                      if (widget.auth.currentUser.uid == routine.routineOwnerId)
                        MaxWidthRaisedButton(
                          width: double.infinity,
                          icon: const Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                          ),
                          buttonText: S.current.addWorkoutButtonText,
                          color: CardColor,
                          onPressed: () => AddWorkoutsToRoutine.show(
                            context,
                            routine: routine,
                          ),
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

    final routineTitle = routine?.routineTitle ?? 'Add Title';
    final routineOwnerUserName =
        routine?.routineOwnerUserName ?? 'routineOwnerUserName';

    Widget _getTitleWidget() {
      if (routineTitle.length < 21) {
        return Text(
          routineTitle,
          style: GoogleFonts.blackHanSans(
            color: Colors.white,
            fontSize: 28,
          ),
          maxLines: 1,
          overflow: TextOverflow.fade,
          softWrap: false,
        );
      } else if (routineTitle.length >= 21 && routineTitle.length < 35) {
        return FittedBox(
          child: Text(
            routineTitle,
            style: GoogleFonts.blackHanSans(
              color: Colors.white,
              fontSize: 28,
            ),
          ),
        );
      } else {
        return Text(
          routineTitle,
          style: GoogleFonts.blackHanSans(
            color: Colors.white,
            fontSize: 20,
          ),
          maxLines: 1,
          overflow: TextOverflow.fade,
          softWrap: false,
        );
      }
    }

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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _getTitleWidget(),
                    const SizedBox(height: 4),
                    Text(
                      'Created by $routineOwnerUserName',
                      style: Subtitle2BoldGrey,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
