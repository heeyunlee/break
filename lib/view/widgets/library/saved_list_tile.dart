import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/models.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view/widgets/widgets.dart';

class SavedListTile<T> extends StatelessWidget {
  const SavedListTile({
    Key? key,
    required this.onTap,
    required this.title,
  }) : super(key: key);

  final void Function(User) onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: CustomStreamBuilder<User?>(
        stream: database.userStream(),
        builder: (context, data) => InkWell(
          onTap: () => onTap(data!),
          borderRadius: BorderRadius.circular(4),
          child: Card(
            color: Colors.transparent,
            elevation: 0,
            child: Row(
              children: <Widget>[
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(4),
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
                    Text(
                      title,
                      style: TextStyles.body1Bold,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getSubtitle(data!),
                      style: TextStyles.body2Grey,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getSubtitle(User user) {
    switch (T) {
      case Workout:
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
      case Routine:
        if (user.savedRoutines != null) {
          if (user.savedRoutines!.isNotEmpty) {
            if (user.savedRoutines!.length == 1) {
              return '1 ${S.current.routine}';
            }
            return '${user.savedRoutines!.length} ${S.current.routinesLowerCase}';
          } else {
            return '0 ${S.current.routine}';
          }
        } else {
          return '0 ${S.current.routine}';
        }
      default:
        return '';
    }
  }
}
