import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/screens/library_tab/routine/widgets/equipment_required_widget.dart';
import 'package:workout_player/screens/library_tab/routine/widgets/location_widget.dart';
import 'package:workout_player/screens/library_tab/routine/widgets/save_button_button_widget.dart';
import 'package:workout_player/screens/library_tab/routine/widgets/title_widget.dart';
import 'package:workout_player/services/main_provider.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/widgets/empty_content.dart';

import '../../../constants.dart';
import '../../../models/routine.dart';
import '../../../services/database.dart';
import 'edit_routine/edit_routine_screen.dart';
import 'routine_history_tab/routine_history_tab.dart';
import 'routine_workouts_tab/routine_workouts_tab.dart';
import 'widgets/description_widget.dart';
import 'widgets/log_start_routine_button_widget.dart';
import 'widgets/main_muscle_group_widget.dart';
import 'widgets/subtitle_widget.dart';

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
  //
  // For SliverApp to Work
  late AnimationController _colorAnimationController;
  late AnimationController _textAnimationController;
  late Animation _colorTween;
  late Animation<Offset> _transTween;

  bool _scrollListener(ScrollNotification scrollInfo) {
    final size = MediaQuery.of(context).size;

    debugPrint('scroll info is ${scrollInfo.metrics.pixels}');

    if (scrollInfo.metrics.axis == Axis.vertical) {
      _colorAnimationController.animateTo(scrollInfo.metrics.pixels);
      _textAnimationController
          .animateTo((scrollInfo.metrics.pixels - size.height / 2 + 48) / 50);

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
    logger.d('routine detail screen scaffold building...');

    return Scaffold(
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
            error: (e, stack) {
              logger.e(e);
              return EmptyContent();
            },
            data: (routine) => NotificationListener<ScrollNotification>(
              onNotification: _scrollListener,
              child: DefaultTabController(
                length: 2,
                child: NestedScrollView(
                  clipBehavior: Clip.antiAlias,
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      _buildSliverAppBar(routine!, routineWorkoutStream),
                    ];
                  },
                  body: TabBarView(
                    children: [
                      RoutineWorkoutsTab(
                        auth: widget.auth,
                        database: widget.database,
                        routine: routine!,
                      ),
                      RoutineHistoryTab(
                        routine: routine,
                        auth: widget.auth,
                        database: widget.database,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar(
    Routine routine,
    AsyncValue<List<RoutineWorkout?>> asyncValue,
  ) {
    logger.d('building sliver app bar...');

    final Size size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: _colorAnimationController,
      builder: (context, child) {
        return SliverAppBar(
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
            child: child,
          ),
          backgroundColor: _colorTween.value,
          floating: false,
          pinned: true,
          snap: false,
          stretch: true,
          elevation: 0,
          expandedHeight: size.height / 2 + 64,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48),
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
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            background: Container(
              color: kAppBarColor,
              child: Column(
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
                          child: TitleWidget(title: routine.routineTitle),
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
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SubtitleWidget(routine: routine),
                        MainMuscleGroupWidget(routine: routine),
                        EquipmentRequiredWidget(routine: routine),
                        LocationWidget(routine: routine),
                        DescriptionWidget(description: routine.description),
                        const SizedBox(height: 24),
                        LogStartRoutineButtonWidget(
                          user: widget.user,
                          database: widget.database,
                          routine: routine,
                          asyncValue: asyncValue,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            if (widget.auth.currentUser!.uid != routine.routineOwnerId)
              SaveButtonButtonWidget(
                user: widget.user,
                database: widget.database,
                auth: widget.auth,
                routine: routine,
              ),
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
        );
      },
      child: TitleWidget(
        title: routine.routineTitle,
        isAppBarTitle: true,
      ),
    );
  }
}
