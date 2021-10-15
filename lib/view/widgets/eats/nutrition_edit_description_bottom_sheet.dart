import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/styles/theme_colors.dart';
import 'package:workout_player/view_models/edit_nutrition_entry_screen_model.dart';

import '../widgets.dart';

class NutritionEditDescriptionBottomSheet extends StatefulWidget {
  const NutritionEditDescriptionBottomSheet({
    Key? key,
    required this.model,
  }) : super(key: key);

  final EditNutritionModel model;

  @override
  State<NutritionEditDescriptionBottomSheet> createState() =>
      _NutritionEditDescriptionBottomSheetState();
}

class _NutritionEditDescriptionBottomSheetState
    extends State<NutritionEditDescriptionBottomSheet> {
  @override
  void initState() {
    super.initState();
    widget.model.initDescriptionEditor();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return BlurredCard(
      child: Form(
        key: EditNutritionModel.formKey,
        child: Stack(
          children: [
            Positioned(
              top: 16,
              right: 16,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  S.current.cancel,
                  style: TextStyles.button1Grey,
                ),
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 24),
                Text(S.current.description, style: TextStyles.body1Bold),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: OutlinedTextTextFieldWidget(
                    autofocus: true,
                    maxLines: 1,
                    focusNode: widget.model.descriptionFocusNode!,
                    controller: widget.model.descriptionEditingController!,
                    formKey: EditNutritionModel.formKey,
                    onChanged: widget.model.descriptionOnChanged,
                    onFieldSubmitted: widget.model.descriptionOnFieldSubmitted,
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: MaxWidthRaisedButton(
                    radius: 24,
                    onPressed: () => widget.model.onPressSave(context),
                    color: ThemeColors.primary500,
                    buttonText: S.current.save,
                  ),
                ),
                SizedBox(
                  height: kBottomNavigationBarHeight + bottomInset,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
