import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/features/screens/choose_routine_screen.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/features/widgets/widgets.dart';

import 'routine_history_detail_screen.dart';

class RoutineHistoriesScreen extends ConsumerWidget {
  const RoutineHistoriesScreen({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    customPush(
      context,
      rootNavigator: false,
      builder: (context) => const RoutineHistoriesScreen(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.routineHistoryTitle, style: TextStyles.subtitle2),
        centerTitle: true,
        leading: const AppBarBackButton(),
      ),
      body: CustomStreamBuilder<List<RoutineHistory>>(
        stream: ref.read(databaseProvider).routineHistoriesStream(),
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
