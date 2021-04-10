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

      _textAnimationController
          .animateTo((scrollInfo.metrics.pixels - 130) / 50);
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
      ),
    );
  }

  Widget _buildSliverToBoxAdaptor(BuildContext context, Routine routine) {
    final size = MediaQuery.of(context).size;

    final routineTitle = routine?.routineTitle ?? 'Add Title';
    final routineOwnerUserName =
        routine?.routineOwnerUserName ?? 'routineOwnerUserName';
    final description =
        (routine.description == null || routine.description.isNotEmpty
            ? S.current.addDescription
            : routine.description);
    final lastEditedDate = Format.dateShort(routine.lastEditedDate);
    final weights = Format.weights(routine.totalWeights);
    final unitOfMass = Format.unitOfMass(routine.initialUnitOfMass);

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
                        const Text('|', style: BodyText2Light),
                        const SizedBox(width: 8),
                        Text(
                          '${S.current.lastEditedOn} $lastEditedDate',
                          style: BodyText2Light,
                        ),
                      ],
                    ),
                    if (location != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '${S.current.location}: $location',
                          style: BodyText2Light,
                        ),
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
                      context,
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

    final mainMuscleGroup = MainMuscleGroup.values
            .firstWhere((e) => e.toString() == routine.mainMuscleGroup[0])
            .translation ??
        'Null';
    final equipmentRequired = EquipmentRequired.values
            .firstWhere((e) => e.toString() == routine.equipmentRequired[0])
            .translation ??
        'Null';

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
          // CachedNetworkImage(
          //   imageUrl: routine.imageUrl,
          //   errorWidget: (context, url, error) => const Icon(Icons.error),
          //   fit: BoxFit.cover,
          // ),
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
                      SizedBox(
                        width: size.width / 3,
                        child: Center(
                          child: Text(
                            mainMuscleGroup,
                            style: Subtitle2,
                          ),
                        ),
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
                      SizedBox(
                        width: size.width / 3,
                        child: Center(
                          child: Text(equipmentRequired, style: Subtitle2),
                        ),
                      ),
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
                      SizedBox(
                        width: size.width / 3,
                        child: Center(
                          child: Text(
                            '$duration ${S.current.minutes}',
                            style: Subtitle2,
                            maxLines: 1,
                          ),
                        ),
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
