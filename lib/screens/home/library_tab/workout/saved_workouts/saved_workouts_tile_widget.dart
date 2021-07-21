import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/dummy_data.dart';
import 'package:workout_player/widgets/custom_stream_builder_widget.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/classes/user.dart';
import 'package:workout_player/services/database.dart';

import 'saved_workouts_screen.dart';

class SavedWorkoutsTileWidget extends StatelessWidget {
  String _getSubtitle(User user) {
    if (user.savedWorkouts != null) {
      if (user.savedWorkouts!.isNotEmpty) {
        if (user.savedWorkouts!.length == 1) {
          return '1 ${S.current.workout}';
        }
        return '${user.savedWorkouts!.length} ${S.current.workout}';
      } else {
        return '0 ${S.current.workout}';
      }
    } else {
      return '0 ${S.current.workout}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return CustomStreamBuilderWidget<User?>(
      initialData: userDummyData,
      stream: database.userStream(),
      errorWidget: ListTile(
        leading: Icon(Icons.error, color: Colors.white),
        title: Text(S.current.errorOccuredMessage, style: kBodyText1Bold),
      ),
      hasDataWidget: (context, data) {
        // final User user = snapshot.data!;

        return InkWell(
          onTap: () => SavedWorkoutsScreen.show(context, user: data!),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Card(
              color: Colors.transparent,
              elevation: 0,
              child: Row(
                children: <Widget>[
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: kGrey800,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Icon(
                      Icons.bookmark_border_rounded,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(S.current.savedWorkouts, style: kBodyText1Bold),
                      const SizedBox(height: 4),
                      Text(
                        _getSubtitle(data!),
                        style: TextStyles.body2_grey,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
