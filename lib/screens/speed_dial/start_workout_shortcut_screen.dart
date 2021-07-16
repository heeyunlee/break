import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:workout_player/screens/home/home_screen_provider.dart';
import 'package:workout_player/screens/home/library_tab/routine/routine_detail_screen.dart';
import 'package:workout_player/screens/home/library_tab/routine/routine_detail_screen_model.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/main_provider.dart';

import '../../widgets/appbar_blur_bg.dart';
import '../../widgets/choice_chips_app_bar_widget.dart';
import '../../widgets/custom_list_tile_3.dart';
import '../../widgets/list_item_builder.dart';
import '../../styles/constants.dart';
import '../../models/routine.dart';
import '../../services/database.dart';

class StartWorkoutShortcutScreen extends StatefulWidget {
  final Database database;
  final AuthBase auth;
  final User user;

  const StartWorkoutShortcutScreen({
    Key? key,
    required this.database,
    required this.auth,
    required this.user,
  }) : super(key: key);

  static Future<void> show(BuildContext context) async {
    final database = provider.Provider.of<Database>(context, listen: false);
    final auth = provider.Provider.of<AuthBase>(context, listen: false);
    // final user = (await database.getUserDocument(auth.currentUser!.uid))!;
    final user = (await database.getUserDocument(auth.currentUser!.uid))!;

    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => StartWorkoutShortcutScreen(
          database: database,
          auth: auth,
          user: user,
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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.d('StartWorkoutShortcutScreen scaffold building...');

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kBackgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              floating: true,
              pinned: true,
              snap: false,
              centerTitle: true,
              brightness: Brightness.dark,
              title: Text(S.current.chooseRoutineToStart, style: kSubtitle1),
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
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: StreamBuilder<List<Routine>>(
        stream: (_selectedChip == 'All')
            ? widget.database.routinesStream()
            : widget.database.routinesSearchStream(
                arrayContainsVariableName: 'mainMuscleGroup',
                arrayContainsValue: _selectedChip,
                // searchCategory: 'mainMuscleGroup',
                // arrayContains: _selectedChip,
              ),
        builder: (context, snapshot) {
          return ListItemBuilder<Routine>(
            items: snapshot.data!,
            emptyContentTitle: S.current.emptyroutinesContentTitle(
              _selectedChip,
            ),
            // snapshot: snapshot,
            itemBuilder: (context, routine, index) {
              final trainingLevel = Formatter.difficulty(routine.trainingLevel);
              final weights = Formatter.weights(routine.totalWeights);
              final unit = Formatter.unitOfMass(routine.initialUnitOfMass);

              final duration = Duration(seconds: routine.duration).inMinutes;

              return CustomListTile3(
                isLeadingDuration: true,
                tag: 'startShortcut-${routine.routineId}',
                title: routine.routineTitle,
                leadingText: '$duration',
                subtitle: '$trainingLevel, $weights $unit',
                kSubtitle2: routine.routineOwnerUserName,
                imageUrl: routine.imageUrl,
                onTap: () {
                  Navigator.of(context).pop();
                  tabNavigatorKeys[currentTab]!.currentState!.push(
                        CupertinoPageRoute(
                          builder: (context) => Consumer(
                            builder: (context, ref, child) =>
                                RoutineDetailScreen(
                              database: widget.database,
                              routine: routine,
                              auth: widget.auth,
                              tag: 'startWorkoutShortcut${routine.routineId}',
                              user: widget.user,
                              model:
                                  ref.watch(routineDetailScreenModelProvider),
                            ),
                          ),
                        ),
                      );
                },
              );
            },
          );
        },
      ),
    );
  }
}
