import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:workout_player/classes/routine.dart';
import 'package:workout_player/screens/home/library_tab/routine/routine_detail_screen_model.dart';
import 'package:workout_player/screens/home/speed_dial/choose_routine/choose_routine_screen_model.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/classes/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/widgets/app_bar/appbar_blur_bg.dart';
import 'package:workout_player/widgets/appbar_close_button.dart';
import 'package:workout_player/widgets/choice_chips_app_bar_widget.dart';
import 'package:workout_player/widgets/custom_list_tile_3.dart';
import 'package:workout_player/widgets/list_item_builder.dart';

class ChooseRoutineScreen extends ConsumerWidget {
  final Database database;
  final User user;

  const ChooseRoutineScreen({
    Key? key,
    required this.database,
    required this.user,
  }) : super(key: key);

  static Future<void> show(BuildContext context) async {
    final database = provider.Provider.of<Database>(context, listen: false);
    final auth = provider.Provider.of<AuthBase>(context, listen: false);
    final user = (await database.getUserDocument(auth.currentUser!.uid))!;

    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => ChooseRoutineScreen(
          database: database,
          // auth: auth,
          user: user,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final model = watch(chooseRoutineScreenModelProvider);
    logger.d('StartWorkoutShortcutScreen scaffold building...');

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kBackgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) {
          return <Widget>[
            _buildSliverApp(model),
          ];
        },
        body: _buildBody(model),
      ),
    );
  }

  SliverAppBar _buildSliverApp(ChooseRoutineScreenModel model) {
    return SliverAppBar(
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
        onSelected: model.onSelectChoiceChip,
        selectedChip: model.selectedChip,
      ),
    );
  }

  Widget _buildBody(ChooseRoutineScreenModel model) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: StreamBuilder<List<Routine>>(
        stream: model.stream(database),
        builder: (context, snapshot) {
          return ListItemBuilder<Routine>(
            items: snapshot.data!,
            emptyContentTitle: S.current.emptyroutinesContentTitle(
              model.selectedChipTranslation,
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
                onTap: () => RoutineDetailScreenModel.show(
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
