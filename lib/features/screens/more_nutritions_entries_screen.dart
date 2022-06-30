import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/nutrition.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/features/widgets/widgets.dart';

class MoreNutritionsEntriesScreen extends ConsumerWidget {
  const MoreNutritionsEntriesScreen({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    customPush(
      context,
      rootNavigator: false,
      builder: (context) => const MoreNutritionsEntriesScreen(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            centerTitle: true,
            title: Text(S.current.nutritions, style: TextStyles.subtitle2),
            leading: const AppBarBackButton(),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                CustomStreamBuilder<List<Nutrition>>(
                  stream: ref
                      .read(databaseProvider)
                      .userNutritionStream(limit: 100),
                  builder: (context, list) {
                    return CustomListViewBuilder<Nutrition>(
                      items: list,
                      itemBuilder: (context, nutrition, index) {
                        return NutritionsListTile(
                          nutrition: nutrition,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
