import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:workout_player/models/auth_and_database.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/widgets/appbar_blur_bg.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/widgets/appbar_close_button.dart';

import 'create_new_routine_model.dart';
import 'new_routine_equipment_required_widget.dart';
import 'new_routine_main_muscle_group_widget.dart';
import 'new_routine_more_settings_widget.dart';
import 'new_routine_title_widget.dart';

class CreateNewRoutineScreen extends StatefulWidget {
  final Database database;
  final AuthBase auth;
  final CreateNewROutineModel model;

  const CreateNewRoutineScreen({
    Key? key,
    required this.database,
    required this.auth,
    required this.model,
  }) : super(key: key);

  static void show(BuildContext context) {
    final database = provider.Provider.of<Database>(context, listen: false);
    final auth = provider.Provider.of<AuthBase>(context, listen: false);

    HapticFeedback.mediumImpact();

    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => Consumer(
          builder: (context, ref, child) => CreateNewRoutineScreen(
            database: database,
            auth: auth,
            model: ref.watch(createNewROutineModelProvider),
          ),
        ),
      ),
    );
  }

  @override
  _CreateNewRoutineScreenState createState() => _CreateNewRoutineScreenState();
}

class _CreateNewRoutineScreenState extends State<CreateNewRoutineScreen> {
  @override
  void initState() {
    super.initState();
    widget.model.init(
      AuthAndDatabase(database: widget.database, auth: widget.auth),
    );
  }

  @override
  void dispose() {
    widget.model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.d('building create new routine scaffold...');

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        brightness: Brightness.dark,
        leading: const AppBarCloseButton(),
        title: Text(_getText(), style: TextStyles.subtitle2),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: const AppbarBlurBG(),
      ),
      body: _buildBody(),
      floatingActionButton: _buildFAB(),
    );
  }

  String _getText() {
    switch (widget.model.pageIndex) {
      case 0:
        return S.current.routineTitleTitle;
      case 1:
        return S.current.mainMuscleGroup;
      case 2:
        return S.current.equipmentRequired;
      case 3:
        return S.current.others;
      default:
        return '';
    }
  }

  Widget _buildBody() {
    switch (widget.model.pageIndex) {
      case 0:
        return NewRoutineTitleWidget(model: widget.model);
      case 1:
        return NewRoutineMainMuscleGroupWidget(model: widget.model);
      case 2:
        return NewRoutineEquipmentRequiredWidget(model: widget.model);
      case 3:
        return NewRoutineMoreSettingsWidget(model: widget.model);
      default:
        return Container();
    }
  }

  Widget _buildFAB() {
    if (widget.model.pageIndex == 3) {
      return FloatingActionButton.extended(
        icon: const Icon(Icons.done, color: Colors.white),
        backgroundColor: kPrimaryColor,
        label: Text(S.current.finish, style: TextStyles.button1),
        onPressed: (widget.model.isButtonPressed)
            ? null
            : () => widget.model.submit(context),
      );
    } else {
      return FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: () => widget.model.submit(context),
        child: const Icon(
          Icons.arrow_forward_rounded,
          color: Colors.white,
        ),
      );
    }
  }
}
