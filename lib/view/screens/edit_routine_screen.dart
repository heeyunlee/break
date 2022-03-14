import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/combined/routine_detail_screen_class.dart';
import 'package:workout_player/models/enum/difficulty.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/styles/button_styles.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/edit_routine_screen_model.dart';

import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';

import 'edit_routine_equipment_required_screen.dart';
import 'edit_routine_location_screen.dart';
import 'edit_routine_main_muscle_group_screen.dart';
import 'edit_unit_of_mass_screen.dart';

class EditRoutineScreen extends StatefulWidget {
  const EditRoutineScreen({
    Key? key,
    required this.data,
    required this.model,
    required this.theme,
  }) : super(key: key);

  final RoutineDetailScreenClass data;
  final EditRoutineScreenModel model;
  final ThemeData theme;

  static void show(
    BuildContext context, {
    required RoutineDetailScreenClass data,
  }) {
    custmFadeTransition(
      context,
      isRoot: false,
      screenBuilder: (animation) => Consumer(
        builder: (context, ref, child) => EditRoutineScreen(
          data: data,
          model: ref.watch(editRoutineScreenModelProvider),
          theme: Theme.of(context),
        ),
      ),
    );
  }

  @override
  _EditRoutineScreenState createState() => _EditRoutineScreenState();
}

class _EditRoutineScreenState extends State<EditRoutineScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.model.init(this, widget.data.routine!, widget.theme);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return NotificationListener(
      onNotification: widget.model.onNotification,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: Form(
          key: EditRoutineScreenModel.formKey,
          child: CustomScrollView(
            slivers: [
              AnimatedBuilder(
                animation: widget.model.sliverAnimationController,
                builder: (context, child) => SliverAppBar(
                  pinned: true,
                  stretch: true,
                  elevation: 0,
                  backgroundColor: widget.model.colorTweeen.value,
                  expandedHeight: size.height / 5,
                  leading: const AppBarCloseButton(),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ElevatedButton(
                        style: ButtonStyles.elevated2(context),
                        onPressed: () => widget.model.submit(
                          context,
                          widget.data.routine!,
                        ),
                        child: Text(
                          S.current.save,
                          style: TextStyles.button1,
                        ),
                      ),
                    ),
                  ],
                  title: Transform.translate(
                    offset: widget.model.offsetTween.value,
                    child: Opacity(
                      opacity: widget.model.opacityTween.value,
                      child: child,
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.passthrough,
                      children: [
                        CachedNetworkImage(
                          imageUrl: widget.data.routine!.imageUrl,
                          errorWidget: (_, __, ___) => const Icon(Icons.error),
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: const Alignment(0, -0.50),
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                theme.backgroundColor,
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          bottom: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 58,
                                width: size.width - 32,
                                child: UnderlinedTextTextFieldWidget(
                                  textAlign: TextAlign.start,
                                  autoFocus: false,
                                  focusNode: widget.model.titleFocusNode,
                                  controller:
                                      widget.model.titleEditingController,
                                  formKey: EditRoutineScreenModel.formKey,
                                  maxLength: 45,
                                  counterStyle: TextStyles.overlineGrey,
                                  counterAsSuffix: true,
                                  hintStyle: TextStyles.blackHans1Grey,
                                  hintText: S.current.routineTitleHintText,
                                  inputStyle: TextStyles.blackHans1,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                child: Text(
                  S.current.editRoutineTitle,
                  style: TextStyles.subtitle2,
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        height: 40,
                        width: size.width - 32,
                        child: UnderlinedTextTextFieldWidget(
                          focusNode: widget.model.descriptionFocusNode,
                          controller: widget.model.descriptionEditingController,
                          formKey: EditRoutineScreenModel.formKey,
                          textAlign: TextAlign.start,
                          autoFocus: false,
                          maxLength: 120,
                          counterStyle: TextStyles.overlineGrey,
                          counterAsSuffix: true,
                          hintStyle: TextStyles.body2Grey,
                          hintText: S.current.addDescription,
                          inputStyle: TextStyles.body2,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        title: Text(
                          S.current.mainMuscleGroup,
                          style: TextStyles.caption1Grey,
                        ),
                        subtitle: Text(
                          Formatter.getJoinedMainMuscleGroups(
                            widget.data.routine!.mainMuscleGroup,
                            widget.data.routine!.mainMuscleGroupEnum,
                          ),
                          style: TextStyles.body2Bold,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                        ),
                        onTap: () => EditRoutineMainMuscleGroupScreen.show(
                          context,
                          routine: widget.data.routine!,
                          user: widget.data.user!,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        title: Text(
                          S.current.equipmentRequired,
                          style: TextStyles.caption1Grey,
                        ),
                        subtitle: Text(
                          Formatter.getJoinedEquipmentsRequired(
                            widget.data.routine!.equipmentRequired,
                            widget.data.routine!.equipmentRequiredEnum,
                          ),
                          style: TextStyles.body2Bold,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                        ),
                        onTap: () => EditRoutineEquipmentRequiredScreen.show(
                          context,
                          routine: widget.data.routine!,
                          user: widget.data.user!,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        title: Text(
                          S.current.unitOfMass,
                          style: TextStyles.caption1Grey,
                        ),
                        subtitle: Text(
                          Formatter.unitOfMass(
                            widget.data.routine!.initialUnitOfMass,
                            widget.data.routine!.unitOfMassEnum,
                          ),
                          style: TextStyles.body2Bold,
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                        ),
                        onTap: () => EditUnitOfMassScreen.show(
                          context,
                          routine: widget.data.routine!,
                          user: widget.data.user!,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        title: Text(
                          S.current.location,
                          style: TextStyles.caption1Grey,
                        ),
                        subtitle: Text(
                          Formatter.location(widget.data.routine!.location),
                          style: TextStyles.body2Bold,
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.white,
                        ),
                        onTap: () => EditRoutineLocationScreen.show(
                          context,
                          routine: widget.data.routine!,
                          user: widget.data.user!,
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.transparent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              '${S.current.trainingLevel}: ${Difficulty.values[widget.model.difficulty.toInt()].translation!}',
                              style: TextStyles.body1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Slider(
                            activeColor: theme.primaryColor,
                            inactiveColor: theme.primaryColor.withOpacity(0.2),
                            value: widget.model.difficulty,
                            onChanged: widget.model.difficultyOnChanged,
                            max: 2,
                            divisions: 2,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        title: Text(
                          S.current.publicRoutine,
                          style: TextStyles.body1W800,
                        ),
                        trailing: Switch(
                          value: widget.model.isRoutinePublic,
                          activeColor: theme.primaryColor,
                          onChanged: widget.model.isPublicOnChanged,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        S.current.publicRoutineDescription,
                        style: TextStyles.caption1Grey,
                      ),
                    ),
                    const SizedBox(height: kBottomNavigationBarHeight + 80),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
