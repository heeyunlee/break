import 'package:flutter/material.dart';
import 'package:workout_player/styles/button_styles.dart';

class BreakElevatedButton extends StatefulWidget {
  const BreakElevatedButton({
    Key? key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.onPressed,
    this.color,
  }) : super(key: key);

  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onPressed;
  final Color? color;

  @override
  State<BreakElevatedButton> createState() => _BreakElevatedButtonState();
}

class _BreakElevatedButtonState extends State<BreakElevatedButton>
    with SingleTickerProviderStateMixin {
  // late AnimationController _animationController;
  // // late Animation<double> _scaleAnimation;

  // bool get isPressed => _isPressed;

  // bool _isPressed = false;

  // set isPressed(bool value) {
  //   setState(() {
  //     _isPressed = value;
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   _animationController = AnimationController(
  //     vsync: this,
  //     duration: const Duration(milliseconds: 100),
  //   );
  //   // final Tween<double> scaleTween = Tween<double>(begin: 1, end: 0.95);

  //   // _scaleAnimation = scaleTween.animate(_animationController);
  // }

  // @override
  // void dispose() {
  //   _animationController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (detail) {
        // _animationController.forward();
      },
      onTapUp: (detail) {
        // _animationController.reverse();
        widget.onPressed?.call();
      },
      onTapCancel: () {
        // _animationController.reverse();
      },
      onLongPress: () {},

      // child: AnimatedBuilder(
      //   animation: _animationController,
      //   builder: (context, child) {
      //     return Transform.scale(
      //       scale: _scaleAnimation.value,
      //       child: child!,
      //     );
      //   },
      //   child: widget.child,
      // ),
      child: ElevatedButton(
        style: ButtonStyles.elevated(
          context,
          backgroundColor: widget.color,
        ),
        onPressed: () {
          widget.onPressed?.call();
        },
        // onPressed: widget.onPressed,
        child: widget.child,
      ),
    );
  }
}
