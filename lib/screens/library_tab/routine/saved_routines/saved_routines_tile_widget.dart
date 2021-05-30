import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/dummy_data.dart';
import 'package:workout_player/widgets/custom_stream_builder_widget.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/screens/library_tab/routine/saved_routines/saved_routines_screen.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../../../constants.dart';

class SavedRoutinesTileWidget extends StatelessWidget {
  String _getSubtitle(User user) {
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
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    return CustomStreamBuilderWidget<User?>(
      initialData: userDummyData,
      stream: database.userStream(auth.currentUser!.uid),
      errorWidget: ListTile(
        leading: Icon(Icons.error, color: Colors.white),
        title: Text(S.current.errorOccuredMessage, style: kBodyText1Bold),
      ),
      hasDataWidget: (context, snapshot) {
        final User user = snapshot.data!;

        return InkWell(
          onTap: () => SavedRoutinesScreen.show(context, user: user),
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
                      Text(S.current.savedRoutines, style: kBodyText1Bold),
                      const SizedBox(height: 4),
                      Text(
                        _getSubtitle(user),
                        style: kBodyText2Grey,
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
