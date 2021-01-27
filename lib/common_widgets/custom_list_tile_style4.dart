import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/show_flush_bar.dart';
import 'package:workout_player/models/saved_workout.dart';
import 'package:workout_player/models/user_saved_workout.dart';
import 'package:workout_player/screens/library_tab/workout/workout_detail_screen.dart';
import 'package:workout_player/services/database.dart';

import '../constants.dart';

class CustomListTileStyle4 extends StatelessWidget {
  const CustomListTileStyle4({Key key, this.userSavedWorkout, this.index})
      : super(key: key);

  final UserSavedWorkout userSavedWorkout;
  final int index;

  Future<void> _toggleFavorites(BuildContext context) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.setSavedWorkout(SavedWorkout(
        isFavorite: !userSavedWorkout.isSavedWorkout,
        workoutId: userSavedWorkout.workout.workoutId,
      ));
      HapticFeedback.mediumImpact();
      showFlushBar(
        context: context,
        message: (userSavedWorkout.isSavedWorkout)
            ? 'Removed from Favorites'
            : 'Saved to Favorites',
      );
    } on Exception catch (e) {
      // TODO
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          width: 48,
          height: 48,
          child: (userSavedWorkout.workout.imageUrl == "" ||
                  userSavedWorkout.workout.imageUrl == null)
              ? Image.asset('images/place_holder_workout_playlist.png')
              : Image.network(
                  userSavedWorkout.workout.imageUrl,
                  fit: BoxFit.cover,
                ),
        ),
      ),
      title: Text(
        userSavedWorkout.workout.workoutTitle,
        style: BodyText1.copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle:
          Text(userSavedWorkout.workout.mainMuscleGroup, style: Caption1Grey),
      onTap: () => WorkoutDetailScreen.show(
        context: context,
        workout: userSavedWorkout.workout,
        // index: index,
        // userSavedWorkout: userSavedWorkout,
      ),
      trailing: IconButton(
        icon: Icon(
          (userSavedWorkout.isSavedWorkout)
              ? Icons.favorite
              : Icons.favorite_border_rounded,
        ),
        onPressed: () => _toggleFavorites(context),
      ),
    );
  }
}
