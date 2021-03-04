import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/common_widgets/list_item_builder.dart';
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
    );
  }

  _buildBody(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: Scaffold.of(context).appBarMaxHeight + 8),
          StreamBuilder<List<RoutineHistory>>(
            stream: database.routineHistoriesPublicStream(),
            builder: (context, snapshot) {
              return ListItemBuilder<RoutineHistory>(
                snapshot: snapshot,
                itemBuilder: (context, routineHistory) =>
                    RoutineHistorySummaryFeedCard(
                  routineHistory: routineHistory,
                  onTap: () {
                    debugPrint('Activity Card was tapped');

                    HapticFeedback.mediumImpact();
                    DailySummaryDetailScreen.show(
                      context: context,
                      routineHistory: routineHistory,
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
