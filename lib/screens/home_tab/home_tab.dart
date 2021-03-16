import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/common_widgets/empty_content.dart';
import 'package:workout_player/common_widgets/speed_dial_fab.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/screens/library_tab/activity/routine_history/daily_summary_detail_screen.dart';
import 'package:workout_player/services/database.dart';

import '../../constants.dart';
import 'routine_history_summary_card.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: Image.asset(
          'assets/logos/playerh_logo.png',
          width: 32,
          height: 32,
        ),
        flexibleSpace: const AppbarBlurBG(),
      ),
      backgroundColor: BackgroundColor,
      body: Builder(
        builder: (BuildContext context) => _buildBody(context),
      ),
      floatingActionButton: SpeedDialFAB(),
    );
  }

  Widget _buildBody(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return PaginateFirestore(
      query: database.routineHistoriesPaginatedPublicQuery(),
      itemBuilderType: PaginateBuilderType.listView,
      emptyDisplay: const EmptyContent(
        message: 'Nothing There...',
      ),
      itemsPerPage: 10,
      header: SizedBox(height: Scaffold.of(context).appBarMaxHeight + 8),
      footer: const SizedBox(height: 16),
      onError: (error) => EmptyContent(
        message: 'Something went wrong: $error',
      ),
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (index, context, documentSnapshot) {
        final documentId = documentSnapshot.id;
        final data = documentSnapshot.data();
        final routineHistory = RoutineHistory.fromMap(data, documentId);

        return RoutineHistorySummaryFeedCard(
          routineHistory: routineHistory,
          onTap: () => DailySummaryDetailScreen.show(
            context: context,
            routineHistory: routineHistory,
          ),
        );
      },
      isLive: true,
    );
  }
}
