import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/widgets/appbar_blur_bg.dart';
import 'package:workout_player/widgets/custom_list_tile_3.dart';
import 'package:workout_player/widgets/empty_content.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/equipment_required.dart';
import 'package:workout_player/models/enum/location.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/screens/library_tab/routine/routine_detail_screen.dart';
import 'package:workout_player/screens/library_tab/workout/workout_detail_screen.dart';
import 'package:workout_player/services/database.dart';

import '../../../constants.dart';

class SearchCategoryScreen extends StatelessWidget {
  const SearchCategoryScreen({
    this.isEqualTo,
    this.arrayContains,
    required this.searchCategory,
  });

  final String? isEqualTo;
  final String? arrayContains;
  final String searchCategory;

  static void show(
    BuildContext context, {
    String? isEqualTo,
    String? arrayContains,
    required String searchCategory,
  }) async {
    await HapticFeedback.mediumImpact();
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => SearchCategoryScreen(
          isEqualTo: isEqualTo,
          arrayContains: arrayContains,
          searchCategory: searchCategory,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_rounded, color: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(title!, style: kSubtitle1),
                flexibleSpace: const AppbarBlurBG(),
                backgroundColor: Colors.transparent,
                bottom: TabBar(
                  labelColor: Colors.white,
                  unselectedLabelColor: kGrey400,
                  indicatorColor: kPrimaryColor,
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
    final query = (isEqualTo != null)
        ? database
            .workoutsSearchQuery()
            .where(searchCategory, isEqualTo: isEqualTo)
        : database
            .workoutsSearchQuery()
            .where(searchCategory, arrayContains: arrayContains);

    return PaginateFirestore(
      shrinkWrap: true,
      itemsPerPage: 10,
      query: query,
      itemBuilderType: PaginateBuilderType.listView,
      emptyDisplay: EmptyContent(
        message: S.current.emptyContentTitle,
      ),
      header: const SizedBox(height: 8),
      footer: const SizedBox(height: 8),
      onError: (error) => EmptyContent(
        message: '${S.current.somethingWentWrong}: $error',
      ),
      physics: const BouncingScrollPhysics(),
      itemBuilder: (index, context, documentSnapshot) {
        final snapshot = documentSnapshot as DocumentSnapshot<Workout?>;
        // final documentId = snapshot.id;
        final workout = snapshot.data()!;
        // final workout = Workout.fromJson(data!, documentId);
        final leadingText = EquipmentRequired.values
            .firstWhere((e) => e.toString() == workout.equipmentRequired[0])
            .translation;

        final locale = Intl.getCurrentLocale();

        final title = (locale == 'ko' || locale == 'en')
            ? workout.translated[locale]
            : workout.workoutTitle;

        return CustomListTile3(
          imageUrl: workout.imageUrl,
          isLeadingDuration: false,
          title: title,
          leadingText: leadingText!,
          subtitle: workout.workoutOwnerUserName,
          tag: 'MoreScreen-${workout.workoutId}',
          onTap: () => WorkoutDetailScreen.show(
            context,
            workoutId: workout.workoutId,
            isRootNavigation: false,
            tag: 'MoreScreen-${workout.workoutId}',
          ),
        );
      },
      isLive: true,
    );
  }

  Widget _buildRoutinesBody(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    final query = (isEqualTo != null)
        ? database
            .routinesSearchQuery()
            .where(searchCategory, isEqualTo: isEqualTo)
        : database
            .routinesSearchQuery()
            .where(searchCategory, arrayContains: arrayContains);

    return PaginateFirestore(
      shrinkWrap: true,
      itemsPerPage: 10,
      query: query,
      itemBuilderType: PaginateBuilderType.listView,
      emptyDisplay: EmptyContent(
        message: S.current.emptyContentTitle,
      ),
      header: const SizedBox(height: 8),
      footer: const SizedBox(height: 8),
      onError: (error) => EmptyContent(
        message: '${S.current.somethingWentWrong}: $error',
      ),
      physics: const BouncingScrollPhysics(),
      itemBuilder: (index, context, documentSnapshot) {
        // final snapshot = documentSnapshot as DocumentSnapshot<Routine?>;
        // final routine = snapshot.data()!;
        final routine = documentSnapshot.data() as Routine;

        // final documentId = documentSnapshot.id;
        // final data = documentSnapshot.data();
        // final routine = Routine.fromJson(data!, documentId);

        final duration = Duration(seconds: routine.duration).inMinutes;
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
      isLive: true,
    );
  }
}
