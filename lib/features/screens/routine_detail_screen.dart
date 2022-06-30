import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_player/models/combined/combined_models.dart';
import 'package:workout_player/models/models.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/features/widgets/widgets.dart';

class RoutineDetailScreen extends ConsumerWidget {
  const RoutineDetailScreen({
    Key? key,
    required this.routine,
    required this.tag,
  }) : super(key: key);

  final Routine routine;
  final String tag;

  // For Navigation
  static void show(
    BuildContext context, {
    required Routine routine,
    required String tag,
  }) {
    customPush(
      context,
      rootNavigator: false,
      builder: (context) => RoutineDetailScreen(
        routine: routine,
        tag: tag,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      body: CustomStreamBuilder<RoutineDetailScreenClass>(
        stream: ref.read(databaseProvider).routineDetailScreenStream(
              routine.routineId,
            ),
        // loadingWidget: const RoutineDetailScreenShimmer(),
        builder: (context, data) => RoutineStreamHasDataWidget.create(
          data: data,
          tag: tag,
        ),
      ),
    );
  }
}
