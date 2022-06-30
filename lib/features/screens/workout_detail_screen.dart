import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/features/widgets/widgets.dart';
import 'package:workout_player/widgets/widgets.dart';
import 'add_workout_to_routine_screen.dart';
import 'edit_workout_screen.dart';
import 'workout_histories_tab.dart';
import 'workout_overview_tab.dart';

class WorkoutDetailScreen extends ConsumerStatefulWidget {
  const WorkoutDetailScreen({
    Key? key,
    this.workout,
    required this.workoutId,
    required this.tag,
  }) : super(key: key);

  final Workout? workout;
  final String workoutId;
  final String tag;

  // For Navigation
  static void show(
    BuildContext context, {
    Workout? workout,
    required String workoutId,
    required String tag,
    bool isRoot = false,
  }) {
    if (!isRoot) {
      customPush(
        context,
        rootNavigator: false,
        builder: (context) {
          return WorkoutDetailScreen(
            workout: workout,
            workoutId: workoutId,
            tag: tag,
          );
        },
      );
    } else {
      HapticFeedback.mediumImpact();

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => WorkoutDetailScreen(
            workout: workout,
            workoutId: workoutId,
            tag: tag,
          ),
        ),
      );
    }
  }

  @override
  ConsumerState<WorkoutDetailScreen> createState() =>
      _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends ConsumerState<WorkoutDetailScreen>
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
        AnimationController(vsync: this, duration: Duration.zero);

    _transTween = Tween(begin: const Offset(0, 24), end: Offset.zero)
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
    final database = ref.watch(databaseProvider);

    return Scaffold(
      body: CustomStreamBuilder<Workout?>(
        stream: database.workoutStream(widget.workoutId),
        builder: (context, data) {
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
    final database = ref.watch(databaseProvider);
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    final title =
        workout.translated[locale]?.toString() ?? workout.workoutTitle;

    return AnimatedBuilder(
      animation: _textAnimationController,
      builder: (context, child) => SliverAppBar(
        forceElevated: innerBoxIsScrolled,
        leading: const AppBarBackButton(),
        title: Transform.translate(
          offset: _transTween.value,
          child: Opacity(
            opacity: _opacityTween.value,
            child: child,
          ),
        ),
        pinned: true,
        stretch: true,
        expandedHeight: size.height / 2,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: theme.appBarTheme.backgroundColor,
            child: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              indicatorColor: theme.primaryColor,
              tabs: _tabs.map((e) => Tab(text: e)).toList(),
            ),
          ),
        ),
        actions: <Widget>[
          if (database.uid != workout.workoutOwnerId)
            SaveUnsaveWorkoutButtonWidget(
              workout: workout,
            ),
          if (database.uid == workout.workoutOwnerId)
            IconButton(
              icon: const Icon(Icons.edit_rounded, color: Colors.white),
              onPressed: () => EditWorkoutScreen.show(
                context,
                workout: workout,
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
    final theme = Theme.of(context);

    return FlexibleSpaceBar(
      background: Stack(
        fit: StackFit.passthrough,
        children: [
          Hero(
            tag: widget.tag,
            child: AdaptiveCachedNetworkImage(
              imageUrl: workout.imageUrl,
              errorWidgetBuilder: (context, url, error) =>
                  const Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: const Alignment(0.0, -0.75),
                end: const Alignment(0.0, 0.75),
                colors: [
                  Colors.transparent,
                  theme.appBarTheme.backgroundColor!,
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
                    SizedBox(
                      width: size.width / 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            S.current.mainMuscleGroup,
                            style: TextStyles.caption1Grey,
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
                    SizedBox(
                      width: size.width / 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            S.current.equipmentRequired,
                            style: TextStyles.caption1Grey,
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
                    SizedBox(
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
                  color: theme.primaryColor,
                  icon: const Icon(Icons.add_rounded, size: 20),
                  buttonText: S.current.addWorkoutToRoutine,
                  onPressed: () => AddWorkoutToRoutine.show(
                    context,
                    workout: workout,
                  ),
                ),
                const SizedBox(height: 48),
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
          workout: workout,
        ),
      ],
    );
  }
}
