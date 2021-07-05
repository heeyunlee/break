import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;

import 'package:workout_player/models/user.dart';
import 'package:workout_player/screens/home/progress_tab/widgets/blurred_background.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/services/main_provider.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/widgets/blur_background_card.dart';
import 'package:workout_player/widgets/custom_stream_builder_widget.dart';
import 'package:workout_player/widgets/shimmer/progress_tab_shimmer.dart';

import '../../../styles/constants.dart';
import 'daily_progress_summary/daily_nutrition_widget.dart';
import 'daily_progress_summary/daily_weights_widget.dart';
import 'measurement/measurements_line_chart_widget.dart';
import 'progress_tab_model.dart';
import 'proteins_eaten/weekly_nutrition_chart.dart';
import 'weights_lifted_history/weights_lifted_chart_widget.dart';
import 'widgets/blurred_material_banner.dart';
import 'widgets/choose_background_icon.dart';
import 'widgets/choose_date_icon_button.dart';

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
      builder: (context, ref, child) => ProgressTab(
        database: database,
        model: ref.watch(progressTabModelProvider),
      ),
    );
  }

  @override
  _ProgressTabState createState() => _ProgressTabState();
}

class _ProgressTabState extends State<ProgressTab>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.model.init(this);
    widget.model.initShowBanner();
  }

  @override
  void dispose() {
    widget.model.animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.d('Progress Tab Scaffold building...');

    return CustomStreamBuilderWidget<User?>(
      stream: widget.model.database!.userStream(),
      loadingWidget: ProgressTabShimmer(),
      hasDataWidget: (context, user) {
        return NotificationListener<ScrollNotification>(
          onNotification: widget.model.onNotification,
          child: Scaffold(
            backgroundColor: kBackgroundColor,
            extendBodyBehindAppBar: true,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: AppBar(
                centerTitle: true,
                brightness: Brightness.dark,
                elevation: 0,
                leading: ChooseBackgroundIcon(user: user!),
                title: ChooseDateIconButton(model: widget.model),
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

    return Stack(
      children: [
        BlurredBackground(
          model: widget.model,
          imageIndex: user.backgroundImageIndex,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0, -1.00),
              end: Alignment(0, -0.75),
              colors: [
                Colors.black.withOpacity(0.500),
                Colors.transparent,
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: Scaffold.of(context).appBarMaxHeight!,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (widget.model.showBanner)
                    BlurredMaterialBanner(model: widget.model),
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
                      ),
                      DailyNutritionWidget.create(
                        user: user,
                        model: widget.model,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      BlurBackgroundCard(
                        width: size.width / 2 - 24,
                        height: 96,
                        borderRadius: 8,
                        child: Stack(
                          children: [
                            Container(
                              color: Colors.blue,
                              width: (size.width / 2 - 24) * 0.8,
                              height: double.maxFinite,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('오늘 07:24', style: TextStyles.overline),
                                  const SizedBox(height: 8),
                                  Text('75.6 kg',
                                      style: TextStyles.headline5_menlo),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      BlurBackgroundCard(
                        width: size.width / 2 - 24,
                        height: 96,
                        child: Text('asdas'),
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
    );
  }
}
