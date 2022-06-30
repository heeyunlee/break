import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_player/models/combined/progress_tab_class.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/features/widgets/widgets.dart';
import 'package:workout_player/providers.dart';

class MoveTab extends ConsumerStatefulWidget {
  const MoveTab({super.key});

  // static Widget create() {
  //   return Consumer(
  //     builder: (context, ref, child) => MoveTab(
  //       model: ref.watch(progressTabModelProvider),
  //       miniplayerModel: ref.watch(miniplayerModelProvider),
  //       database: ref.watch(databaseProvider),
  //     ),
  //   );
  // }

  @override
  ConsumerState<MoveTab> createState() => _MoveTabState();
}

class _MoveTabState extends ConsumerState<MoveTab>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    ref.read(progressTabModelProvider).init(vsync: this);

    // widget.model.init(vsync: this);
  }

  @override
  void dispose() {
    ref.read(progressTabModelProvider).animationController.dispose();

    // widget.model.animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final database = ref.watch(databaseProvider);
    final model = ref.watch(progressTabModelProvider);

    return CustomStreamBuilder<User?>(
      stream: database.userStream(),
      loadingWidget: Container(color: theme.backgroundColor),
      builder: (context, user) => NotificationListener<ScrollNotification>(
        onNotification: model.onNotification,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            // leading: ChooseBackgroundButton(user: user!),
            title: ChooseDateIconButton(user: user!),
            actions: [
              CustomizeWidgetsButton(user: user),
              const SizedBox(width: 8),
            ],
          ),
          body: Builder(
            builder: (context) => _buildBody(context, user),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, User user) {
    final database = ref.watch(databaseProvider);
    final model = ref.watch(progressTabModelProvider);

    return Stack(
      children: [
        BlurredBackground(
          imageIndex: user.backgroundImageIndex,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: const Alignment(0, -0.75),
              colors: [
                Colors.black.withOpacity(0.5),
                Colors.transparent,
              ],
            ),
          ),
        ),
        CustomStreamBuilder<ProgressTabClass>(
          stream: database.progressTabStream(model.selectedDate),
          loadingWidget: const ProgressTabShimmer(),
          builder: (context, data) => SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return ProgressTabWidgetsBuilder.create(
                  context,
                  data: data,
                  constraints: constraints,
                  vsync: this,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
