import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/models/combined/routine_detail_screen_class.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/dummy_data.dart';
import 'package:workout_player/view/screens/library/edit_routine_screen.dart';
import 'package:workout_player/view_models/routine_detail_screen_model.dart';

import '../widgets.dart';
import 'description_widget.dart';
import 'equipment_required_widget.dart';
import 'location_widget.dart';
import 'log_routine_button.dart';
import 'main_muscle_group_widget.dart';
import 'save_button_widget.dart';
import 'start_routine_button.dart';
import 'subtitle_widget.dart';
import 'title_widget.dart';

class RoutineDetailScreenSliverWidget extends ConsumerWidget {
  final BoxConstraints constraints;
  final RoutineDetailScreenClass data;
  final String tag;

  const RoutineDetailScreenSliverWidget({
    Key? key,
    required this.constraints,
    required this.data,
    required this.tag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final model = watch(routineDetailScreenModelProvider);
    final height = (constraints.maxHeight > 700)
        ? constraints.maxHeight / 2 + 80
        : constraints.maxHeight / 2 + 120;
    final routine = data.routine ?? routineDummyData;

    return AnimatedBuilder(
      animation: model.textAnimationController,
      builder: (context, child) => SliverAppBar(
        floating: false,
        pinned: true,
        snap: false,
        stretch: true,
        centerTitle: true,
        elevation: 0,
        brightness: Brightness.dark,
        backgroundColor: kAppBarColor,
        expandedHeight: height,
        leading: const AppBarBackButton(),
        title: Transform.translate(
          offset: model.offsetTween.value,
          child: Opacity(
            opacity: model.opacityTween.value,
            child: child,
          ),
        ),
        bottom: _buildBottomTabs(),
        flexibleSpace: FlexibleSpaceBar(
          background: Container(
            color: kAppBarColor,
            child: Column(
              children: [
                SizedBox(
                  height: constraints.maxHeight / 4,
                  width: constraints.maxWidth,
                  child: Stack(
                    fit: StackFit.passthrough,
                    children: [
                      Hero(
                        tag: tag,
                        child: CachedNetworkImage(
                          imageUrl: routine.imageUrl,
                          errorWidget: (_, __, ___) => const Icon(Icons.error),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.0, 0.0),
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              kAppBarColor,
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitleWidget(title: routine.routineTitle),
                            Text(
                              routine.routineOwnerUserName,
                              style: TextStyles.subtitle2_bold_grey,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SubtitleWidget(routine: routine),
                      MainMuscleGroupWidget(routine: routine),
                      EquipmentRequiredWidget(routine: routine),
                      LocationWidget(routine: routine),
                      DescriptionWidget(routine: routine),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          LogRoutineButton(
                            data: data,
                            database: model.database!,
                            user: data.user!,
                          ),
                          const Spacer(),
                          StartRoutineButton(data: data),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          SaveButtonWidget(
            user: data.user!,
            database: model.database!,
            auth: model.auth!,
            routine: routine,
          ),
          if (model.auth!.currentUser!.uid == routine.routineOwnerId)
            IconButton(
              icon: const Icon(
                Icons.edit_rounded,
                color: Colors.white,
              ),
              onPressed: () => EditRoutineScreen.show(
                context,
                routine: routine,
                auth: model.auth!,
                database: model.database!,
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
      child: TitleWidget(
        title: routine.routineTitle,
        isAppBarTitle: true,
      ),
    );
  }

  PreferredSize _buildBottomTabs() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(48),
      child: Container(
        color: kAppBarColor,
        child: TabBar(
          indicatorColor: kPrimaryColor,
          tabs: [
            Tab(text: S.current.workoutsUpperCase),
            Tab(text: S.current.history),
          ],
        ),
      ),
    );
  }
}
