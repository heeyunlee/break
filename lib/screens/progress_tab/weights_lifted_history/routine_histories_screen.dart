import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/widgets/appbar_blur_bg.dart';
import 'package:workout_player/widgets/empty_content.dart';
import 'package:workout_player/widgets/empty_content_widget.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/screens/home_tab/routine_history/daily_summary_card.dart';
import 'package:workout_player/screens/home_tab/routine_history/routine_history_detail_screen.dart';
import 'package:workout_player/screens/speed_dial_screens/start_workout_shortcut_screen.dart';
import 'package:workout_player/services/database.dart';

import '../../../constants.dart';

class RoutineHistoriesScreen extends StatelessWidget {
  final Database database;

  const RoutineHistoriesScreen({Key? key, required this.database})
      : super(key: key);

  static Future<void> show(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);

    await HapticFeedback.mediumImpact();
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => RoutineHistoriesScreen(
          database: database,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    final user = database.getUserDocument(auth.currentUser!.uid);

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text(S.current.routineHistoryTitle, style: kSubtitle2),
        centerTitle: true,
        backgroundColor: kAppBarColor,
        flexibleSpace: const AppbarBlurBG(),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
        ),
      ),
      body: PaginateFirestore(
        shrinkWrap: true,
        itemsPerPage: 10,
        query: database.routineHistoriesPaginatedUserQuery(),
        itemBuilderType: PaginateBuilderType.listView,
        emptyDisplay: EmptyContentWidget(
          imageUrl: 'assets/images/routine_history_empty_bg.png',
          bodyText: S.current.routineHistoyEmptyMessage,
          onPressed: () => StartWorkoutShortcutScreen.show(context),
        ),
        header: SizedBox(height: 16),
        footer: const SizedBox(height: 16),
        onError: (error) => EmptyContent(
          message: '${S.current.somethingWentWrong} $error',
        ),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (index, context, documentSnapshot) {
          // final documentId = documentSnapshot.id;
          // final data = documentSnapshot.data();
          // final routineHistory = RoutineHistory.fromJson(data!, documentId);
          final snapshot = documentSnapshot as DocumentSnapshot<RoutineHistory>;
          final routineHistory = snapshot.data()!;

          return RoutineHistorySummaryCard(
            date: routineHistory.workoutStartTime,
            workoutTitle: routineHistory.routineTitle,
            totalWeights: routineHistory.totalWeights,
            caloriesBurnt: routineHistory.totalCalories,
            totalDuration: routineHistory.totalDuration,
            earnedBadges: routineHistory.earnedBadges,
            unitOfMass: routineHistory.unitOfMass,
            onTap: () {
              debugPrint('Activity Card was tapped');

              RoutineHistoryDetailScreen.show(
                context,
                routineHistory: routineHistory,
                database: database,
                auth: auth,
                user: user,
              );
            },
          );
        },
        isLive: true,
      ),
    );
  }
}
