import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/classes/routine.dart';
import 'package:workout_player/classes/routine_and_routine_workouts.dart';
import 'package:workout_player/screens/home/library_tab/routine/routine_detail_screen_model.dart';
import 'package:workout_player/services/database.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/classes/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/widgets/custom_stream_builder_widget.dart';

import 'edit_routine/edit_routine_screen.dart';
import 'routine_history_tab/routine_history_tab.dart';
import 'routine_workouts_tab/routine_workouts_tab.dart';
import 'widgets/description_widget.dart';
import 'widgets/equipment_required_widget.dart';
import 'widgets/location_widget.dart';
import 'widgets/log_routine_button.dart';
import 'widgets/main_muscle_group_widget.dart';
import 'widgets/save_button_widget.dart';
import 'widgets/start_routine_button.dart';
import 'widgets/subtitle_widget.dart';
import 'widgets/title_widget.dart';

class RoutineDetailScreen extends StatefulWidget {
  final Database database;
  final Routine routine;
  final String tag;
  final AuthBase auth;
  final User user;
  final RoutineDetailScreenModel model;

  RoutineDetailScreen({
    required this.database,
    required this.routine,
    required this.tag,
    required this.auth,
    required this.user,
    required this.model,
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
        builder: (context) => Consumer(
          builder: (context, watch, child) => RoutineDetailScreen(
            routine: routine,
            tag: tag,
            user: user,
            model: watch(routineDetailScreenModelProvider),
            auth: auth,
            database: database,
          ),
        ),
      ),
    );
  }

  @override
  _RoutineDetailScreenState createState() => _RoutineDetailScreenState();
}

class _RoutineDetailScreenState extends State<RoutineDetailScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.model.init(this);
  }

  @override
  void dispose() {
    widget.model.textAnimationController.dispose();
    widget.model.scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.d('routine detail screen scaffold building...');

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kBackgroundColor,
      body: CustomStreamBuilderWidget<RoutineAndRoutineWorkouts>(
        stream: widget.model.database!.routineRoutineWorkoutsStream(
          widget.routine.routineId,
        ),
        hasDataWidget: (context, data) => LayoutBuilder(
          builder: (context, constraints) {
            return DefaultTabController(
              length: 2,
              child: NestedScrollView(
                controller: widget.model.scrollController,
                clipBehavior: Clip.antiAlias,
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [_buildSliverAppBar(data, constraints)];
                },
                body: TabBarView(
                  children: [
                    RoutineWorkoutsTab(
                      auth: widget.auth,
                      database: widget.database,
                      routine: data.routine!,
                    ),
                    RoutineHistoryTab(
                      routine: data.routine!,
                      auth: widget.auth,
                      database: widget.database,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(
    RoutineAndRoutineWorkouts data,
    BoxConstraints constraints,
  ) {
    final height = (constraints.maxHeight > 700)
        ? constraints.maxHeight / 2 + 80
        : constraints.maxHeight / 2 + 120;

    return AnimatedBuilder(
      animation: widget.model.textAnimationController,
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
          offset: widget.model.transTween.value,
          child: Opacity(
            opacity: widget.model.opacityTween.value,
            child: child,
          ),
        ),
        backgroundColor: kAppBarColor,
        floating: false,
        pinned: true,
        snap: false,
        stretch: true,
        elevation: 0,
        expandedHeight: height,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: Container(
            color: kAppBarColor,
            child: TabBar(
              indicatorColor: kPrimaryColor,
              tabs: [
                Tab(text: S.current.workoutsUpperCase),
                Tab(text: S.current.history),
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
                  height: constraints.maxHeight / 4,
                  width: constraints.maxWidth,
                  child: Stack(
                    alignment: Alignment.center,
                    fit: StackFit.passthrough,
                    children: [
                      Hero(
                        tag: widget.tag,
                        child: CachedNetworkImage(
                          imageUrl: data.routine!.imageUrl,
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
                        child: TitleWidget(title: data.routine!.routineTitle),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 16,
                        child: Text(
                          data.routine!.routineOwnerUserName,
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
                      SubtitleWidget(routine: data.routine!),
                      MainMuscleGroupWidget(routine: data.routine!),
                      EquipmentRequiredWidget(routine: data.routine!),
                      LocationWidget(routine: data.routine!),
                      DescriptionWidget(
                        description: data.routine!.description,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          LogRoutineButton(
                            data: data,
                            database: widget.model.database!,
                            user: widget.user,
                          ),
                          const Spacer(),
                          StartRoutineButton(data: data),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          if (widget.model.auth!.currentUser!.uid !=
              data.routine!.routineOwnerId)
            SaveButtonWidget(
              user: widget.user,
              database: widget.model.database!,
              auth: widget.model.auth!,
              routine: data.routine!,
            ),
          if (widget.model.auth!.currentUser!.uid ==
              data.routine!.routineOwnerId)
            IconButton(
              icon: const Icon(
                Icons.edit_rounded,
                color: Colors.white,
              ),
              onPressed: () => EditRoutineScreen.show(
                context,
                routine: data.routine!,
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
      child: TitleWidget(
        title: data.routine!.routineTitle,
        isAppBarTitle: true,
      ),
    );
  }
}
