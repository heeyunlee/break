import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/equipment_required.dart';
import 'package:workout_player/models/enum/location.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view_models/main_model.dart';

import 'routine_detail_screen.dart';
import 'workout_detail_screen.dart';

/// Screen that shows the list of [Workout] and [Routine] of the search category
///
/// /// ## Roadmap
///
/// ### Refactoring
/// * TODO: Paginate list of [Workout] and [Routine] stream
///
/// ### Enhancement
///
class SearchCategoryScreen extends StatelessWidget {
  const SearchCategoryScreen({
    Key? key,
    this.isEqualTo,
    this.arrayContains,
    required this.searchCategory,
  }) : super(key: key);

  final String? isEqualTo;
  final String? arrayContains;
  final String searchCategory;

  static void show(
    BuildContext context, {
    String? isEqualTo,
    String? arrayContains,
    required String searchCategory,
  }) {
    customPush(
      context,
      rootNavigator: false,
      builder: (context, auth, database) => SearchCategoryScreen(
        isEqualTo: isEqualTo,
        arrayContains: arrayContains,
        searchCategory: searchCategory,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    logger.d('[SearchCategoryScreen] building...');

    final theme = Theme.of(context);

    final title = (searchCategory == 'mainMuscleGroup')
        ? MainMuscleGroup.values
            .firstWhere((e) => e.toString() == arrayContains)
            .translation
        : (searchCategory == 'equipmentRequired')
            ? EquipmentRequired.values
                .firstWhere((e) => e.toString() == arrayContains)
                .translation
            : Location.values
                .firstWhere((e) => e.toString() == isEqualTo)
                .translation;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                floating: true,
                pinned: true,
                centerTitle: true,
                leading: const AppBarBackButton(),
                title: Text(title!, style: TextStyles.subtitle1),
                bottom: TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: theme.primaryColor,
                  tabs: [
                    Tab(text: S.current.workouts),
                    Tab(text: S.current.routines),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: <Widget>[
              _buildWorkoutsBody(context),
              _buildRoutinesBody(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutsBody(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    final stream = (isEqualTo != null)
        ? database.workoutsSearchStream(
            isEqualTo: true,
            isEqualToVariableName: searchCategory,
            isEqualToVariableValue: isEqualTo,
          )
        : database.workoutsSearchStream(
            isEqualTo: false,
            arrayContainsVariableName: searchCategory,
            arrayContainsValue: arrayContains,
          );

    return CustomStreamBuilder<List<Workout>>(
      stream: stream,
      emptyWidget: EmptyContent(
        message: S.current.emptyContentTitle,
      ),
      errorWidget: EmptyContent(
        message: S.current.somethingWentWrong,
      ),
      builder: (context, data) {
        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              CustomListViewBuilder<Workout>(
                items: data,
                itemBuilder: (context, workout, i) {
                  final leadingText = EquipmentRequired.values
                      .firstWhere(
                          (e) => e.toString() == workout.equipmentRequired[0])
                      .translation;

                  final locale = Intl.getCurrentLocale();

                  final title = (locale == 'ko' || locale == 'en')
                      ? workout.translated[locale].toString()
                      : workout.workoutTitle;

                  return CustomListTile3(
                    imageUrl: workout.imageUrl,
                    // isLeadingDuration: false,
                    title: title,
                    leadingText: leadingText!,
                    subtitle: workout.workoutOwnerUserName,
                    tag: 'MoreScreen-${workout.workoutId}',
                    onTap: () => WorkoutDetailScreen.show(
                      context,
                      workoutId: workout.workoutId,
                      workout: workout,
                      tag: 'MoreScreen-${workout.workoutId}',
                    ),
                  );
                },
              ),
              const SizedBox(height: kBottomNavigationBarHeight + 48),
            ],
          ),
        );
      },
    );

    // return PaginateFirestore(
    //   shrinkWrap: true,
    //   itemsPerPage: 10,
    //   query: query,
    //   itemBuilderType: PaginateBuilderType.listView,
    //   emptyDisplay: EmptyContent(
    //     message: S.current.emptyContentTitle,
    //   ),
    //   header: const SliverToBoxAdapter(child: SizedBox(height: 16)),
    //   footer: const SliverToBoxAdapter(child: SizedBox(height: 120)),
    //   onError: (error) => EmptyContent(
    //     message: '${S.current.somethingWentWrong}: $error',
    //   ),
    //   physics: const BouncingScrollPhysics(),
    //   itemBuilder: (index, context, documentSnapshot) {
    //     final workout = documentSnapshot.data() as Workout?;

    //     final leadingText = EquipmentRequired.values
    //         .firstWhere((e) => e.toString() == workout!.equipmentRequired[0])
    //         .translation;

    //     final locale = Intl.getCurrentLocale();

    //     final title = (locale == 'ko' || locale == 'en')
    //         ? workout!.translated[locale].toString()
    //         : workout!.workoutTitle;

    //     return CustomListTile3(
    //       imageUrl: workout.imageUrl,
    //       // isLeadingDuration: false,
    //       title: title,
    //       leadingText: leadingText!,
    //       subtitle: workout.workoutOwnerUserName,
    //       tag: 'MoreScreen-${workout.workoutId}',
    //       onTap: () => WorkoutDetailScreen.show(
    //         context,
    //         workoutId: workout.workoutId,
    //         workout: workout,
    //         tag: 'MoreScreen-${workout.workoutId}',
    //       ),
    //     );
    //   },
    //   isLive: true,
    // );
  }

  Widget _buildRoutinesBody(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    final stream = (isEqualTo != null)
        ? database.routinesSearchStream(
            isEqualTo: true,
            isEqualToVariableName: searchCategory,
            isEqualToVariableValue: isEqualTo,
          )
        : database.routinesSearchStream(
            isEqualTo: false,
            arrayContainsVariableName: searchCategory,
            arrayContainsValue: arrayContains,
          );

    // final query = (isEqualTo != null)
    //     ? database
    //         .routinesSearchQuery()
    //         .where(searchCategory, isEqualTo: isEqualTo)
    //     : database
    //         .routinesSearchQuery()
    //         .where(searchCategory, arrayContains: arrayContains);

    return CustomStreamBuilder<List<Routine>>(
      stream: stream,
      emptyWidget: EmptyContent(
        message: S.current.emptyContentTitle,
      ),
      errorWidget: EmptyContent(
        message: S.current.somethingWentWrong,
      ),
      builder: (context, data) {
        return SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 16),
              CustomListViewBuilder<Routine>(
                items: data,
                itemBuilder: (context, routine, i) {
                  final duration =
                      Duration(seconds: routine.duration).inMinutes;

                  return CustomListTile3(
                    isLeadingDuration: true,
                    imageUrl: routine.imageUrl,
                    leadingText: '$duration',
                    title: routine.routineTitle,
                    subtitle: routine.routineOwnerUserName,
                    tag: 'MoreScreen-${routine.routineId}',
                    onTap: () => RoutineDetailScreen.show(
                      context,
                      routine: routine,
                      tag: 'MoreScreen-${routine.routineId}',
                    ),
                  );
                },
              ),
              const SizedBox(height: kBottomNavigationBarHeight + 48),
            ],
          ),
        );
      },
    );

