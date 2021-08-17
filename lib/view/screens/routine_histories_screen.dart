import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/view/screens/choose_routine_screen.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/constants.dart';
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

  static Future<void> show(BuildContext context) async {
    final container = ProviderContainer();
    final auth = container.read(authServiceProvider);
    final database = container.read(databaseProvider(auth.currentUser?.uid));

    await HapticFeedback.mediumImpact();
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => RoutineHistoriesScreen(
          database: database,
          auth: auth,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        brightness: Brightness.dark,
        title: Text(S.current.routineHistoryTitle, style: TextStyles.subtitle2),
        centerTitle: true,
        backgroundColor: kAppBarColor,
        flexibleSpace: const AppbarBlurBG(),
        leading: const AppBarBackButton(),
      ),
      body: PaginateFirestore(
        shrinkWrap: true,
        itemsPerPage: 10,
        query: database.routineHistoriesPaginatedUserQuery(),
        itemBuilderType: PaginateBuilderType.listView,
        emptyDisplay: EmptyContentWidget(
          imageUrl: 'assets/images/routine_history_empty_bg.png',
          bodyText: S.current.routineHistoyEmptyMessage,
          onPressed: () => ChooseRoutineScreen.show(context),
        ),
        header: const SliverToBoxAdapter(child: SizedBox(height: 16)),
        footer: const SliverToBoxAdapter(child: SizedBox(height: 120)),
        onError: (error) => EmptyContent(
          message: '${S.current.somethingWentWrong} $error',
        ),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (index, context, documentSnapshot) {
          final routineHistory = documentSnapshot.data()! as RoutineHistory;

          return RoutineHistorySummaryCard(
            routineHistory: routineHistory,
            onTap: () => RoutineHistoryDetailScreen.show(
              context,
              routineHistory: routineHistory,
              database: database,
              auth: auth,
              // user: user,
            ),
          );
        },
        isLive: true,
      ),
    );
  }
}
