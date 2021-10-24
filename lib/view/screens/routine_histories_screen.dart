import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/view/screens/choose_routine_screen.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view/widgets/progress/daily_summary_card.dart';
import 'package:workout_player/view/widgets/widgets.dart';

import 'routine_history_detail_screen.dart';

class RoutineHistoriesScreen extends StatelessWidget {
  final Database database;
  final AuthBase auth;

  const RoutineHistoriesScreen({
    Key? key,
    required this.database,
    required this.auth,
  }) : super(key: key);

  static void show(BuildContext context) {
    customPush(
      context,
      rootNavigator: false,
      builder: (context, auth, database) => RoutineHistoriesScreen(
        database: database,
        auth: auth,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.routineHistoryTitle, style: TextStyles.subtitle2),
        centerTitle: true,
        leading: const AppBarBackButton(),
      ),
      body: CustomStreamBuilder<List<RoutineHistory>>(
        stream: database.routineHistoriesStream(),
        emptyWidget: EmptyContentWidget(
          imageUrl: 'assets/images/routine_history_empty_bg.png',
          bodyText: S.current.routineHistoyEmptyMessage,
          onPressed: () => ChooseRoutineScreen.show(context),
        ),
        errorWidget: EmptyContent(
          message: S.current.somethingWentWrong,
        ),
        builder: (context, data) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                CustomListViewBuilder<RoutineHistory>(
                  items: data,
                  itemBuilder: (context, routineHistory, i) {
                    return RoutineHistorySummaryCard(
                      routineHistory: routineHistory,
                      onTap: () => RoutineHistoryDetailScreen.show(
                        context,
                        routineHistory: routineHistory,
                        database: database,
                        auth: auth,
                        theme: Theme.of(context),
                      ),
                    );
                  },
                ),
                const SizedBox(height: kBottomNavigationBarHeight + 48),
              ],
            ),
          );
        },
      ),
    );
  }
}
