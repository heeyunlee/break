import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/screens/speed_dial_screens/add_measurement_screen.dart';
import 'package:workout_player/screens/speed_dial_screens/add_protein_screen.dart';
import 'package:workout_player/screens/speed_dial_screens/start_workout_shortcut_screen.dart';
import 'package:workout_player/widgets/speed_dial/speed_dial_children.dart';

import 'background_overlay.dart';

class ExpandableFAB extends StatefulWidget {
  final double distance;

  const ExpandableFAB({
    Key? key,
    required this.distance,
  }) : super(key: key);

  @override
  _ExpandableFABState createState() => _ExpandableFABState();
}

class _ExpandableFABState extends State<ExpandableFAB>
    with SingleTickerProviderStateMixin {
  late bool _isOpen;
  late AnimationController _controller;
  late Animation<double> _childrenAnimation;

  final Duration _duration = Duration(milliseconds: 200);

  @override
  void initState() {
    super.initState();
    _isOpen = false;
    _controller = AnimationController(
      value: _isOpen ? 1.0 : 0.0,
      duration: _duration,
      vsync: this,
    );

    _childrenAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _toggleAnimation() {
    _isOpen = !_isOpen;
    setState(() {
      if (_isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  Future<void> _deviceInfo() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.iosInfo;
    print(deviceInfo.model);
  }

  @override
  Widget build(BuildContext context) {
    _deviceInfo();

    return SizedBox.expand(
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              clipBehavior: Clip.none,
              alignment: Alignment(0, 0.93),
              children: [
                _renderOverlay(),
                _buildTapToCloseFab(),
                ..._buildExpandingActionButtons(),
                _buildTapToOpenFab(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _renderOverlay() {
    return PositionedDirectional(
      end: -16,
      bottom: -16,
      top: _isOpen ? 0.0 : null,
      start: _isOpen ? 0.0 : null,
      child: GestureDetector(
        onTap: _toggleAnimation,
        child: BackgroundOverlay(
          animation: _controller,
          color: Colors.black,
          opacity: 0.5,
        ),
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56.0,
      height: 56.0,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          color: Colors.transparent,
          child: InkWell(
            onTap: _toggleAnimation,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.close,
                color: Colors.transparent,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _expandingChildren() {
    return [
      SpeedDialChildren(
        label: S.current.measurements,
        onPressed: () {
          _toggleAnimation();
          AddMeasurementScreen.show(context);
        },
        icon: const FaIcon(
          FontAwesomeIcons.weight,
          color: Colors.white,
          size: 20,
        ),
      ),
      SpeedDialChildren(
        label: S.current.workout,
        onPressed: () {
          _toggleAnimation();
          StartWorkoutShortcutScreen.show(context);
        },
        icon: Icon(
          Icons.fitness_center_rounded,
          color: Colors.white,
          size: 20,
        ),
      ),
      SpeedDialChildren(
        label: S.current.nutritions,
        onPressed: () {
          _toggleAnimation();
          AddProteinScreen.show(context);
        },
        icon: Icon(
          Icons.restaurant_menu_rounded,
          color: Colors.white,
          size: 20,
        ),
      ),
    ];
  }

  List<Widget> _buildExpandingActionButtons() {
    // final children = <Widget>[];
    final modifiedChildren = <Widget>[];
    final count = _expandingChildren().length;
    final step = 120.0 / (count - 1);
    for (var i = 0, angleInDegrees = 60.0;
        i < count;
        i++, angleInDegrees += step) {
      modifiedChildren.add(
        _SpeedDialChildrenWidget(
          degree: angleInDegrees,
          distance: widget.distance,
          progress: _childrenAnimation,
          child: _expandingChildren()[i],
        ),
      );
    }
    return modifiedChildren;
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _isOpen,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transformAlignment: Alignment.center,
        transform: Matrix4.rotationZ(_isOpen ? math.pi / 4 : 0),
        child: FloatingActionButton(
          onPressed: _toggleAnimation,
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Icon(
            Icons.add_circle_rounded,
            size: 56,
          ),
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
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final Offset offset = Offset.fromDirection(
          degree * (math.pi / 240),
          progress.value * distance,
        );
        return Positioned(
          right: 174 + offset.dx,
          bottom: 32 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
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
