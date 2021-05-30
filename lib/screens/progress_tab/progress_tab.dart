import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/widgets/custom_stream_builder_widget.dart';
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
      // debugPrint('${scrollInfo.metrics.pixels}');
      _colorAnimationController
          .animateTo((scrollInfo.metrics.pixels - size.height * 4 / 5) / 50);

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

    final auth = Provider.of<AuthBase>(context, listen: false);
    final database = Provider.of<Database>(context, listen: false);

    return NotificationListener<ScrollNotification>(
      onNotification: _scrollListener,
      child: Scaffold(
        extendBodyBehindAppBar: true,
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
        body: CustomStreamBuilderWidget<User>(
          stream: database.userStream(auth.currentUser!.uid),
          loadingWidget: ProgressTabShimmer(),
          hasDataWidget: (context, snapshot) => _buildChildWidget(
            snapshot.data!,
            database,
            auth,
          ),
        ),
      ),
    );
  }

  Widget _buildChildWidget(User user, Database database, AuthBase auth) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        DailyProgressSummaryWidget(user: user),
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height - size.height / 5,
                width: size.width,
              ),
              Container(
                decoration: BoxDecoration(
                  color: kBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 56),
                      WeightsLiftedChartWidget(user: user, auth: auth),
                      ProteinsEatenChartWidget(user: user, auth: auth),
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
