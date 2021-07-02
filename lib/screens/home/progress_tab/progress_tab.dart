import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
// import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:table_calendar/table_calendar.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/screens/home/progress_tab/widgets/choose_background_icon.dart';
import 'package:workout_player/screens/home/settings_tab/personal_goals/personal_goals_screen.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/services/main_provider.dart';
import 'package:workout_player/styles/button_styles.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/widgets/blur_background_card.dart';
import 'package:workout_player/widgets/custom_stream_builder_widget.dart';
import 'package:workout_player/widgets/shimmer/progress_tab_shimmer.dart';

import '../../../styles/constants.dart';
import '../home_screen_provider.dart';
import 'daily_progress_summary/daily_nutrition_widget.dart';
import 'daily_progress_summary/daily_weights_widget.dart';
import 'measurement/measurements_line_chart_widget.dart';
import 'progress_tab_model.dart';
import 'proteins_eaten/weekly_nutrition_chart.dart';
import 'weights_lifted_history/weights_lifted_chart_widget.dart';

class ProgressTab extends StatefulWidget {
  final Database database;
  final ProgressTabModel model;

  const ProgressTab({
    Key? key,
    required this.database,
    required this.model,
  }) : super(key: key);

  static Widget create(BuildContext context) {
    final database = provider.Provider.of<Database>(context, listen: false);

    return Consumer(
      builder: (context, watch, child) => ProgressTab(
        database: database,
        model: watch(progressTabModelProvider),
      ),
    );
  }

  @override
  _ProgressTabState createState() => _ProgressTabState();
}

class _ProgressTabState extends State<ProgressTab>
    with TickerProviderStateMixin {
  // Background Animation
  late AnimationController _bgAnimationController;
  late Animation<double> _blurTween;
  late Animation<double> _brightnessTween;

  bool _scrollListener(ScrollNotification scrollInfo) {
    // debugPrint('${scrollInfo.metrics.pixels}');

    final size = MediaQuery.of(context).size;

    if (scrollInfo.metrics.axis == Axis.vertical) {
      _bgAnimationController.animateTo(
        scrollInfo.metrics.pixels / size.height * 1.5,
      );

      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();

    _bgAnimationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 0),
    );

    _blurTween = Tween<double>(begin: 0, end: 20).animate(
      _bgAnimationController,
    );

    _brightnessTween = Tween<double>(begin: 0.9, end: 0.0).animate(
      _bgAnimationController,
    );

    widget.model.initShowBanner();

    // SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
    //   () async {
    //     final s = await FeatureDiscovery.hasPreviouslyCompleted(
    //         context, 'choose_background');

    //     if (!s) {
    //       FeatureDiscovery.discoverFeatures(
    //         context,
    //         const <String>{
    //           'choose_background',
    //         },
    //       );
    //     }
    //   };
    // });
  }

  @override
  void dispose() {
    _bgAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.d('Progress Tab Scaffold building...');

    return CustomStreamBuilderWidget<User?>(
      stream: widget.database.userStream(),
      loadingWidget: ProgressTabShimmer(),
      hasDataWidget: (context, user) {
        return NotificationListener<ScrollNotification>(
          onNotification: _scrollListener,
          child: Scaffold(
            backgroundColor: kBackgroundColor,
            extendBodyBehindAppBar: true,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(48),
              child: AppBar(
                centerTitle: true,
                brightness: Brightness.dark,
                elevation: 0,
                leading: ChooseBackgroundIcon(user: user!),
                title: TextButton(
                  style: ButtonStyles.text1,
                  onPressed: () => _showCalendar(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat.MMMEd().format(widget.model.selectedDate),
                        style: TextStyles.subtitle2,
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
                backgroundColor: Colors.transparent,
              ),
            ),
            body: Builder(
              builder: (context) => _buildChildWidget(context, user),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChildWidget(BuildContext context, User user) {
    final size = MediaQuery.of(context).size;

    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        alignment: Alignment.center,
        fit: StackFit.passthrough,
        children: [
          _buildBlurredBG(user),
          Padding(
            padding:
                EdgeInsets.only(top: Scaffold.of(context).appBarMaxHeight!),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    if (widget.model.showBanner) _buildBanner(),
                    SizedBox(
                      height: widget.model.showBanner
                          ? size.height * 0.5 - 136
                          : size.height * 0.5,
                    ),
                    Stack(
                      children: [
                        DailyWeightsWidget.create(
                          context,
                          user: user,
                          model: widget.model,
                          constraints: constraints,
                        ),
                        DailyNutritionWidget.create(
                          context,
                          user: user,
                          model: widget.model,
                        ),
                      ],
                    ),
                    WeightsLiftedChartWidget.create(context, user: user),
                    WeeklyNutritionChart.create(context, user: user),
                    MeasurementsLineChartWidget(user: user),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return BlurBackgroundCard(
      borderRadius: 12,
      color: Colors.grey.withOpacity(0.25),
      child: MaterialBanner(
        backgroundColor: Colors.transparent,
        content: Row(
          children: [
            Icon(
              Icons.emoji_events_rounded,
              color: kPrimaryColor,
            ),
            const SizedBox(width: 8),
            Text(
              S.current.progressTabBannerTitle,
              style: TextStyles.body2,
            ),
          ],
        ),
        actions: [
          TextButton(
            style: ButtonStyles.text1_bold,
            onPressed: () => widget.model.setShowBanner(false),
            child: Text(S.current.DISMISS),
          ),
          TextButton(
            style: ButtonStyles.text1_bold,
            onPressed: () => PersonalGoalsScreen.show(
              homeScreenNavigatorKey.currentContext!,
              isRoot: true,
            ),
            child: Text(S.current.SETNOW),
          ),
        ],
      ),
    );
  }

  AnimatedBuilder _buildBlurredBG(User user) {
    return AnimatedBuilder(
      animation: _bgAnimationController,
      builder: (context, child) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(
              // ProgressTabProvider.bgURL[user.backgroundImageIndex ?? 0],
              ProgressTabModel.bgURL[user.backgroundImageIndex ?? 0],
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(
            sigmaX: _blurTween.value,
            sigmaY: _blurTween.value,
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0, -0.5),
                end: Alignment(0, 1),
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(_brightnessTween.value),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> _showCalendar() {
    return showModalBottomSheet<bool>(
      context: homeScreenNavigatorKey.currentContext!,
      builder: (context) => Container(
        color: kCardColor,
        height: 500,
        child: TableCalendar(
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyles.body2,
            weekendStyle: TextStyles.body2_red,
          ),
          headerStyle: HeaderStyle(
            formatButtonShowsNext: false,
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyles.body1_w800,
          ),
          selectedDayPredicate: (day) {
            return isSameDay(widget.model.selectedDate, day);
          },
          calendarStyle: CalendarStyle(
            weekendTextStyle: TextStyles.body2_red,
            defaultTextStyle: TextStyles.body2,
            outsideTextStyle: TextStyles.body2_grey700,
          ),
          onDaySelected: (selectedDay, focusedDay) {
            widget.model.selectSelectedDate(selectedDay);
            widget.model.selectFocusedDate(focusedDay);

            Navigator.of(context).pop();
          },
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: widget.model.focusedDate,
        ),
      ),
    );
  }
}
