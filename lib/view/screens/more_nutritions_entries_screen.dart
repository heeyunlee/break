import 'package:flutter/material.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/nutrition.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/styles/theme_colors.dart';
import 'package:workout_player/view/widgets/widgets.dart';

class MoreNutritionsEntriesScreen extends StatelessWidget {
  const MoreNutritionsEntriesScreen({
    Key? key,
    required this.database,
  }) : super(key: key);

  final Database database;

  static void show(BuildContext context) {
    customPush(
      context,
      rootNavigator: false,
      builder: (context, auth, database) => MoreNutritionsEntriesScreen(
        database: database,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            centerTitle: true,
            backgroundColor: ThemeColors.appBar,
            title: Text(S.current.nutritions, style: TextStyles.subtitle2),
            leading: const AppBarBackButton(),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                CustomStreamBuilder<List<Nutrition>>(
                  stream: database.userNutritionStream(limit: 100),
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
