import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/services/main_provider.dart';
import 'package:workout_player/widgets/custom_stream_builder_widget.dart';
import 'package:workout_player/widgets/shimmer/progress_tab_shimmer.dart';

import '../../styles/constants.dart';
import 'daily_progress_summary/daily_nutrition_widget.dart';
import 'daily_progress_summary/daily_weights_widget.dart';
import 'measurement/measurements_line_chart_widget.dart';
import 'proteins_eaten/proteins_eaten_chart_widget.dart';
import 'weights_lifted_history/weights_lifted_chart_widget.dart';

class ProgressTab extends StatefulWidget {
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
    debugPrint('${scrollInfo.metrics.pixels}');

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

    _bgAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 0));

    _blurTween =
        Tween<double>(begin: 0, end: 20).animate(_bgAnimationController);
    _brightnessTween =
        Tween<double>(begin: 0.9, end: 0.0).animate(_bgAnimationController);
  }

  @override
  void dispose() {
    _bgAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.d('progress Tab Scaffold building...');

    final auth = Provider.of<AuthBase>(context, listen: false);
    final database = Provider.of<Database>(context, listen: false);

    final today = DateFormat.MMMEd().format(DateTime.now());

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
            title: Text(today, style: kSubtitle2),
            backgroundColor: Colors.transparent,
          ),
        ),
        body: CustomStreamBuilderWidget<User?>(
          stream: database.userStream(),
          loadingWidget: ProgressTabShimmer(),
          hasDataWidget: (context, snapshot) => Builder(
            builder: (context) => _buildChildWidget(
              context,
              snapshot.data!,
              database,
              auth,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChildWidget(
    BuildContext context,
    User user,
    Database database,
    AuthBase auth,
  ) {
    final size = MediaQuery.of(context).size;

    return Stack(
      alignment: Alignment.center,
      fit: StackFit.passthrough,
      children: [
        _buildBlurredBG(),
        // Container(
        //   decoration: BoxDecoration(
        //     gradient: LinearGradient(
        //       begin: Alignment(0, -1),
        //       end: Alignment(0, 1),
        //       colors: [
        //         Colors.transparent,
        //         Colors.black.withOpacity(0),
        //       ],
        //     ),
        //   ),
        //   width: size.width,
        //   height: size.height,
        // ),
        Padding(
          padding: EdgeInsets.only(top: Scaffold.of(context).appBarMaxHeight!),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: size.height * 0.5),
                  Stack(
                    children: [
                      // Text(S.current.todaysSummary, style: kBodyText2),
                      DailyWeightsWidget(user: user),
                      DailyNutritionWidget(user: user),
                    ],
                  ),
                  WeightsLiftedChartWidget(user: user, auth: auth),
                  ProteinsEatenChartWidget(user: user, auth: auth),
                  MeasurementsLineChartWidget(user: user),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  AnimatedBuilder _buildBlurredBG() {
    return AnimatedBuilder(
      animation: _bgAnimationController,
      builder: (context, child) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ExactAssetImage('assets/images/AdobeStock_86647104.jpeg'),
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
}
