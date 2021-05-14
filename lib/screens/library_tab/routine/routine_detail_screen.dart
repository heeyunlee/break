import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/screens/library_tab/routine/routine_workouts_list_widget.dart';
import 'package:workout_player/widgets/custom_stream_builder_widget.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/equipment_required.dart';
import 'package:workout_player/models/enum/location.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/screens/library_tab/routine/log_routine/log_routine_screen.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/widgets/shimmer/list_view_shimmer.dart';
import 'package:workout_player/widgets/shimmer/routine_workout_shimmer.dart';

import '../../../widgets/list_item_builder.dart';
import '../../../widgets/max_width_raised_button.dart';
import '../../../constants.dart';
import '../../../format.dart';
import '../../../models/routine.dart';
import '../../../models/routine_workout.dart';
import '../../../services/database.dart';
import 'add_workout/add_workouts_to_routine.dart';
import 'edit_routine/edit_routine_screen.dart';
import 'widgets/routine_flexible_spacebar_widget.dart';
import 'widgets/routine_start_button.dart';
import 'widgets/workout_medium_card.dart';

Logger logger = Logger();

class RoutineDetailScreen extends StatefulWidget {
  final Database database;
  final Routine routine;
  final String tag;
  final AuthBase auth;
  final User user;

  RoutineDetailScreen({
    required this.database,
    required this.routine,
    required this.tag,
    required this.auth,
    required this.user,
  });

  // For Navigation
  static Future<void> show(
    BuildContext context, {
    required Routine routine,
    bool isRootNavigation = false,
    required String tag,
  }) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    final User user = (await database.getUserDocument(auth.currentUser!.uid))!;

    await HapticFeedback.mediumImpact();

