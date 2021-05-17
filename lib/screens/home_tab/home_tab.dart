import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/generated/l10n.dart';

import '../../constants.dart';
import '../../services/database.dart';
import '../../widgets/empty_content.dart';
import '../../models/routine_history.dart';
import 'routine_history_summary_card.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with TickerProviderStateMixin {
  PaginateRefreshedChangeListener refreshChangeListener =
      PaginateRefreshedChangeListener();

  // For SliverApp to Work
  late AnimationController _colorAnimationController;
  late AnimationController _textAnimationController;
  late Animation _colorTween;
  late Animation<Offset> _transTween;

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
    _colorTween = ColorTween(begin: Colors.transparent, end: kAppBarColor)
        .animate(_colorAnimationController);
    _transTween = Tween(begin: Offset(0, 40), end: Offset(0, 0))
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
              brightness: Brightness.dark,
              backgroundColor: _colorTween.value,
              title: Transform.translate(
                offset: _transTween.value,
                child: const Text('HēraKless', style: kSubtitle2MenloBold),
              ),
            ),
          ),
        ),
        backgroundColor: kBackgroundColor,
        body: Builder(
          builder: (BuildContext context) => _buildMobileBody(context),
        ),
      ),
    );
  }

  Widget _buildMobileBody(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return RefreshIndicator(
      onRefresh: () async {
        refreshChangeListener.refreshed = true;
      },
      child: PaginateFirestore(
        query: database.routineHistoriesPaginatedPublicQuery(),
        itemBuilderType: PaginateBuilderType.listView,
        emptyDisplay: EmptyContent(
          message: S.current.homeTabEmptyMessage,
        ),
        itemsPerPage: 10,
        header: SizedBox(height: Scaffold.of(context).appBarMaxHeight! + 8),
        footer: const SizedBox(height: 120),
        onError: (error) => EmptyContent(
          message: '${S.current.somethingWentWrong}: $error',
        ),
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (index, context, documentSnapshot) {
          final documentId = documentSnapshot.id;
          final data = documentSnapshot.data()!;
          final routineHistory = RoutineHistory.fromMap(data, documentId);

          return RoutineHistorySummaryFeedCard(routineHistory: routineHistory);
        },
        isLive: true,
      ),
    );
  }
}
