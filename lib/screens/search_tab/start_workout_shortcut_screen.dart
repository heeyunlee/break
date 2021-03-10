import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/empty_content.dart';
import 'package:workout_player/format.dart';

import '../../common_widgets/appbar_blur_bg.dart';
import '../../common_widgets/choice_chips_app_bar_widget.dart';
import '../../common_widgets/custom_list_tile_3.dart';
import '../../common_widgets/list_item_builder.dart';
import '../../constants.dart';
import '../../models/routine.dart';
import '../../services/database.dart';
import '../library_tab/routine/routine_detail_screen.dart';

class StartWorkoutShortcutScreen extends StatefulWidget {
  const StartWorkoutShortcutScreen({Key key, this.database}) : super(key: key);

  final Database database;

  static void show(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);

    await HapticFeedback.mediumImpact();
    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => StartWorkoutShortcutScreen(
          database: database,
        ),
      ),
    );
  }

  @override
  _StartWorkoutShortcutScreenState createState() =>
      _StartWorkoutShortcutScreenState();
}

class _StartWorkoutShortcutScreenState
    extends State<StartWorkoutShortcutScreen> {
  String _selectedChip = 'All';
  // Query _query;
  // PaginateRefreshedChangeListener refreshChangeListener =
  //     PaginateRefreshedChangeListener();

  @override
  void initState() {
    super.initState();
    // _query = widget.database.routinesPaginatedPublicQuery();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // set string(String value) => setState(() => _selectedChip = value);

  @override
  Widget build(BuildContext context) {
    debugPrint('StartWorkoutShortcutScreen scaffold building...');

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: BackgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              floating: true,
              pinned: true,
              snap: false,
              centerTitle: true,
              title: const Text('Choose Routine to Start', style: Subtitle1),
              flexibleSpace: const AppbarBlurBG(),
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              bottom: ChoiceChipsAppBarWidget(
                callback: (value) {
                  setState(() {
                    _selectedChip = value;
                    // _query = widget.database.workoutsSearchQuery(
                    //   'mainMuscleGroup',
                    //   _selectedChip,
                    // );
                  });
                },
              ),
            ),
          ];
        },
        body: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    // var query = (_selectedChip == 'All')
    //     ? widget.database.routinesPaginatedPublicQuery()
    //     : widget.database.workoutsSearchQuery(
    //         'mainMuscleGroup',
    //         _selectedChip,
    //       );

    // return RefreshIndicator(
    //   onRefresh: () async {
    //     refreshChangeListener.refreshed = true;
    //   },
    //   child: PaginateFirestore(
    //     shrinkWrap: true,
    //     itemsPerPage: 10,
    //     query: _query,
    //     itemBuilderType: PaginateBuilderType.listView,
    //     emptyDisplay: const EmptyContent(
    //       message: 'Nothing...',
    //     ),
    //     header: const SizedBox(height: 8),
    //     footer: const SizedBox(height: 8),
    //     onError: (error) => EmptyContent(
    //       message: 'Something went wrong: $error',
    //     ),
    //     physics: const BouncingScrollPhysics(),
    //     itemBuilder: (index, context, documentSnapshot) {
    //       final documentId = documentSnapshot.id;
    //       final data = documentSnapshot.data();
    //       final routine = Routine.fromMap(data, documentId);

    //       final trainingLevel = Format.difficulty(routine.trainingLevel);
    //       final weights = Format.weights(routine.totalWeights);
    //       final unit = Format.unitOfMass(routine.initialUnitOfMass);

    //       final duration = Duration(seconds: routine?.duration ?? 0).inMinutes;

    //       return CustomListTile3(
    //         isLeadingDuration: true,
    //         tag: 'startShortcut-${routine.routineId}',
    //         title: routine.routineTitle,
    //         leadingText: '$duration',
    //         subtitle: '$trainingLevel, $weights $unit',
    //         subtitle2: 'by ${routine.routineOwnerUserName}',
    //         imageUrl: routine.imageUrl,
    //         onTap: () => RoutineDetailScreen.show(
    //           context,
    //           routine: routine,
    //           isRootNavigation: false,
    //           tag: 'startShortcut-${routine.routineId}',
    //         ),
    //       );
    //     },
    //     isLive: true,
    //   ),
    // );

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: StreamBuilder<List<Routine>>(
        stream: (_selectedChip == 'All')
            ? widget.database.routinesStream()
            : widget.database.routinesSearchStream(
                searchCategory: 'mainMuscleGroup',
                arrayContains: _selectedChip,
              ),
        builder: (context, snapshot) {
          return ListItemBuilder<Routine>(
            emptyContentTitle: 'No $_selectedChip Routines yet...',
            snapshot: snapshot,
            itemBuilder: (context, routine) {
              final trainingLevel = Format.difficulty(routine.trainingLevel);
              final weights = Format.weights(routine.totalWeights);
              final unit = Format.unitOfMass(routine.initialUnitOfMass);

              final duration =
                  Duration(seconds: routine?.duration ?? 0).inMinutes;

              return CustomListTile3(
                isLeadingDuration: true,
                tag: 'startShortcut-${routine.routineId}',
                title: routine.routineTitle,
                leadingText: '$duration',
                subtitle: '$trainingLevel, $weights $unit',
                subtitle2: 'by ${routine.routineOwnerUserName}',
                imageUrl: routine.imageUrl,
                onTap: () => RoutineDetailScreen.show(
                  context,
                  routine: routine,
                  isRootNavigation: false,
                  tag: 'startShortcut-${routine.routineId}',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
