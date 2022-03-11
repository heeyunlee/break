import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/nutrition.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/view_models/home_screen_model.dart';
import 'package:workout_player/view_models/nutritions_detail_screen_model.dart';

import '../widgets.dart';

class NutritionDetailMoreVertButton extends ConsumerWidget {
  const NutritionDetailMoreVertButton({
    Key? key,
    required this.nutrition,
  }) : super(key: key);

  final Nutrition nutrition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(nutritionsDetailScreenModelProvider);
    final homeContext = HomeScreenModel.homeScreenNavigatorKey.currentContext!;

    return IconButton(
      icon: const Icon(Icons.more_vert_rounded),
      onPressed: () => showCustomModalBottomSheet(
        homeContext,
        title: NutritionsDetailScreenModel.title(nutrition),
        firstTileTitle: S.current.deletePascalCase,
        firstTileIcon: Icons.delete_rounded,
        firstTileOnTap: () => model.delete(
          context,
          nutrition: nutrition,
        ),
      ),
    );
  }
}
