import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/dummy_data.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/choose_routine_screen_model.dart';
import 'package:workout_player/view_models/home_screen_model.dart';
import 'package:workout_player/view_models/main_model.dart';
import 'package:workout_player/view_models/routine_detail_screen_model.dart';

class ChooseRoutineScreen extends ConsumerWidget {
  final Database database;
  final User user;

  const ChooseRoutineScreen({
    Key? key,
    required this.database,
    required this.user,
  }) : super(key: key);

  static Future<void> show(BuildContext context) async {
    final container = ProviderContainer();
    final auth = container.read(authServiceProvider);
    final database = container.read(databaseProvider(auth.currentUser?.uid));
    final user = (await database.getUserDocument(auth.currentUser!.uid))!;

    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => ChooseRoutineScreen(
          database: database,
          user: user,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final model = watch(chooseRoutineScreenModelProvider);
    final homeModel = watch(homeScreenModelProvider);
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
        body: _buildBody(model, homeModel),
      ),
    );
  }

  SliverAppBar _buildSliverApp(ChooseRoutineScreenModel model) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      // snap: false,
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

  Widget _buildBody(ChooseRoutineScreenModel model, HomeScreenModel homeModel) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: (model.stream(database) == null)
          ? _savedWidget(homeModel)
          : _streamWidget(model, homeModel),
    );
  }

  StreamBuilder<List<Routine>> _streamWidget(
    ChooseRoutineScreenModel model,
    HomeScreenModel homeScreenModel,
  ) {
    return StreamBuilder<List<Routine>>(
      stream: model.stream(database),
      builder: (context, snapshot) {
        return CustomListViewBuilder<Routine>(
          items: snapshot.data ?? [routineDummyData],
          emptyContentTitle: S.current.emptyroutinesContentTitle(
            model.selectedChipTranslation,
          ),
          itemBuilder: (context, routine, index) {
            final trainingLevel = Formatter.difficulty(routine.trainingLevel);
            final weights = Formatter.numWithDecimal(routine.totalWeights);
            final unit = Formatter.unitOfMass(
              routine.initialUnitOfMass,
              routine.unitOfMassEnum,
            );

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
                final currentContext = HomeScreenModel
                    .tabNavigatorKeys[homeScreenModel.currentTab]!
                    .currentContext!;

                Navigator.of(context).pop();

                RoutineDetailScreenModel.show(
                  currentContext,
                  routine: routine,
                  tag: 'startWorkoutShortcut${routine.routineId}',
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _savedWidget(HomeScreenModel homeScreenModel) {
    if (user.savedRoutines!.isEmpty) {
      return EmptyContent(
        message: S.current.savedRoutineEmptyText,
      );
    } else {
      return Column(
        children: [
          ...user.savedRoutines!.map<Widget>((id) {
            final Future<Routine?> future = database.getRoutine(id);

            return CustomFutureBuilder<Routine?>(
              future: future,
              builder: (context, routine) {
                if (routine != null) {
                  return LibraryListTile(
                    tag: 'savedRoutiness-${routine.routineId}',
                    title: routine.routineTitle,
                    subtitle: Formatter.getJoinedMainMuscleGroups(
                      routine.mainMuscleGroup,
                      routine.mainMuscleGroupEnum,
                    ),
                    imageUrl: routine.imageUrl,
                    onTap: () {
                      final currentContext = HomeScreenModel
                          .tabNavigatorKeys[homeScreenModel.currentTab]!
                          .currentContext!;

                      Navigator.of(context).pop();

                      RoutineDetailScreenModel.show(
                        currentContext,
                        routine: routine,
                        tag: 'savedRoutiness-${routine.routineId}',
                      );
                    },
                  );
                } else {
                  return Container();
                }
              },
            );
          }).toList(),
        ],
      );
    }
  }
}
