import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:workout_player/classes/user.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/widgets/app_bar/appbar_blur_bg.dart';
import 'package:workout_player/widgets/appbar_back_button.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/classes/enum/equipment_required.dart';
import 'package:workout_player/classes/routine.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import 'edit_routine_equipment_required_model.dart';

class EditRoutineEquipmentRequiredScreen extends StatefulWidget {
  final Routine routine;
  final Database database;
  final User user;
  final EditRoutineEquipmentRequiredModel model;

  const EditRoutineEquipmentRequiredScreen({
    Key? key,
    required this.routine,
    required this.database,
    required this.user,
    required this.model,
  }) : super(key: key);

  static Future<void> show(
    BuildContext context, {
    required Routine routine,
  }) async {
    final database = provider.Provider.of<Database>(context, listen: false);
    final auth = provider.Provider.of<AuthBase>(context, listen: false);
    final User user = (await database.getUserDocument(auth.currentUser!.uid))!;

    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => Consumer(
          builder: (context, watch, child) =>
              EditRoutineEquipmentRequiredScreen(
            database: database,
            routine: routine,
            user: user,
            model: watch(editRoutineEquipmentRequiredModelProvider),
          ),
        ),
      ),
    );
  }

  @override
  _EditRoutineEquipmentRequiredScreenState createState() =>
      _EditRoutineEquipmentRequiredScreenState();
}

class _EditRoutineEquipmentRequiredScreenState
    extends State<EditRoutineEquipmentRequiredScreen> {
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
        centerTitle: true,
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        flexibleSpace: const AppbarBlurBG(),
        leading: AppBarBackButton(
          onPressed: () => widget.model.submitAndPop(
            context,
            database: widget.database,
            routine: widget.routine,
          ),
        ),
        title: Text(S.current.equipmentRequired, style: TextStyles.subtitle1),
      ),
      body: Builder(
        builder: (context) => ListView.builder(
          padding: EdgeInsets.only(
            top: Scaffold.of(context).appBarMaxHeight! + 16,
            bottom: 8,
          ),
          itemCount: EquipmentRequired.values.length,
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final equipment = EquipmentRequired.values[index];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: widget.model.selected(equipment)
                      ? kPrimaryColor
                      : kCardColorLight,
                  child: CheckboxListTile(
                    activeColor: kPrimary700Color,
                    title: Text(
                      equipment.translation!,
                      style: TextStyles.button1,
                    ),
                    controlAffinity: ListTileControlAffinity.trailing,
                    value: widget.model.selected(equipment),
                    selected: widget.model.selected(equipment),
                    onChanged: (bool? checked) =>
                        widget.model.addOrRemove(checked, equipment),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