    // return PaginateFirestore(
    //   shrinkWrap: true,
    //   itemsPerPage: 10,
    //   query: query,
    //   itemBuilderType: PaginateBuilderType.listView,
    //   emptyDisplay: EmptyContent(
    //     message: S.current.emptyContentTitle,
    //   ),
    //   header: const SliverToBoxAdapter(child: SizedBox(height: 16)),
    //   footer: const SliverToBoxAdapter(child: SizedBox(height: 120)),
    //   onError: (error) => EmptyContent(
    //     message: '${S.current.somethingWentWrong}: $error',
    //   ),
    //   physics: const BouncingScrollPhysics(),
    //   itemBuilder: (index, context, documentSnapshot) {
    //     final routine = documentSnapshot.data() as Routine?;

    //     final duration = Duration(seconds: routine!.duration).inMinutes;
    //     return CustomListTile3(
    //       isLeadingDuration: true,
    //       imageUrl: routine.imageUrl,
    //       leadingText: '$duration',
    //       title: routine.routineTitle,
    //       subtitle: routine.routineOwnerUserName,
    //       tag: 'MoreScreen-${routine.routineId}',
    //       onTap: () => RoutineDetailScreen.show(
    //         context,
    //         routine: routine,
    //         tag: 'MoreScreen-${routine.routineId}',
    //       ),
    //     );
    //   },
    //   isLive: true,
    // );
  }
}
