import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:workout_player/widgets/speed_dial_children.dart';

class SpeedDialFAB2 extends StatefulWidget {
  final bool? initiallyOpen;
  final double distance;
  final List<Widget> dials;

  const SpeedDialFAB2({
    Key? key,
    this.initiallyOpen,
    required this.distance,
    required this.dials,
  }) : super(key: key);
  @override
  _SpeedDialFAB2State createState() => _SpeedDialFAB2State();
}

class _SpeedDialFAB2State extends State<SpeedDialFAB2>
    with SingleTickerProviderStateMixin {
  late bool _isOpen;
  late AnimationController _controller;
  late Animation<double> _childrenAnimation;
  Duration _duration = Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    _isOpen = widget.initiallyOpen ?? false;
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

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment(0, 0.93),
        children: [
          // _buildAnimatedContainer(),
          _buildTapToCloseFab(),
          _SpeedDialChildrenWidget(
            distance: widget.distance,
            degree: 180.0,
            progress: _childrenAnimation,
            child: SpeedDialChildren(
              onPressed: () {},
              icon: Icon(
                Icons.fitness_center_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          _buildTapToOpenFab(),
        ],
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
          bottom: 36 + offset.dy,
          child: child!,
        );
      },
      child: child,
    );
  }
}
