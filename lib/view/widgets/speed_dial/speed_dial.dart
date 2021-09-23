import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/view/screens/choose_routine_screen.dart';
import 'package:workout_player/view_models/add_measurements_screen_model.dart';
import 'package:workout_player/view_models/add_nutrition_screen_model.dart';
import 'package:workout_player/view_models/home_screen_model.dart';
import 'package:workout_player/view_models/main_model.dart';
import 'package:workout_player/view_models/speed_dial_model.dart';

import '../speed_dial.dart';

class SpeedDial extends StatefulWidget {
  final SpeedDialModel model;

  const SpeedDial({Key? key, required this.model}) : super(key: key);

  static Widget create() {
    return Consumer(
      builder: (context, watch, child) => SpeedDial(
        model: watch(speedDialModelProvider),
      ),
    );
  }

  @override
  _SpeedDialState createState() => _SpeedDialState();
}

class _SpeedDialState extends State<SpeedDial>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.model.init(this);
  }

  @override
  void dispose() {
    widget.model.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.d('[SpeedDial] widget building');

    return Consumer(
      builder: (context, watch, child) {
        final homeModel = watch(homeScreenModelProvider);
        final size = MediaQuery.of(context).size;

        return ValueListenableBuilder<double>(
          valueListenable: homeModel.valueNotifier!,
          builder: (context, height, child) => Transform.translate(
            offset: Offset(
              0,
              homeModel.getYOffset(
                min: homeModel.miniplayerMinHeight!,
                max: size.height,
                value: height,
              ),
            ),
            child: child,
          ),
          child: SizedBox.expand(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                _renderOverlay(),
                ..._buildExpandingActionButtons(context),
                SafeArea(child: _buildTapToOpenFab()),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _renderOverlay() {
    return PositionedDirectional(
      end: 0,
      bottom: 0,
      top: widget.model.isOpen ? 0.0 : null,
      start: widget.model.isOpen ? 0.0 : null,
      child: GestureDetector(
        onTap: widget.model.toggleAnimation,
        child: BackgroundOverlay(
          animation: widget.model.controller,
          color: Colors.transparent,
          opacity: 0.5,
        ),
      ),
    );
  }

  List<Widget> _expandingChildren(BuildContext context) {
    return [
      SpeedDialChildren(
        label: S.current.measurements,
        onPressed: () {
          widget.model.toggleAnimation();

          AddMeasurementsScreenModel.show(context);
        },
        icon: const Icon(Icons.monitor_weight_rounded, size: 20),
      ),
      SpeedDialChildren(
        label: S.current.workout,
        onPressed: () {
          widget.model.toggleAnimation();
          ChooseRoutineScreen.show(context);
        },
        icon: const Icon(
          Icons.fitness_center_rounded,
          color: Colors.white,
          size: 20,
        ),
      ),
      SpeedDialChildren(
        label: S.current.nutritions,
        onPressed: () {
          widget.model.toggleAnimation();
          AddNutritionScreenModel.show(context);
        },
        icon: const Icon(
          Icons.restaurant_menu_rounded,
          color: Colors.white,
          size: 20,
        ),
      ),
    ];
  }

  List<Widget> _buildExpandingActionButtons(BuildContext context) {
    final modifiedChildren = <Widget>[];
    final count = _expandingChildren(context).length;
    final step = 90 / (count - 1);

    for (var i = 0, angleInDegrees = 45.0;
        i < count;
        i++, angleInDegrees += step) {
      modifiedChildren.add(
        _SpeedDialChildrenWidget(
          degree: angleInDegrees,
          distance: 136,
          progress: widget.model.childrenAnimation,
          child: _expandingChildren(context)[i],
        ),
      );
    }
    return modifiedChildren;
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: widget.model.isOpen,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transformAlignment: Alignment.center,
        transform: Matrix4.rotationZ(widget.model.isOpen ? math.pi / 4 : 0),
        child: FloatingActionButton(
          onPressed: widget.model.toggleAnimation,
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add_circle_rounded, size: 52),
        ),
      ),
    );
  }
}

class _SpeedDialChildrenWidget extends StatelessWidget {
  final double distance;
  final double degree;
  final Animation<double> progress;
  final Widget child;

  const _SpeedDialChildrenWidget({
    Key? key,
    required this.distance,
    required this.degree,
    required this.progress,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final center = size.width / 2 - 40;

    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final Offset offset = Offset.fromDirection(
          degree * (math.pi / 180),
          progress.value * distance,
        );
        return Positioned(
          right: center + offset.dx,
          bottom: 8 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}
