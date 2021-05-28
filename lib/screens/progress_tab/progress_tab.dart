import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/widgets/empty_content.dart';
import 'package:workout_player/widgets/shimmer/progress_tab_shimmer.dart';

import '../../constants.dart';
import 'daily_progress_summary/daily_progress_summary_widget.dart';
import 'measurement/measurements_line_chart_widget.dart';
import 'proteins_eaten/proteins_eaten_chart_widget.dart';
import 'weights_lifted_history/weights_lifted_chart_widget.dart';

class ProgressTab extends StatefulWidget {
  @override
  _ProgressTabState createState() => _ProgressTabState();
}

class _ProgressTabState extends State<ProgressTab>
    with TickerProviderStateMixin {
  late Animation _colorTween;
  late AnimationController _colorAnimationController;

  bool _scrollListener(ScrollNotification scrollInfo) {
    final size = MediaQuery.of(context).size;

    if (scrollInfo.metrics.axis == Axis.vertical) {
      debugPrint('${scrollInfo.metrics.pixels}');
      _colorAnimationController
          .animateTo((scrollInfo.metrics.pixels - size.height + 160) / 50);

      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _colorAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));
    _colorTween = ColorTween(begin: Colors.transparent, end: kAppBarColor)
        .animate(_colorAnimationController);
  }

  @override
  void dispose() {
    super.dispose();
    _colorAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('Progress Tab scaffold building...');

    return NotificationListener<ScrollNotification>(
      onNotification: _scrollListener,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        // backgroundColor: Color(0xffa7a6ba),
        backgroundColor: kBackgroundColor,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AnimatedBuilder(
            animation: _colorAnimationController,
            builder: (context, child) => AppBar(
              brightness: Brightness.dark,
              elevation: 0,
              backgroundColor: _colorTween.value,
            ),
          ),
        ),
        body: Consumer(
          builder: (context, watch, child) {
            final uid = watch(authServiceProvider).currentUser!.uid;
            final userStream = watch(userStreamProvider(uid));

            return userStream.when(
              data: (user) => _buildChildWidget(user!),
              loading: () => ProgressTabShimmer(),
              error: (e, stack) => EmptyContent(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildChildWidget(User user) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        DailyProgressSummaryWidget(user: user),
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height - 184,
                width: size.width,
              ),
              Container(
                decoration: BoxDecoration(
                  color: kBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 56),
                      WeightsLiftedChartWidget(user: user),
                      ProteinsEatenChartWidget(user: user),
                      MeasurementsLineChartWidget(user: user),
                      const SizedBox(height: 56),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
