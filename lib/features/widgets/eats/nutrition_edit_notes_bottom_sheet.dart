import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view_models/edit_nutrition_entry_screen_model.dart';

import '../widgets.dart';

class NutritionEditNotesBottomSheet extends StatefulWidget {
  const NutritionEditNotesBottomSheet({
    Key? key,
    required this.model,
  }) : super(key: key);

  final EditNutritionModel model;

  @override
  State<NutritionEditNotesBottomSheet> createState() =>
      _NutritionEditNotesBottomSheetState();
}

class _NutritionEditNotesBottomSheetState
    extends State<NutritionEditNotesBottomSheet> {
  @override
  void initState() {
    super.initState();
    widget.model.initNotesEditor();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                Text(S.current.notes, style: TextStyles.body1Bold),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: OutlinedTextTextFieldWidget(
                    autofocus: true,
                    maxLines: 5,
                    focusNode: widget.model.notesFocusNode!,
                    controller: widget.model.notesEditingController!,
                    formKey: EditNutritionModel.formKey,
                    onChanged: widget.model.notesOnChanged,
                    onFieldSubmitted: widget.model.notesOnFieldSubmitted,
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: MaxWidthRaisedButton(
                    radius: 24,
                    // onPressed: () => widget.model.onPressSave(context),
                    onPressed: () async {
                      final status = await widget.model.onPressSave();

                      if (!mounted) return;

                      if (status.statusCode == 200) {
                        Navigator.of(context).pop();
                      } else {
                        await showExceptionAlertDialog(
                          context,
                          title: S.current.operationFailed,
                          exception: status.exception.toString(),
                        );
                      }
                    },
                    color: theme.primaryColor,
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
