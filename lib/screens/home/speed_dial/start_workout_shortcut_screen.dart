import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart' as provider;
import 'package:workout_player/classes/routine.dart';
import 'package:workout_player/screens/home/library_tab/routine/routine_detail_screen.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/classes/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/widgets/appbar_blur_bg.dart';
import 'package:workout_player/widgets/appbar_close_button.dart';
import 'package:workout_player/widgets/choice_chips_app_bar_widget.dart';
import 'package:workout_player/widgets/custom_list_tile_3.dart';
import 'package:workout_player/widgets/list_item_builder.dart';

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
              title: Text(
                S.current.chooseRoutineToStart,
                style: TextStyles.subtitle1,
              ),
              flexibleSpace: const AppbarBlurBG(),
              backgroundColor: Colors.transparent,
              leading: const AppBarCloseButton(),
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
              ),
        builder: (context, snapshot) {
          return ListItemBuilder<Routine>(
            items: snapshot.data!,
            emptyContentTitle: S.current.emptyroutinesContentTitle(
              _selectedChip,
            ),
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
                onTap: () => RoutineDetailScreen.show(
                  context,
                  routine: routine,
                  tag: 'startWorkoutShortcut${routine.routineId}',
                  isPushReplacement: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
