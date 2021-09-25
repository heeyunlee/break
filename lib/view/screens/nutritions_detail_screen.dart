import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/food_item.dart';
import 'package:workout_player/models/nutrition.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/button_styles.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/styles/theme_colors.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/home_screen_model.dart';
import 'package:workout_player/view_models/nutritions_detail_screen_model.dart';

class NutritionsDetailScreen extends ConsumerWidget {
  const NutritionsDetailScreen({
    Key? key,
    required this.nutrition,
    required this.database,
  }) : super(key: key);

  final Nutrition nutrition;
  final Database database;

  static void show(BuildContext context, {required Nutrition nutrition}) {
    customPush(
      context,
      rootNavigator: false,
      builder: (context, _, database) => NutritionsDetailScreen(
        nutrition: nutrition,
        database: database,
      ),
    );
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final model = watch(nutritionsDetailScreenModelProvider);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: ThemeColors.background,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            pinned: true,
            stretch: true,
            centerTitle: true,
            expandedHeight: size.height / 4,
            backgroundColor: ThemeColors.background,
            leading: const AppBarBackButton(),
            actions: [
              // IconButton(
              //   onPressed: () {},
              //   icon: const Icon(Icons.edit_rounded),
              // ),
              IconButton(
                onPressed: () {
                  showCustomModalBottomSheet(
                    HomeScreenModel.homeScreenNavigatorKey.currentContext!,
                    title: NutritionsDetailScreenModel.title(nutrition),
                    firstTileTitle: S.current.delete,
                    firstTileIcon: Icons.delete_rounded,
                    firstTileOnTap: () => model.delete(
                      context,
                      database: database,
                      nutrition: nutrition,
                    ),
                    // firstTileOnTap: () {
                    //   final a = HomeScreenModel
                    //       .homeScreenNavigatorKey.currentContext!;
                    //   Navigator.of(a).pop();
                    // },
                  );
                },
                icon: const Icon(Icons.more_vert_rounded),
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.greenAccent,
                          ThemeColors.background,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            NutritionsDetailScreenModel.title(nutrition),
                            style: TextStyles.headline6,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            Formatter.yMdjmInDateTime(
                              nutrition.loggedTime.toDate(),
                            ),
                            style: TextStyles.body2White54W900,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const SizedBox(width: 8),
                            if (!(nutrition.isCreditCardTransaction ?? true))
                              Chip(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                labelStyle: TextStyles.button2,
                                backgroundColor: Colors.black54,
                                label: Text(
                                  S.current.manual,
                                  style: TextStyles.button2,
                                ),
                              ),
                            const SizedBox(width: 16),
                            if (nutrition.isCreditCardTransaction ?? true)
                              const Chip(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                labelStyle: TextStyles.button2,
                                backgroundColor: Colors.black54,
                                label: Text(
                                  'From Credit Card',
                                  style: TextStyles.button2,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomListViewBuilder<FoodItem>(
                    items: nutrition.foodItems ?? [],
                    emptyContentWidget: Container(),
                    header: Row(
                      children: [
                        const Icon(Icons.menu_book_rounded, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          S.current.itemsAutoGenerated,
                          style: TextStyles.headline6W900,
                        ),
                      ],
                    ),
                    footer: Column(
                      children: [
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 40,
                              width: size.width / 2 - 24,
                              child: ElevatedButton(
                                style: ButtonStyles.elevatedStadiumGrey,
                                onPressed: () {},
                                child: Text(
                                  S.current.modify,
                                  style: TextStyles.button1,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            SizedBox(
                              height: 40,
                              width: size.width / 2 - 24,
                              child: ElevatedButton(
                                style: ButtonStyles.elevatedStadium,
                                onPressed: () {},
                                child: Text(
                                  S.current.accept,
                                  style: TextStyles.button1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        kWhiteDivider,
                      ],
                    ),
                    itemBuilder: (context, foodItem, index) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          foodItem.name,
                          style: TextStyles.body2Bold,
                        ),
                        subtitle: Text(
                          NutritionsDetailScreenModel.foodItemProtein(
                            foodItem,
                          ),
                          style: TextStyles.caption1Grey,
                        ),
                        trailing: Text(
                          NutritionsDetailScreenModel.foodItemCalories(
                            foodItem,
                          ),
                          style: TextStyles.body2Bold,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  if (nutrition.isCreditCardTransaction ?? false)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        S.current.merchant,
                        style: TextStyles.body1,
                      ),
                      trailing: Text(
                        NutritionsDetailScreenModel.merchantName(nutrition),
                        style: TextStyles.body2Grey,
                      ),
                    ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      S.current.date,
                      style: TextStyles.body1,
                    ),
                    trailing: Text(
                      Formatter.date(nutrition.loggedTime),
                      style: TextStyles.body2Grey,
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      S.current.mealType,
                      style: TextStyles.body1,
                    ),
                    trailing: Text(
                      NutritionsDetailScreenModel.mealType(nutrition),
                      style: TextStyles.body2Grey,
                    ),
                  ),
                  kCustomDivider,
                  const SizedBox(height: 16),
                  Text(
                    S.current.nutritionFacts,
                    style: TextStyles.headline6W900,
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      S.current.calories,
                      style: TextStyles.body1,
                    ),
                    trailing: Text(
                      NutritionsDetailScreenModel.totalCalories(nutrition),
                      style: TextStyles.body2Grey,
                    ),
                  ),
                  if (nutrition.fat != null)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        S.current.totalFat,
                        style: TextStyles.body2,
                      ),
                      trailing: Text(
                        NutritionsDetailScreenModel.totalFat(nutrition),
                        style: TextStyles.caption1Grey,
                      ),
                    ),
                  if (nutrition.carbs != null)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        S.current.totalCarbohydrate,
                        style: TextStyles.body2,
                      ),
                      trailing: Text(
                        NutritionsDetailScreenModel.totalCarbs(nutrition),
                        style: TextStyles.caption1Grey,
                      ),
                    ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      S.current.protein,
                      style: TextStyles.body2,
                    ),
                    trailing: Text(
                      NutritionsDetailScreenModel.totalProtein(nutrition),
                      style: TextStyles.caption1Grey,
                    ),
                  ),
                  kCustomDivider,
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      S.current.notes,
                      style: TextStyles.body1,
                    ),
                    subtitle: Text(
                      NutritionsDetailScreenModel.notes(nutrition),
                      style: TextStyles.body2Grey,
                    ),
                  ),
                  const SizedBox(height: 104)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
