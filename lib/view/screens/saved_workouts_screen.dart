import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/styles/theme_colors.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/main_model.dart';
import 'package:workout_player/view/widgets/library/library_list_tile.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/database.dart';

import 'workout_detail_screen.dart';

class SavedWorkoutsScreen extends StatelessWidget {
  final Database database;
  final User user;

  const SavedWorkoutsScreen({
    Key? key,
    required this.database,
    required this.user,
  }) : super(key: key);

  static void show(BuildContext context, {required User user}) {
    final database = Provider.of<Database>(context, listen: false);

    HapticFeedback.mediumImpact();
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => SavedWorkoutsScreen(
          database: database,
          user: user,
        ),
      ),
    );
  }

  void _getDocuments(List<Future<Workout?>> workoutsFuture) {
    user.savedWorkouts?.map((id) {
      final Future<Workout?> nextDoc = database.getWorkout(id);
      workoutsFuture.add(nextDoc);
    });
    // user.savedWorkouts!.forEach((id) {
    //   final Future<Workout?> nextDoc = database.getWorkout(id);
    //   workoutsFuture.add(nextDoc);
    // });
  }

  @override
  Widget build(BuildContext context) {
    final List<Future<Workout?>> workoutsFuture = [];

    final size = MediaQuery.of(context).size;

    _getDocuments(workoutsFuture);

    return Scaffold(
      backgroundColor: ThemeColors.background,
      appBar: AppBar(
        title: Text(S.current.savedWorkouts, style: TextStyles.subtitle2),
        centerTitle: true,
        backgroundColor: ThemeColors.appBar,
        flexibleSpace: const AppbarBlurBG(),
        leading: const AppBarBackButton(),
      ),
      body: (user.savedWorkouts!.isEmpty)
          ? EmptyContent(message: S.current.noSavedWorkoutsYet)
          : SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: size.height,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: workoutsFuture.map((element) {
                      return FutureBuilder<Workout?>(
                        future: element,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final Workout workout = snapshot.data!;

                            final subtitle = MainMuscleGroup.values
                                .firstWhere(
                                  (e) =>
                                      e.toString() ==
                                      workout.mainMuscleGroup[0],
                                )
                                .translation;

                            return LibraryListTile(
                              tag: 'savedWorkout-${workout.workoutId}',
                              title: workout.workoutTitle,
                              subtitle: subtitle!,
                              imageUrl: workout.imageUrl,
                              onTap: () => WorkoutDetailScreen.show(
                                context,
                                workout: workout,
                                workoutId: workout.workoutId,
                                tag: 'savedWorkout-${workout.workoutId}',
                              ),
                            );
                          } else if (snapshot.hasError) {
                            logger.e(snapshot.error);
                            return const ListTile(
                              leading: Icon(
                                Icons.error_outline_outlined,
                                color: Colors.white,
                              ),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
    );
  }
}
