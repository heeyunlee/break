import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/nutrition.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/edit_nutrition_entry_screen_model.dart';
import 'package:workout_player/view_models/nutritions_detail_screen_model.dart';

class NutritionCaloriesListTile extends ConsumerWidget {
  const NutritionCaloriesListTile({Key? key, required this.nutrition})
      : super(key: key);

  final Nutrition nutrition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(firebaseAuthProvider);
    final isOwner = auth.currentUser?.uid == nutrition.userId;

    return ListTile(
      onTap: isOwner ? () => showModalPopup(context) : null,
      title: Text(S.current.calories, style: TextStyles.body1),
      trailing: Text(
        NutritionsDetailScreenModel.totalCalories(nutrition),
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
            final model = ref.watch(editNutritionModelProvider(nutrition));

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
                            onPressed: () => model.onPressSave(context),
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
