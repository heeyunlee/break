import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_player/classes/user.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/widgets/appbar_blur_bg.dart';
import 'package:workout_player/widgets/appbar_close_button.dart';

import 'add_measurements_body_widget.dart';
import 'add_measurements_model.dart';

class AddMeasurementsScreen extends StatelessWidget {
  final User user;
  final Database database;

  const AddMeasurementsScreen({
    Key? key,
    required this.user,
    required this.database,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.d('AddMeasurementsScreen building...');

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        flexibleSpace: const AppbarBlurBG(),
        leading: const AppBarCloseButton(),
        title: Text(S.current.addMeasurement, style: TextStyles.subtitle2),
      ),
      body: AddMeasurementsBodyWidget.create(user: user),
      floatingActionButton: _BuildFabWidget(database: database, user: user),
    );
  }
}

class _BuildFabWidget extends ConsumerWidget {
  final Database database;
  final User user;

  const _BuildFabWidget({
    Key? key,
    required this.database,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final model = watch(addMeasurementsModelProvider);
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width - 32,
      padding: EdgeInsets.only(
        bottom: model.hasFocus() ? 48 : 0,
      ),
      child: FloatingActionButton.extended(
        onPressed: () => model.submit(context, database, user),
        backgroundColor: kPrimaryColor,
        heroTag: 'addMeasurementSubmitButton',
        label: Text(S.current.submit),
      ),
    );
  }
}
