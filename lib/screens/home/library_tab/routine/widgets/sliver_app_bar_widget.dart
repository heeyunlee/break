import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/classes/routine_and_routine_workouts.dart';
import 'package:workout_player/classes/user.dart';
import 'package:workout_player/screens/home/library_tab/routine/edit_routine/edit_routine_screen.dart';
import 'package:workout_player/screens/home/library_tab/routine/routine_detail_screen_model.dart';
import 'package:workout_player/styles/constants.dart';

import 'description_widget.dart';
import 'equipment_required_widget.dart';
import 'location_widget.dart';
import 'log_routine_button.dart';
import 'main_muscle_group_widget.dart';
import 'save_button_widget.dart';
import 'start_routine_button.dart';
import 'subtitle_widget.dart';
import 'title_widget.dart';

class SliverAppBarWidget extends StatelessWidget {
  final RoutineDetailScreenModel model;
  final RoutineAndRoutineWorkouts data;
  final User user;
  final String tag;

  const SliverAppBarWidget({
    Key? key,
    required this.model,
    required this.data,
    required this.user,
    required this.tag,
  }) : super(key: key);

  // @override
  // void initState() {
  //   super.initState();
  //   widget.model.init(this);
  //   // SchedulerBinding.instance!.addPostFrameCallback((Duration duration) {
  //   //   FeatureDiscovery.discoverFeatures(
  //   //     context,
  //   //     const <String>{
  //   //       'reorder_routine_workouts',
  //   //     },
  //   //   );
  //   // });
  // }

  // @override
  // void dispose() {
  //   widget.model.textAnimationController.dispose();
  //   widget.model.scrollController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: model.textAnimationController,
      builder: (context, child) {
        return SliverAppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          brightness: Brightness.dark,
          title: Transform.translate(
            offset: model.transTween.value,
            child: Opacity(
              opacity: model.opacityTween.value,
              child: child,
            ),
          ),
          backgroundColor: kAppBarColor,
          floating: false,
          pinned: true,
          snap: false,
          stretch: true,
          elevation: 0,
          expandedHeight: size.height / 2 + 64,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(48),
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
          ),
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            background: Container(
              color: kAppBarColor,
              child: Column(
                children: [
                  SizedBox(
                    height: size.height / 4,
                    width: size.width,
                    child: Stack(
                      alignment: Alignment.center,
                      fit: StackFit.passthrough,
                      children: [
                        Hero(
                          tag: tag,
                          child: CachedNetworkImage(
                            imageUrl: data.routine!.imageUrl,
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
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
                        Positioned(
                          bottom: 16,
                          left: 16,
                          child: TitleWidget(
                            title: data.routine!.routineTitle,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 16,
                          child: Text(
                            data.routine!.routineOwnerUserName,
                            style: kSubtitle2BoldGrey,
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
                        SubtitleWidget(routine: data.routine!),
                        MainMuscleGroupWidget(routine: data.routine!),
                        EquipmentRequiredWidget(routine: data.routine!),
                        LocationWidget(routine: data.routine!),
                        DescriptionWidget(
                          description: data.routine!.description,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            LogRoutineButton(
                              data: data,
                              database: model.database!,
                              user: user,
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
            if (model.auth!.currentUser!.uid != data.routine!.routineOwnerId)
              SaveButtonWidget(
                user: user,
                database: model.database!,
                auth: model.auth!,
                routine: data.routine!,
              ),
            if (model.auth!.currentUser!.uid == data.routine!.routineOwnerId)
              IconButton(
                icon: const Icon(
                  Icons.edit_rounded,
                  color: Colors.white,
                ),
                onPressed: () => EditRoutineScreen.show(
                  context,
                  routine: data.routine!,
                ),
              ),
            const SizedBox(width: 8),
          ],
        );
      },
      child: TitleWidget(
        title: data.routine!.routineTitle,
        isAppBarTitle: true,
      ),
    );
  }
}
