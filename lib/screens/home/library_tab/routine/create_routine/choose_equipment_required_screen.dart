import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/classes/enum/equipment_required.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/screens/home/library_tab/routine/create_routine/create_new_routine_model.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/widgets/app_bar/appbar_blur_bg.dart';
import 'package:workout_player/widgets/appbar_back_button.dart';
import 'package:workout_player/widgets/check_box_list_view.dart';
import 'package:provider/provider.dart' as provider;

class ChooseEquipmentRequiredScreen extends ConsumerWidget {
  const ChooseEquipmentRequiredScreen({Key? key}) : super(key: key);

  static void showEquipmentRequired(
    BuildContext context, {
    required CreateNewRoutineModel model,
  }) {
    HapticFeedback.mediumImpact();

    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 600),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
        pageBuilder: (context, animation, secondAnimation) {
          return provider.ListenableProvider(
            create: (cintext) => animation,
            child: ChooseEquipmentRequiredScreen(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final model = watch(createNewROutineModelProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        flexibleSpace: const AppbarBlurBG(),
        leading: const AppBarBackButton(),
        title: Text(S.current.equipmentRequired, style: TextStyles.subtitle2),
      ),
      body: Builder(
        builder: (context) => _buildBody(context, model),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: () => model.saveEquipmentRequired(context, model),
        child: const Icon(Icons.arrow_forward_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildBody(BuildContext context, CreateNewRoutineModel model) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: Scaffold.of(context).appBarMaxHeight!),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              S.current.chooseEquipmentRequiredMessage,
              style: TextStyles.body1,
            ),
          ),
          CheckboxListView(
            checked: model.selectedEquipmentRequiredEnum.contains,
            items: EquipmentRequired.values,
            onChangedMainMuscleEnum: (checked, equipment) =>
                model.onChangedEquipment(checked, equipment),
            getTitle: (muscle) => (muscle as EquipmentRequired).translation!,
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
