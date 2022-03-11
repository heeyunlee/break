import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/nutrition.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/home_screen_model.dart';
import 'package:workout_player/view_models/nutritions_detail_screen_model.dart';

class NutritionNotesListTile extends ConsumerWidget {
  const NutritionNotesListTile({
    Key? key,
    required this.nutrition,
  }) : super(key: key);

  final Nutrition nutrition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(firebaseAuthProvider);
    final isOwner = auth.currentUser?.uid == nutrition.userId;

    return ListTile(
      onTap: isOwner ? () => showModalPopup(context) : null,
      title: Text(S.current.notes, style: TextStyles.body1),
      subtitle: Text(
        NutritionsDetailScreenModel.notes(nutrition),
        style: TextStyles.body2Grey,
      ),
    );
  }

  Future<void> showModalPopup(BuildContext context) async {
    final homeContext = HomeScreenModel.homeScreenNavigatorKey.currentContext!;

    return showModalBottomSheet(
      context: homeContext,
      isScrollControlled: true,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final model = ref.watch(editNutritionModelProvider(nutrition));

            return NutritionEditNotesBottomSheet(model: model);
          },
        );
      },
    );
  }
}
