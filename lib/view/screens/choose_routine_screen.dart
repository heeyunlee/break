import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/dummy_data.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/view/screens/routine_detail_screen.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/choose_routine_screen_model.dart';
import 'package:workout_player/view_models/home_screen_model.dart';
import 'package:workout_player/view_models/main_model.dart';

class ChooseRoutineScreen extends ConsumerWidget {
  const ChooseRoutineScreen({
    Key? key,
  }) : super(key: key);

  static void show(BuildContext context) {
    customPush(
      context,
      rootNavigator: true,
      builder: (context) => const ChooseRoutineScreen(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(chooseRoutineScreenModelProvider);
    final homeModel = ref.watch(homeScreenModelProvider);
    final database = ref.watch(databaseProvider);
    logger.d('StartWorkoutShortcutScreen scaffold building...');

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: CustomFutureBuilder<User?>(
        future: homeModel.database.getUserDocument(homeModel.database.uid!),
        builder: (context, user) {
          return NestedScrollView(
            headerSliverBuilder: (_, __) {
              return <Widget>[
                _buildSliverApp(model),
              ];
            },
            body: _buildBody(model, homeModel, user!, database),
          );
        },
      ),
    );
  }

  SliverAppBar _buildSliverApp(ChooseRoutineScreenModel model) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      centerTitle: true,
      title: Text(
        S.current.chooseRoutineToStart,
        style: TextStyles.subtitle1,
      ),
      leading: const AppBarCloseButton(),
      bottom: ChoiceChipsAppBarWidget(
        onSelected: model.onSelectChoiceChip,
        selectedChip: model.selectedChip,
      ),
    );
  }

  Widget _buildBody(
    ChooseRoutineScreenModel model,
    HomeScreenModel homeModel,
    User user,
    Database database,
  ) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: (model.stream() == null)
          ? _savedWidget(homeModel, user, database)
          : _streamWidget(model, homeModel),
    );
  }

  StreamBuilder<List<Routine>> _streamWidget(
    ChooseRoutineScreenModel model,
    HomeScreenModel homeScreenModel,
  ) {
    return StreamBuilder<List<Routine>>(
      stream: model.stream(),
      builder: (context, snapshot) {
        return CustomListViewBuilder<Routine>(
          items: snapshot.data ?? [DummyData.routine],
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

                RoutineDetailScreen.show(
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

  Widget _savedWidget(
    HomeScreenModel homeScreenModel,
    User user,
    Database database,
  ) {
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

                      RoutineDetailScreen.show(
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
