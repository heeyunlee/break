import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../services/database.dart';
import '../../common_widgets/empty_content.dart';
import '../../common_widgets/speed_dial_fab.dart';
import '../../models/routine_history.dart';
import '../progress_tab/weights_lifted/routine_history/daily_summary_detail_screen.dart';
import '../settings/settings_screen.dart';
import 'routine_history_summary_card.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with TickerProviderStateMixin {
  PaginateRefreshedChangeListener refreshChangeListener =
      PaginateRefreshedChangeListener();

  // For SliverApp to Work
  AnimationController _colorAnimationController;
  AnimationController _textAnimationController;
  Animation _colorTween;
  Animation<Offset> _transTween;

  bool _scrollListener(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.vertical) {
      _colorAnimationController
          .animateTo((scrollInfo.metrics.pixels - 16) / 50);

      _textAnimationController.animateTo((scrollInfo.metrics.pixels - 16) / 50);
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _colorAnimationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 0),
    );
    _textAnimationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 0),
    );
    _colorTween = ColorTween(begin: Colors.transparent, end: AppBarColor)
        .animate(_colorAnimationController);
    _transTween = Tween(begin: Offset(-10, 40), end: Offset(-10, 0))
        .animate(_textAnimationController);
  }

  @override
  void dispose() {
    _colorAnimationController.dispose();
    _textAnimationController.dispose();
    refreshChangeListener.dispose();
    super.dispose();
  }
  // For SliverApp to Work

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: _scrollListener,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(48),
          child: AnimatedBuilder(
            animation: _colorAnimationController,
            builder: (context, child) => AppBar(
              centerTitle: true,
              elevation: 0,
              backgroundColor: _colorTween.value,
              title: Transform.translate(
                offset: _transTween.value,
                child: Image.asset(
                  'assets/logos/playerh_logo.png',
                  width: 32,
                  height: 32,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.settings_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () => SettingsScreen.show(
                    context,
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
        backgroundColor: BackgroundColor,
        body: Builder(
          builder: (BuildContext context) => _buildBody(context),
        ),
        floatingActionButton: SpeedDialFAB(),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return RefreshIndicator(
      onRefresh: () async {
        refreshChangeListener.refreshed = true;
      },
      child: PaginateFirestore(
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
              context,
              routineHistory: routineHistory,
            ),
          );
        },
        isLive: true,
      ),
    );
  }
}
