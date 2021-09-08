import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

class RoutineBottomSheet extends StatelessWidget {
  const RoutineBottomSheet({
    Key? key,
    required this.routine,
    required this.onTap,
  }) : super(key: key);

  final Routine routine;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(24),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: kCardColor.withOpacity(0.75),
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
          ),
          height: size.height / 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  routine.routineTitle,
                  style: TextStyles.headline6,
                ),
              ),
              ListTile(
                onTap: onTap,
                leading: const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                title: Text(S.current.deleteLowercase, style: TextStyles.body2),
              ),
              ListTile(
                onTap: () => Navigator.of(context).pop(),
                leading: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                title: Text(S.current.cancel, style: TextStyles.body2),
              ),
              const SizedBox(height: kBottomNavigationBarHeight + 48),
            ],
          ),
        ),
      ),
    );
  }
}
