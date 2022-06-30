import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/nutrition.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/features/widgets/widgets.dart';
import 'package:workout_player/view_models/edit_nutrition_entry_screen_model.dart';
import 'package:workout_player/view_models/nutritions_detail_screen_model.dart';

class NutritionCaloriesListTile extends ConsumerStatefulWidget {
  const NutritionCaloriesListTile({required this.nutrition, super.key});

  final Nutrition nutrition;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NutritionCaloriesListTileState();
}

class _NutritionCaloriesListTileState
    extends ConsumerState<NutritionCaloriesListTile> {
  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(firebaseAuthProvider);
    final isOwner = auth.currentUser?.uid == widget.nutrition.userId;

    return ListTile(
      onTap: isOwner ? () => showModalPopup(context) : null,
      title: Text(S.current.calories, style: TextStyles.body1),
      trailing: Text(
        NutritionsDetailScreenModel.totalCalories(widget.nutrition),
        style: TextStyles.body2Grey,
      ),
    );
  }

  Future<void> showModalPopup(BuildContext context) async {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final theme = Theme.of(context);
            final bottomInset = MediaQuery.of(context).viewInsets.bottom;
            final model = ref.watch(
              editNutritionModelProvider(widget.nutrition),
            );

            model.initCaloriesController();

            return Form(
              key: EditNutritionModel.formKey,
              child: BlurredCard(
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 32),
                        Text(
                          S.current.calories,
                          style: TextStyles.body1Bold,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 32,
                          ),
                          child: OutlinedNumberTextFieldWidget(
                            suffixText: 'Kcal',
                            autoFocus: true,
                            focusNode: model.caloriesFocusNode!,
                            controller: model.caloriesEditingController!,
                            formKey: EditNutritionModel.formKey,
                            onChanged: model.caloriesOnChanged,
                            onFieldSubmitted: model.caloriesOnFieldSubmitted,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: MaxWidthRaisedButton(
                            radius: 24,
                            color: theme.primaryColor,
                            buttonText: S.current.save,
                            onPressed: () async {
                              final status = await model.onPressSave();

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
          },
        );
      },
    );
  }
}
