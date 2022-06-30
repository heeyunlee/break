import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/styles/text_styles.dart';

class WorkoutTitleWidget extends StatelessWidget {
  final Workout workout;
  final double? width;
  final bool isAppBarTitle;

  const WorkoutTitleWidget({
    Key? key,
    required this.workout,
    this.width,
    this.isAppBarTitle = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: width ?? size.width - 32,
      child: _buildChild(workout),
    );
  }

  Widget _buildChild(Workout workout) {
    final locale = Intl.getCurrentLocale();
    final title =
        workout.translated[locale]?.toString() ?? workout.workoutTitle;

    if (isAppBarTitle) {
      return Center(child: Text(title, style: TextStyles.subtitle1));
    } else {
      if (title.length < 21) {
        return Text(
          title,
          style: GoogleFonts.blackHanSans(
            color: Colors.white,
            fontSize: 32,
          ),
          maxLines: 1,
          overflow: TextOverflow.fade,
          softWrap: false,
        );
      } else if (title.length >= 21 && title.length < 35) {
        return FittedBox(
          child: Text(
            title,
            style: GoogleFonts.blackHanSans(
              color: Colors.white,
              fontSize: 32,
            ),
          ),
        );
      } else {
        return Text(
          title,
          style: GoogleFonts.blackHanSans(
            color: Colors.white,
            fontSize: 22,
          ),
          maxLines: 1,
          overflow: TextOverflow.fade,
          softWrap: false,
        );
      }
    }
  }
}
