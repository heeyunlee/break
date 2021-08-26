import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reorderables/reorderables.dart';

import 'package:workout_player/models/combined/progress_tab_class.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/home_screen_model.dart';
import 'package:workout_player/view_models/progress_tab_widgets_model.dart';

import 'logo_widget.dart';

class ProgressTabWidgetsBuilder extends StatefulWidget {
  final HomeScreenModel homeScreenModel;
  final ProgressTabWidgetsModel model;
  final ProgressTabClass data;
  final BoxConstraints constraints;
  final TickerProvider vsync;

  const ProgressTabWidgetsBuilder({
    Key? key,
    required this.homeScreenModel,
    required this.model,
    required this.data,
    required this.constraints,
    required this.vsync,
  }) : super(key: key);

  static Widget create(
    BuildContext context, {
    required ProgressTabClass data,
    required BoxConstraints constraints,
    required TickerProvider vsync,
  }) {
    return Consumer(
      builder: (context, watch, child) => ProgressTabWidgetsBuilder(
        data: data,
        homeScreenModel: watch(homeScreenModelProvider),
        model: watch(progressTabWidgetsModelProvider),
        constraints: constraints,
        vsync: vsync,
      ),
    );
  }

  @override
  _ProgressTabWidgetsBuilderState createState() =>
      _ProgressTabWidgetsBuilderState();
}

class _ProgressTabWidgetsBuilderState extends State<ProgressTabWidgetsBuilder> {
  @override
  void initState() {
    super.initState();

    widget.model.initWidgets(
      context,
      data: widget.data,
      constraints: widget.constraints,
    );

    widget.model.init(widget.vsync);
  }

  @override
  void dispose() {
    widget.model.staggeredController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = List.generate(
      widget.model.widgets.length,
      (index) {
        final offsetBegin = 0.0 + 0.025 * index;
        final offsetEnd = offsetBegin + 0.2;

        assert(offsetEnd <= 1);

        final opacityBegin = 0.0 + 0.025 * index;
        final opacityEnd = opacityBegin + 0.2;

        assert(opacityEnd <= 1);

        return FadeSlideTransition(
          animation: widget.model.staggeredController,
          // beginOffset: const Offset(0, 1),
          offsetBeginInterval: offsetBegin,
          offsetEndInterval: offsetEnd,
          offsetCurves: Curves.fastOutSlowIn,
          opacityCurves: Curves.fastOutSlowIn,
          opacityBeginInterval: opacityBegin,
          opacityEndInterval: opacityEnd,
          child: widget.model.widgets[index],
        );
      },
    );

    return ReorderableWrap(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      buildDraggableFeedback: widget.model.buildDraggableFeedback,
      onReorder: widget.model.onReorder,
      footer: LogoWidget(
        gridHeight: widget.constraints.maxHeight / 4,
        gridWidth: widget.constraints.maxWidth,
      ),
      children: widget.homeScreenModel.isFirstStartup
          ? widgets
          : widget.model.widgets,
    );
  }
}
