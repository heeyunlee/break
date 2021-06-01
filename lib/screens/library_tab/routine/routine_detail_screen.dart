import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/screens/library_tab/routine/widgets/routine_title_widget.dart';
import 'package:workout_player/services/main_provider.dart';
import 'package:workout_player/widgets/custom_stream_builder_widget.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/equipment_required.dart';
import 'package:workout_player/models/enum/location.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/widgets/empty_content.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/widgets/sliver_app_bar_delegate.dart';

import '../../../constants.dart';
import '../../../format.dart';
import '../../../models/routine.dart';
import '../../../services/database.dart';
import 'edit_routine/edit_routine_screen.dart';
import 'log_routine/log_routine_screen.dart';
import 'widgets/routine_description_widget.dart';
import 'widgets/routine_start_button.dart';
import 'widgets/routine_workouts_tab.dart';

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
    required String tag,
  }) async {
    final database = provider.Provider.of<Database>(context, listen: false);
    final auth = provider.Provider.of<AuthBase>(context, listen: false);
    final User user = (await database.getUserDocument(auth.currentUser!.uid))!;

    await HapticFeedback.mediumImpact();

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
  }

  @override
  _RoutineDetailScreenState createState() => _RoutineDetailScreenState();
}

class _RoutineDetailScreenState extends State<RoutineDetailScreen>
    with TickerProviderStateMixin {
  // For SliverApp to Work
  late AnimationController _colorAnimationController;
  late AnimationController _textAnimationController;
  late Animation _colorTween;
  late Animation<Offset> _transTween;

  bool _scrollListener(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.vertical) {
      print('scroll info is ${scrollInfo.metrics.pixels}');

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

    return NotificationListener<ScrollNotification>(
      onNotification: _scrollListener,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: kBackgroundColor,
        body: Consumer(
          builder: (context, watch, child) {
            final routineId = widget.routine.routineId;
            final routineStream = watch(routineStreamProvider(routineId));
            final routineWorkoutStream = watch(
              routineWorkoutsStreamProvider(routineId),
            );

            return routineStream.when(
              loading: () => Center(child: CircularProgressIndicator()),
              error: (e, stack) => EmptyContent(),
              data: (routine) => DefaultTabController(
                length: 2,
                child: NestedScrollView(
                  physics: const BouncingScrollPhysics(),
                  headerSliverBuilder: (context, _) {
                    return [
                      _buildSliverAppBar(routine!, routineWorkoutStream),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: SliverAppBarDelegate(
                          minHeight: 48,
                          maxHeight: 48,
                          child: Container(
                            color: kAppBarColor,
                            child: TabBar(
                              indicatorColor: kPrimaryColor,
                              tabs: [
                                Tab(text: S.current.workoutsUpperCase),
                                Tab(text: S.current.routineHistory),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ];
                  },
                  body: TabBarView(
                    children: [
                      RoutineWorkoutsTab(
                        auth: widget.auth,
                        database: widget.database,
                        routine: routine!,
                      ),
                      Placeholder(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(
    Routine routine,
    AsyncValue<List<RoutineWorkout?>> asyncValue,
  ) {
    debugPrint('building sliver app bar...');

    final Size size = MediaQuery.of(context).size;

    // FORMATTING
    final trainingLevel = Format.difficulty(routine.trainingLevel)!;
    final duration = Format.durationInMin(routine.duration);
    final weights = Format.weights(routine.totalWeights);
    final unitOfMass = Format.unitOfMass(routine.initialUnitOfMass);

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

    String _location = Location.values
        .firstWhere((e) => e.toString() == routine.location)
        .translation!;

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
        elevation: 0,
        expandedHeight: size.height / 2 + 24,
        flexibleSpace: FlexibleSpaceBar(
          background: Column(
            children: [
              SizedBox(
                height: size.height / 4,
                width: size.width,
                child: Stack(
                  alignment: Alignment.center,
                  fit: StackFit.passthrough,
                  children: [
                    Hero(
                      tag: widget.tag,
                      child: CachedNetworkImage(
                        imageUrl: routine.imageUrl,
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.0, 0.0),
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            kAppBarColor,
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: RoutineTitleWidget(title: routine.routineTitle),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 16,
                      child: Text(
                        routine.routineOwnerUserName,
                        style: kSubtitle2BoldGrey,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: double.maxFinite,
                  color: kAppBarColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                              Text(_location, style: kBodyText1),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Description
                        RoutineDescriptionWidget(
                          description: routine.description,
                        ),
                        const SizedBox(height: 24),

                        // Log and Start Button
                        Row(
                          children: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                minimumSize: Size((size.width - 48) / 2, 48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                side:
                                    BorderSide(width: 2, color: kPrimaryColor),
                              ),
                              onPressed: () => LogRoutineScreen.show(
                                context,
                                routine: routine,
                                database: widget.database,
                                auth: widget.auth,
                                user: widget.user,
                              ),
                              child: Text(S.current.logRoutine,
                                  style: kButtonText),
                            ),
                            const SizedBox(width: 16),
                            RoutineStartButton(
                              routine: routine,
                              asyncValue: asyncValue,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
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

  Widget _saveButton() {
    return IconButton(
      icon: Icon(
        Icons.bookmark_border_rounded,
        color: Colors.white,
      ),
      onPressed: () async {
        try {
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
        } on FirebaseException catch (e) {
          logger.e(e);
          await showExceptionAlertDialog(
            context,
            title: S.current.operationFailed,
            exception: e.toString(),
          );
        }
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
    return CustomStreamBuilderWidget<User?>(
      initialData: widget.user,
      stream: widget.database.userStream(widget.auth.currentUser!.uid),
      hasDataWidget: (context, snapshot) {
        final User user = snapshot.data!;

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
