import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart' as provider;
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view/widgets/builders/custom_stream_builder_widget.dart';
import 'package:workout_player/view/widgets/library.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/add_workout_to_routine_screen_model.dart';
import 'edit_workout_screen.dart';
import 'workout_histories_tab.dart';
import 'workout_overview_tab.dart';

class WorkoutDetailScreen extends StatefulWidget {
  final Workout? workout;
  final String workoutId;
  final Database database;
  final AuthBase auth;
  final User user;
  final String tag;

  const WorkoutDetailScreen({
    this.workout,
    required this.workoutId,
    required this.database,
    required this.auth,
    required this.user,
    required this.tag,
  });

  // For Navigation
  static Future<void> show(
    BuildContext context, {
    Workout? workout,
    required String workoutId,
    required String tag,
    bool isRoot = false,
  }) async {
    final database = provider.Provider.of<Database>(context, listen: false);
    final auth = provider.Provider.of<AuthBase>(context, listen: false);
    final User user = (await database.getUserDocument(auth.currentUser!.uid))!;

    await HapticFeedback.mediumImpact();
    if (!isRoot) {
      await Navigator.of(context, rootNavigator: false).push(
        CupertinoPageRoute(
          builder: (context) => WorkoutDetailScreen(
            workout: workout,
            workoutId: workoutId,
            database: database,
            auth: auth,
            user: user,
            tag: tag,
          ),
        ),
      );
    } else {
      await Navigator.of(context, rootNavigator: false).pushReplacement(
        CupertinoPageRoute(
          builder: (context) => WorkoutDetailScreen(
            workout: workout,
            workoutId: workoutId,
            database: database,
            auth: auth,
            user: user,
            tag: tag,
          ),
        ),
      );
    }
  }

  @override
  _WorkoutDetailScreenState createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen>
    with TickerProviderStateMixin {
  final List<String> _tabs = [S.current.overview, S.current.history];

  late ScrollController _scrollController;
  late AnimationController _textAnimationController;
  late Animation<Offset> _transTween;
  late Animation<double> _opacityTween;

  final locale = Intl.getCurrentLocale();

  @override
  void initState() {
    super.initState();

    _textAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));

    _transTween = Tween(begin: Offset(0, 24), end: Offset(0, 0))
        .animate(_textAnimationController);

    _opacityTween = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(_textAnimationController);

    _scrollController = ScrollController()
      ..addListener(() {
        _textAnimationController
            .animateTo((_scrollController.offset - 200) / 100);
      });
  }

  @override
  void dispose() {
    _textAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: CustomStreamBuilderWidget<Workout?>(
        stream: widget.database.workoutStream(widget.workoutId),
        hasDataWidget: (context, data) {
          return DefaultTabController(
            length: 2,
            child: NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  _buildSliverAppBar(
                    context,
                    data!,
                    innerBoxIsScrolled,
                  ),
                ];
              },
              body: _buildTabBarView(data!),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar(
    BuildContext context,
    Workout workout,
    bool innerBoxIsScrolled,
  ) {
    final size = MediaQuery.of(context).size;

    final title = workout.translated[locale] ?? workout.workoutTitle;

    return AnimatedBuilder(
      animation: _textAnimationController,
      builder: (context, child) => SliverAppBar(
        forceElevated: innerBoxIsScrolled,
        brightness: Brightness.dark,
        leading: const AppBarBackButton(),
        title: Transform.translate(
          offset: _transTween.value,
          child: Opacity(
            opacity: _opacityTween.value,
            child: child,
          ),
        ),
        backgroundColor: kAppBarColor,
        floating: false,
        pinned: true,
        snap: false,
        stretch: true,
        expandedHeight: size.height / 2,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: Container(
            color: kAppBarColor,
            child: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: kGrey400,
              indicatorColor: kPrimaryColor,
              tabs: _tabs.map((e) => Tab(text: e)).toList(),
            ),
          ),
        ),
        actions: <Widget>[
          if (widget.user.userId != workout.workoutOwnerId)
            SaveUnsaveWorkoutButtonWidget(
              user: widget.user,
              database: widget.database,
              auth: widget.auth,
              workout: workout,
            ),
          if (widget.user.userId == workout.workoutOwnerId)
            IconButton(
              icon: const Icon(Icons.edit_rounded, color: Colors.white),
              onPressed: () => EditWorkoutScreen.show(
                context,
                workout: workout,
                auth: widget.auth,
                database: widget.database,
              ),
            ),
          const SizedBox(width: 8),
        ],
        flexibleSpace: _buildFlexibleSpaceBarWidget(workout),
      ),
      child: Text(title, style: TextStyles.subtitle1),
    );
  }

  Widget _buildFlexibleSpaceBarWidget(Workout workout) {
    final size = MediaQuery.of(context).size;

    return FlexibleSpaceBar(
      background: Stack(
        fit: StackFit.passthrough,
        children: [
          Hero(
            tag: widget.tag,
            child: CachedNetworkImage(
              imageUrl: workout.imageUrl,
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.0, -0.75),
                end: Alignment(0.0, 0.75),
                colors: [
                  Colors.transparent,
                  kAppBarColor,
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WorkoutTitleWidget(workout: workout),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    // Main Muscle Group
                    Container(
                      width: size.width / 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            S.current.mainMuscleGroup,
                            style: TextStyles.caption1_grey,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            Formatter.getFirstMainMuscleGroup(
                              workout.mainMuscleGroup,
                            ),
                            style: TextStyles.subtitle2,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                      height: 56,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                    ),

                    // Equipment Required
                    Container(
                      width: size.width / 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            S.current.equipmentRequired,
                            style: TextStyles.caption1_grey,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            Formatter.getFirstEquipmentRequired(
                              workout.equipmentRequired,
                            ),
                            style: TextStyles.subtitle2,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                      height: 56,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                    ),

                    // Experience Level
                    Container(
                      width: size.width / 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            S.current.difficulty,
                            style: TextStyles.caption1,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            Formatter.difficulty(workout.difficulty),
                            style: TextStyles.subtitle2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                MaxWidthRaisedButton(
                  width: double.infinity,
                  color: kGrey800,
                  icon: const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  buttonText: S.current.addWorkoutToRoutine,
                  onPressed: () => AddWorkoutToRoutineScreenModel.show(
                    context,
                    workout: workout,
                  ),
                ),
                SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBarView(Workout workout) {
    return TabBarView(
      children: [
        WorkoutOverviewTab(workout: workout),
        WorkoutHistoriesTab(
          user: widget.user,
          database: widget.database,
          workout: workout,
        ),
      ],
    );
  }
}