    if (!isRootNavigation) {
      await Navigator.of(context, rootNavigator: false).push(
        CupertinoPageRoute(
          fullscreenDialog: false,
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
          fullscreenDialog: true,
          builder: (context) => RoutineDetailScreen(
            database: database,
            routine: routine,
            auth: auth,
            user: user,
            tag: tag,
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
  late List<RoutineWorkout> routineWorkouts = [];
  set list(List<RoutineWorkout> value) =>
      setState(() => routineWorkouts = value);

  // For SliverApp to Work
  late AnimationController _colorAnimationController;
  late AnimationController _textAnimationController;
  late Animation _colorTween;
  late Animation<Offset> _transTween;

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
    _colorTween = ColorTween(begin: Colors.transparent, end: kAppBarColor)
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
    debugPrint('routine detail screen scaffold building...');

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: NotificationListener<ScrollNotification>(
        onNotification: _scrollListener,
        child: CustomStreamBuilderWidget<Routine>(
          initialData: widget.routine,
          stream: widget.database.routineStream(
            routineId: widget.routine.routineId,
          ),
          hasDataWidget: (context, snapshot) {
            return Stack(
              children: [
                CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    _buildSliverAppBar(snapshot.data),
                    _buildSliverToBoxAdaptor(snapshot.data),
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
    final Size size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: _colorAnimationController,
      builder: (context, child) => SliverAppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        brightness: Brightness.dark,
        title: Transform.translate(
          offset: _transTween.value,
          child: Text(routine.routineTitle, style: kSubtitle1),
        ),
        backgroundColor: _colorTween.value,
        floating: false,
        pinned: true,
        snap: false,
        stretch: true,
        expandedHeight: size.height * 1 / 5,
        flexibleSpace: RoutineFlexibleSpaceBarWidget(
          routine: widget.routine,
          tag: widget.tag,
        ),
        actions: [
          if (widget.auth.currentUser!.uid != routine.routineOwnerId)
            _getSaveButton(),
          if (widget.auth.currentUser!.uid == routine.routineOwnerId)
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

  Widget _buildSliverToBoxAdaptor(Routine routine) {
    final size = MediaQuery.of(context).size;

    // FORMATTING
    final trainingLevel = Format.difficulty(routine.trainingLevel)!;
    final duration = Format.durationInMin(routine.duration);
    final weights = Format.weights(routine.totalWeights);
    final unitOfMass = Format.unitOfMass(routine.initialUnitOfMass);

    final String description = routine.description == null
        ? S.current.addDescription
        : routine.description!.isEmpty
            ? S.current.addDescription
            : routine.description!;

    String _mainMuscleGroups = '';
    for (var i = 0; i < routine.mainMuscleGroup.length; i++) {
      String _mainMuscleGroup;
      if (i == 0) {
        _mainMuscleGroups = MainMuscleGroup.values
            .firstWhere((e) => e.toString() == routine.mainMuscleGroup[i])
            .translation!;
      } else {
        _mainMuscleGroup = MainMuscleGroup.values
            .firstWhere((e) => e.toString() == routine.mainMuscleGroup[i])
            .translation!;
        _mainMuscleGroups = _mainMuscleGroups + ', $_mainMuscleGroup';
      }
    }

    String _equipments = '';
    for (var i = 0; i < routine.equipmentRequired.length; i++) {
      String _equipment;
      if (i == 0) {
        _equipments = EquipmentRequired.values
            .firstWhere((e) => e.toString() == routine.equipmentRequired[i])
            .translation!;
      } else {
        _equipment = EquipmentRequired.values
            .firstWhere((e) => e.toString() == routine.equipmentRequired[i])
            .translation!;
        _equipments = _equipments + ', $_equipment';
      }
    }

    String location = Location.values
        .firstWhere((e) => e.toString() == routine.location)
        .translation!;

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
                    style: kBodyText2Light,
                  ),
                  const Text('  \u2022  ', style: kCaption1),
                  Text(
                    '$duration ${S.current.minutes}',
                    style: kBodyText2Light,
                  ),
                  const Text('  \u2022  ', style: kCaption1),
                  Text(trainingLevel, style: kBodyText2Light)
                ],
              ),
            ),

            // Main Muscle Group
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  CachedNetworkImage(
                    imageUrl: kBicepEmojiUrl,
                    color: Colors.white,
                    width: 20,
                    height: 20,
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: size.width - 68,
                    child: Text(
                      _mainMuscleGroups,
                      style: kBodyText1,
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
                  const Icon(
                    Icons.fitness_center_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: size.width - 68,
                    child: Text(
                      _equipments,
                      style: kBodyText1,
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
                  const Icon(
                    Icons.location_on_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 16),
                  Text(location, style: kBodyText1),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: kBodyText2LightGrey,
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
                    side: BorderSide(width: 2, color: kPrimaryColor),
                  ),
                  onPressed: () => LogRoutineScreen.show(
                    context,
                    routine: routine,
                  ),
                  child: Text(S.current.logRoutine, style: kButtonText),
                ),
                const SizedBox(width: 16),
                RoutineStartButton(
                  routine: routine,
                  routineWorkouts: routineWorkouts,
                ),
              ],
            ),
            if (widget.auth.currentUser!.uid != routine.routineOwnerId)
              const SizedBox(height: 16),
            const SizedBox(height: 16),
            const Divider(endIndent: 8, indent: 8, color: kGrey800),
            const SizedBox(height: 8),
            RoutineWorkoutsListWidget(
              routine: routine,
              listCallback: (list) {
                setState(() {
                  routineWorkouts = list;
                });
              },
              database: widget.database,
              auth: widget.auth,
            ),
            // ListViewShimmer(),
            // TODO: ADD WIDGET HERE
            // StreamBuilder<List<RoutineWorkout>>(
            //   stream: widget.database.routineWorkoutsStream(routine),
            //   builder: (context, snapshot) {
            //     sd = snapshot.data!;

            //     return Column(
            //       children: [
            //         ListItemBuilder<RoutineWorkout>(
            //           emptyContentTitle: S.current.routineWorkoutEmptyText,
            //           snapshot: snapshot,
            //           itemBuilder: (context, routineWorkout) =>
            //               WorkoutMediumCard(
            //             database: widget.database,
            //             routine: routine,
            //             routineWorkout: routineWorkout,
            //             auth: widget.auth,
            //           ),
            //         ),
            //         const SizedBox(height: 8),
            //         if (widget.auth.currentUser!.uid == routine.routineOwnerId)
            //           const Divider(
            //             endIndent: 8,
            //             indent: 8,
            //             color: Colors.white12,
            //           ),
            //         const SizedBox(height: 16),
            //         if (widget.auth.currentUser!.uid == routine.routineOwnerId)
            //           MaxWidthRaisedButton(
            //             icon: const Icon(
            //               Icons.add_rounded,
            //               color: Colors.white,
            //             ),
            //             buttonText: S.current.addWorkoutkButtonText,
            //             color: kCardColor,
            //             onPressed: () => AddWorkoutsToRoutine.show(
            //               context,
            //               routine: routine,
            //             ),
            //           ),
            //         SizedBox(height: size.height / 6),
            //       ],
            //     );
            //   },
            // ),
            const SizedBox(height: 8),
            if (widget.auth.currentUser!.uid == routine.routineOwnerId)
              const Divider(
                endIndent: 8,
                indent: 8,
                color: Colors.white12,
              ),
            const SizedBox(height: 16),
            if (widget.auth.currentUser!.uid == routine.routineOwnerId)
              MaxWidthRaisedButton(
                icon: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                ),
                buttonText: S.current.addWorkoutkButtonText,
                color: kCardColor,
                onPressed: () {
                  print(routineWorkouts.length);
                },
                // onPressed: () => AddWorkoutsToRoutine.show(
                //   context,
                //   routine: routine,
                // ),
              ),
            SizedBox(height: size.height / 6),
          ],
        ),
      ),
    );
  }

  Widget _saveButton() {
    return IconButton(
      icon: Icon(
        Icons.bookmark_border_rounded,
        color: Colors.white,
      ),
      onPressed: () async {
        final user = {
          'savedRoutines': FieldValue.arrayUnion([widget.routine.routineId]),
        };

        await widget.database.updateUser(widget.auth.currentUser!.uid, user);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.current.savedRoutineSnackbar),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );

        debugPrint('added routine to saved routine');
      },
    );
  }

  Widget _unsaveButton() {
    return IconButton(
      icon: Icon(
        Icons.bookmark_rounded,
        color: Colors.white,
      ),
      onPressed: () async {
        final user = {
          'savedRoutines': FieldValue.arrayRemove([widget.routine.routineId]),
        };

        await widget.database.updateUser(widget.auth.currentUser!.uid, user);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.current.unsavedRoutineSnackbar),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );

        debugPrint('Removed routine from saved routine');
      },
    );
  }

  Widget _getSaveButton() {
    return CustomStreamBuilderWidget<User>(
      initialData: widget.user,
      stream: widget.database.userStream(widget.auth.currentUser!.uid),
      hasDataWidget: (context, snapshot) {
        final User user = snapshot.data;

        if (user.savedRoutines != null) {
          if (user.savedRoutines!.isNotEmpty) {
            if (user.savedRoutines!.contains(widget.routine.routineId)) {
              return _unsaveButton();
            } else {
              return _saveButton();
            }
          } else {
            return _saveButton();
          }
        } else {
          return _saveButton();
        }
      },
      errorWidget: const Icon(Icons.error, color: Colors.white),
      loadingWidget: const Icon(Icons.sync, color: Colors.white),
    );
  }
}
