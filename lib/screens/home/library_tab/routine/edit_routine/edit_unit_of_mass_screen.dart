import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:workout_player/classes/enum/unit_of_mass.dart';
import 'package:workout_player/screens/home/library_tab/routine/edit_routine/edit_unit_of_mass_screen_model.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/widgets/appbar_back_button.dart';
import 'package:workout_player/widgets/app_bar/appbar_blur_bg.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/classes/routine.dart';
import 'package:workout_player/classes/user.dart';
import 'package:workout_player/services/database.dart';

class EditUnitOfMassScreen extends StatefulWidget {
  const EditUnitOfMassScreen({
    Key? key,
    required this.routine,
    required this.database,
    required this.user,
    required this.model,
  }) : super(key: key);

  final Routine routine;
  final Database database;
  final User user;
  final EditUnitOfMassModel model;

  static Future<void> show(
    BuildContext context, {
    required User user,
    required Routine routine,
  }) async {
    final database = provider.Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => Consumer(
          builder: (context, watch, child) => EditUnitOfMassScreen(
            database: database,
            user: user,
            routine: routine,
            model: watch(editUnitOfMassModelProvider),
          ),
        ),
      ),
    );
  }

  @override
  _EditUnitOfMassScreenState createState() => _EditUnitOfMassScreenState();
}

class _EditUnitOfMassScreenState extends State<EditUnitOfMassScreen> {
  @override
  void initState() {
    super.initState();
    widget.model.init(widget.routine);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        title: Text(S.current.unitOfMass, style: TextStyles.subtitle1),
        leading: const AppBarBackButton(),
        flexibleSpace: const AppbarBlurBG(),
      ),
      body: Builder(builder: _buildBody),
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(
        top: Scaffold.of(context).appBarMaxHeight! + 16,
        bottom: 8,
      ),
      itemCount: UnitOfMass.values.length,
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final unit = UnitOfMass.values[index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              color:
                  widget.model.selected(unit) ? kPrimaryColor : kCardColorLight,
              child: CheckboxListTile(
                activeColor: kPrimary700Color,
                title: Text(
                  EnumToString.convertToString(unit),
                  style: TextStyles.button1,
                ),
                controlAffinity: ListTileControlAffinity.trailing,
                value: widget.model.selected(unit),
                selected: widget.model.selected(unit),
                onChanged: (bool? checked) => widget.model.onChanged(
                  context,
                  checked,
                  unit,
                  widget.routine,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
