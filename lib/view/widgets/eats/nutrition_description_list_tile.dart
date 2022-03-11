import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/nutrition.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view/widgets/eats.dart';
import 'package:workout_player/view_models/nutritions_detail_screen_model.dart';

class NutritionDescriptionListTile extends ConsumerWidget {
  const NutritionDescriptionListTile({
    Key? key,
    required this.nutrition,
  }) : super(key: key);

  final Nutrition nutrition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(firebaseAuthProvider);
    final isCreditCard = nutrition.isCreditCardTransaction ?? false;
    final isOwner = auth.currentUser?.uid == nutrition.userId;

    return ListTile(
      onTap: isOwner ? () => showPopUp(context) : () {},
      title: Text(
        isCreditCard ? S.current.merchant : S.current.description,
        style: TextStyles.body1,
      ),
      trailing: Text(
        NutritionsDetailScreenModel.description(nutrition),
        style: TextStyles.body2Grey,
      ),
    );
  }

  Future<void> showPopUp(BuildContext context) async {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final model = ref.watch(editNutritionModelProvider(nutrition));

            return NutritionEditDescriptionBottomSheet(model: model);
          },
        );
      },
    );
  }
}
