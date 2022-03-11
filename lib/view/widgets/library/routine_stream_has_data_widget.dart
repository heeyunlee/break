import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';

import 'package:workout_player/models/combined/combined_models.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/dummy_data.dart';
import 'package:workout_player/view/screens/edit_routine_screen.dart';
import 'package:workout_player/view_models/home_screen_model.dart';
import 'package:workout_player/view_models/routine_detail_screen_model.dart';

import '../widgets.dart';

class RoutineStreamHasDataWidget extends ConsumerStatefulWidget {
  const RoutineStreamHasDataWidget({
    Key? key,
    required this.model,
    required this.data,
    required this.tag,
    required this.theme,
  }) : super(key: key);

  final RoutineDetailScreenModel model;
  final RoutineDetailScreenClass data;
  final String tag;
  final ThemeData theme;

  static create({
    required RoutineDetailScreenClass data,
    required String tag,
  }) {
    return Consumer(
      builder: (context, ref, child) => RoutineStreamHasDataWidget(
        model: ref.watch(routineDetailScreenModelProvider),
        data: data,
        tag: tag,
        theme: Theme.of(context),
      ),
    );
  }

  @override
  _RoutineStreamHasDataWidgetState createState() =>
      _RoutineStreamHasDataWidgetState();
}

class _RoutineStreamHasDataWidgetState
    extends ConsumerState<RoutineStreamHasDataWidget>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.model.init(this, widget.theme);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height / 5;

    return NotificationListener(
      onNotification: widget.model.onNotification,
      child: CustomScrollView(
        slivers: [
          AnimatedBuilder(
            animation: widget.model.sliverAnimationController,
            builder: (context, child) => SliverAppBar(
              pinned: true,
              stretch: true,
              elevation: 0,
              backgroundColor: widget.model.colorTweeen.value,
              expandedHeight: height,
              leading: const AppBarBackButton(),
              title: Transform.translate(
                offset: widget.model.offsetTween.value,
                child: Opacity(
                  opacity: widget.model.opacityTween.value,
                  child: child,
                ),
              ),
              flexibleSpace: RoutineFlexibleSpaceBar(
                imageTag: widget.tag,
                model: widget.model,
                data: widget.data,
              ),
              actions: _sliverActions(),
            ),
            child: Text(
              widget.model.title(widget.data),
              style: TextStyles.subtitle2,
            ),
          ),
          RoutineSliverToBoxAdapter(data: widget.data),
          RoutineStickyHeaderAndBody(
            data: widget.data,
            model: widget.model,
          ),
        ],
      ),
    );
  }

  List<Widget> _sliverActions() {
    final routine = widget.data.routine ?? DummyData.routine;
    final homeContext = HomeScreenModel.homeScreenNavigatorKey.currentContext!;

    final database = ref.watch(databaseProvider);
    final isRoutineSaved =
        widget.data.user!.savedRoutines?.contains(routine.routineId) ?? false;
    final isOwner = database.uid == routine.routineOwnerId;

    return [
      IconButton(
        icon: isRoutineSaved
            ? const Icon(Icons.bookmark_rounded)
            : const Icon(Icons.bookmark_border_rounded),
        onPressed: () => widget.model.saveUnsaveRoutine(
          context,
          isRoutineSaved,
          widget.data,
        ),
      ),
      IconButton(
        onPressed: () => showCustomModalBottomSheet(
          homeContext,
          title: routine.routineTitle,
          firstTileTitle: isOwner ? S.current.edit : null,
          firstTileIcon: isOwner ? Icons.edit_rounded : null,
          firstTileOnTap: () {
            Navigator.of(homeContext).pop();

            EditRoutineScreen.show(
              context,
              data: widget.data,
            );
          },
          secondTileTitle: S.current.deleteLowercase,
          secondTileIcon: Icons.delete_outline_rounded,
          secondTileOnTap: () => widget.model.delete(
            context,
            routine: routine,
          ),
        ),
        icon: const Icon(Icons.more_horiz_rounded),
      ),
      const SizedBox(width: 8),
    ];
  }
}
