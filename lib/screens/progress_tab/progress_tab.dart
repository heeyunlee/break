import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/services/main_provider.dart';
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
  // AppBar Animation
  late AnimationController _appBarAnimatedController;
  late Animation<Color?> _colorTween;
  late Animation<Offset> _transTween;
  late Animation<double> _opacityTween;

  // DailyProgressSummaryWidget Animation
  late AnimationController _summaryAnimationController;
  late Animation<Size?> _sizeTween;
  late Animation<double> _summaryOpacityTween;

  bool _scrollListener(ScrollNotification scrollInfo) {
    debugPrint('${scrollInfo.metrics.pixels}');

    final size = MediaQuery.of(context).size;

    if (scrollInfo.metrics.axis == Axis.vertical) {
      _appBarAnimatedController.animateTo(
          (scrollInfo.metrics.pixels - size.height * 4 / 5 + 120) / 100);

      _summaryAnimationController.animateTo(scrollInfo.metrics.pixels / 1600);

      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _appBarAnimatedController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));

    _colorTween = ColorTween(begin: Colors.transparent, end: kAppBarColor)
        .animate(_appBarAnimatedController);
    _transTween = Tween<Offset>(begin: Offset(0, 16), end: Offset(0, 0))
        .animate(_appBarAnimatedController);
    _opacityTween =
        Tween<double>(begin: 0, end: 1).animate(_appBarAnimatedController);

    _summaryAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));

    _summaryOpacityTween =
        Tween<double>(begin: 1, end: 0).animate(_summaryAnimationController);
  }

  @override
  void dispose() {
    _appBarAnimatedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.d('progress Tab Scaffold building...');
    final size = MediaQuery.of(context).size;
    final String today = DateFormat.MMMEd().format(DateTime.now());

    _sizeTween = SizeTween(
      begin: Size(size.width, size.height),
      end: Size(size.width / 1.1, size.height / 1.1),
    ).animate(_summaryAnimationController);

    final auth = Provider.of<AuthBase>(context, listen: false);
    final database = Provider.of<Database>(context, listen: false);

    return NotificationListener<ScrollNotification>(
      onNotification: _scrollListener,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.deepPurpleAccent,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: AnimatedBuilder(
            animation: _appBarAnimatedController,
            builder: (context, child) => AppBar(
              centerTitle: true,
              brightness: Brightness.dark,
              elevation: 0,
              backgroundColor: _colorTween.value,
              title: Transform.translate(
                offset: _transTween.value,
                child: Opacity(
                  opacity: _opacityTween.value,
                  child: Text(today, style: kSubtitle2),
                ),
              ),
            ),
          ),
        ),
        body: CustomStreamBuilderWidget<User?>(
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
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: _summaryAnimationController,
          builder: (context, child) => DailyProgressSummaryWidget(
            user: user,
            heightFactor: _sizeTween.value!.height,
            widthFactor: _sizeTween.value!.width,
            opacity: _summaryOpacityTween.value,
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: size.height * 4 / 5),
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
                      const Icon(Icons.drag_handle_rounded),
                      const SizedBox(height: 56),
                      WeightsLiftedChartWidget(user: user, auth: auth),
                      ProteinsEatenChartWidget(user: user, auth: auth),
                      MeasurementsLineChartWidget(user: user),
                      const SizedBox(height: 120),
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
