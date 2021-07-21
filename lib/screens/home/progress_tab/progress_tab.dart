import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:reorderables/reorderables.dart';

import 'package:workout_player/main_provider.dart';
import 'package:workout_player/classes/auth_and_database.dart';
import 'package:workout_player/classes/progress_tab_class.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/widgets/custom_stream_builder_widget.dart';
import 'package:workout_player/widgets/shimmer/progress_tab_shimmer.dart';

import '../../../styles/constants.dart';
import 'customize_widgets/customize_widgets_button.dart';
import 'progress_tab_model.dart';
import 'widgets/blurred_background.dart';
import 'choose_background/choose_background_button.dart';
import 'widgets/choose_date_icon_button.dart';
import 'widgets/logo_widget.dart';

class ProgressTab extends StatefulWidget {
  final ProgressTabModel model;
  final AuthAndDatabase authAndDatabase;

  const ProgressTab({
    Key? key,
    required this.model,
    required this.authAndDatabase,
  }) : super(key: key);

  static Widget create(BuildContext context) {
    final auth = provider.Provider.of<AuthBase>(context, listen: false);
    final database = provider.Provider.of<Database>(context, listen: false);

    return Consumer(
      builder: (context, watch, child) => ProgressTab(
        model: watch(progressTabModelProvider),
        authAndDatabase: AuthAndDatabase(auth: auth, database: database),
      ),
    );
  }

  @override
  _ProgressTabState createState() => _ProgressTabState();
}

class _ProgressTabState extends State<ProgressTab>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    widget.model.init(
      vsync: this,
      authAndDatabase: widget.authAndDatabase,
    );

    SchedulerBinding.instance!.addPostFrameCallback((Duration duration) {
      FeatureDiscovery.discoverFeatures(
        context,
        const <String>{
          'choose_background',
          'customize_widgets',
        },
      );
    });
  }

  @override
  void dispose() {
    widget.model.animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.d('Progress Tab Scaffold building...');

    return CustomStreamBuilderWidget<ProgressTabClass>(
      stream: widget.model.database!.progressTabStream(
        widget.model.selectedDate,
      ),
      loadingWidget: ProgressTabShimmer(),
      hasDataWidget: (context, progressTabClass) {
        return NotificationListener<ScrollNotification>(
          onNotification: widget.model.onNotification,
          child: Scaffold(
            backgroundColor: kBackgroundColor,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              centerTitle: true,
              brightness: Brightness.dark,
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: ChooseBackgroundButton(user: progressTabClass.user),
              title: ChooseDateIconButton(model: widget.model),
              actions: [
                CustomizeWidgetsButton(
                  user: progressTabClass.user,
                  authAndDatabase: widget.authAndDatabase,
                ),
                const SizedBox(width: 8),
              ],
            ),
            body: Builder(
              builder: (context) => _buildChildWidget(
                context,
                progressTabClass,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChildWidget(BuildContext context, ProgressTabClass data) {
    return Stack(
      children: [
        BlurredBackground(
          model: widget.model,
          imageIndex: data.user.backgroundImageIndex,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0, -1.00),
              end: Alignment(0, -0.75),
              colors: [
                Colors.black.withOpacity(0.5),
                Colors.transparent,
              ],
            ),
          ),
        ),
        SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              widget.model.initWidgets(
                context,
                data: data,
                constraints: constraints,
              );

              return ReorderableWrap(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                buildDraggableFeedback: widget.model.buildDraggableFeedback,
                onReorder: widget.model.onReorder,
                footer: LogoWidget(
                  gridHeight: constraints.maxHeight / 4,
                  gridWidth: constraints.maxWidth,
                ),
                children: widget.model.widgets,
              );
            },
          ),
        ),

        /// TODO: ADD Banner here
        // Positioned(
        //   left: 16,
        //   top: 104,
        //   child: BlurredMaterialBanner(model: widget.model),
        // ),
      ],
    );
  }
}
