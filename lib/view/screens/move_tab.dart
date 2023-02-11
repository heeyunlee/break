import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_player/models/combined/progress_tab_class.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/view/widgets/widgets.dart';

import 'package:workout_player/view_models/miniplayer_model.dart';

import '../../view_models/progress_tab_model.dart';

class MoveTab extends StatefulWidget {
  final ProgressTabModel model;
  final MiniplayerModel miniplayerModel;
  final Database database;

  const MoveTab({
    Key? key,
    required this.model,
    required this.miniplayerModel,
    required this.database,
  }) : super(key: key);

  static Widget create() {
    return Consumer(
      builder: (context, ref, child) => MoveTab(
        model: ref.watch(progressTabModelProvider),
        miniplayerModel: ref.watch(miniplayerModelProvider),
        database: ref.watch(databaseProvider),
      ),
    );
  }

  @override
  _MoveTabState createState() => _MoveTabState();
}

class _MoveTabState extends State<MoveTab> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    widget.model.init(vsync: this);
  }

  @override
  void dispose() {
    widget.model.animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomStreamBuilder<User?>(
      stream: widget.database.userStream(),
      loadingWidget: Container(color: theme.colorScheme.background),
      builder: (context, user) => NotificationListener<ScrollNotification>(
        onNotification: widget.model.onNotification,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            // leading: ChooseBackgroundButton(user: user!),
            title: ChooseDateIconButton(model: widget.model, user: user!),
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
    return Stack(
      children: [
        BlurredBackground(
          model: widget.model,
          miniplayerModel: widget.miniplayerModel,
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
          stream: widget.model.database.progressTabStream(
            widget.model.selectedDate,
          ),
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
