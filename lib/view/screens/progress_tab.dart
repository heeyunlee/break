import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/utils/dummy_data.dart';
import 'package:workout_player/view/widgets/builders/custom_stream_builder_widget.dart';
import 'package:workout_player/view/widgets/progress/progress_tab_widgets_builder.dart';
import 'package:provider/provider.dart' as provider;

import 'package:workout_player/view_models/main_model.dart';
import 'package:workout_player/models/combined/progress_tab_class.dart';
import 'package:workout_player/view/widgets/progress/blurred_background.dart';
import 'package:workout_player/view/widgets/progress/choose_date_icon_button.dart';

import '../../styles/constants.dart';
import '../widgets/progress/customize_widgets_button.dart';
import '../../view_models/progress_tab_model.dart';
import '../widgets/progress/choose_background_button.dart';

class ProgressTab extends StatefulWidget {
  final ProgressTabModel model;

  const ProgressTab({
    Key? key,
    required this.model,
  }) : super(key: key);

  static Widget create() {
    return Consumer(
      builder: (context, watch, child) => ProgressTab(
        model: watch(progressTabModelProvider),
      ),
    );
  }

  @override
  _ProgressTabState createState() => _ProgressTabState();
}

class _ProgressTabState extends State<ProgressTab>
    with TickerProviderStateMixin {
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
    final database = provider.Provider.of<Database>(context, listen: false);

    logger.d('[ProgressTab] building...');

    return CustomStreamBuilderWidget<User?>(
      initialData: userDummyData,
      stream: database.userStream(),
      loadingWidget: Container(
        color: kBackgroundColor,
        child: Center(
          child: kPrimaryColorCircularProgressIndicator,
        ),
      ),
      hasDataWidget: (context, user) {
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
              leading: ChooseBackgroundButton(user: user!),
              title: ChooseDateIconButton(model: widget.model, user: user),
              actions: [
                CustomizeWidgetsButton(user: user),
                const SizedBox(width: 8),
              ],
            ),
            body: Builder(
              builder: (context) => _buildBody(context, user),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, User user) {
    return Stack(
      children: [
        BlurredBackground(
          model: widget.model,
          imageIndex: user.backgroundImageIndex,
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
        CustomStreamBuilderWidget<ProgressTabClass>(
          stream: widget.model.database!.progressTabStream(
            widget.model.selectedDate,
          ),
          hasDataWidget: (context, data) => SafeArea(
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
