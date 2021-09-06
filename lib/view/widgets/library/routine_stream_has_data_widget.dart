import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_player/models/combined/combined_models.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view/screens/library/edit_routine_screen.dart';
import 'package:workout_player/view_models/routine_detail_screen_model.dart';

import '../widgets.dart';

class RoutineStreamHasDataWidget extends StatefulWidget {
  const RoutineStreamHasDataWidget({
    Key? key,
    required this.model,
    required this.data,
    required this.tag,
    required this.authAndDatabase,
  }) : super(key: key);

  final RoutineDetailScreenModel model;
  final RoutineDetailScreenClass data;
  final String tag;
  final AuthAndDatabase authAndDatabase;

  static create({
    required RoutineDetailScreenClass data,
    required String tag,
    required AuthAndDatabase authAndDatabase,
  }) {
    return Consumer(
      builder: (context, watch, child) => RoutineStreamHasDataWidget(
        model: watch(routineDetailScreenModelProvider),
        data: data,
        tag: tag,
        authAndDatabase: authAndDatabase,
      ),
    );
  }

  @override
  _RoutineStreamHasDataWidgetState createState() =>
      _RoutineStreamHasDataWidgetState();
}

class _RoutineStreamHasDataWidgetState extends State<RoutineStreamHasDataWidget>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.model.init(this);
    widget.model.setData(widget.data);
  }

  @override
  void dispose() {
    // widget.model.sliverAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = (size.height > 700) ? size.height / 5 : size.height / 5 + 40;

    return NotificationListener(
      onNotification: widget.model.onNotification,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          AnimatedBuilder(
            animation: widget.model.sliverAnimationController,
            builder: (context, child) => SliverAppBar(
              pinned: true,
              stretch: true,
              centerTitle: true,
              elevation: 0,
              brightness: Brightness.dark,
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
              ),
              actions: _sliverActions(),
            ),
            child: Text(widget.model.title(), style: TextStyles.subtitle2),
          ),
          const RoutineSliverToBoxAdapter(),
          RoutineStickyHeaderAndBody(
            authAndDatabase: widget.authAndDatabase,
            data: widget.data,
            model: widget.model,
          ),
        ],
      ),
    );
  }

  List<Widget> _sliverActions() {
    final isRoutineSaved = widget.data.user!.savedRoutines
            ?.contains(widget.data.routine!.routineId) ??
        false;

    return [
      IconButton(
        icon: isRoutineSaved
            ? const Icon(Icons.bookmark_rounded)
            : const Icon(Icons.bookmark_border_rounded),
        onPressed: () => widget.model.saveUnsaveRoutine(
          context,
          isRoutineSaved,
        ),
      ),
      if (widget.authAndDatabase.auth.currentUser!.uid ==
          widget.data.routine!.routineOwnerId)
        IconButton(
          icon: const Icon(Icons.edit_rounded, color: Colors.white),
          onPressed: () => EditRoutineScreen.show(
            context,
            routine: widget.data.routine!,
            auth: widget.authAndDatabase.auth,
            database: widget.authAndDatabase.database,
          ),
        ),
      const SizedBox(width: 8),
    ];
  }
}
