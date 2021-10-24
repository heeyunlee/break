import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/food_item.dart';
import 'package:workout_player/models/nutrition.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/button_styles.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/dummy_data.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/nutritions_detail_screen_model.dart';

class NutritionsDetailScreen extends StatelessWidget {
  const NutritionsDetailScreen({
    Key? key,
    required this.database,
    required this.nutrition,
  }) : super(key: key);

  final Database database;
  final Nutrition? nutrition;

  static void show(BuildContext context, {required Nutrition? nutrition}) {
    customPush(
      context,
      rootNavigator: false,
      builder: (context, _, database) => NutritionsDetailScreen(
        database: database,
        nutrition: nutrition,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: CustomStreamBuilder<Nutrition?>(
        initialData: DummyData.nutrition,
        stream: database.nutritionStream(nutrition?.nutritionId ?? ''),
        builder: (context, nutrition) => CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              pinned: true,
              stretch: true,
              centerTitle: true,
              expandedHeight: size.height / 4,
              leading: const AppBarBackButton(),
              actions: [
                NutritionDetailMoreVertButton(
                  database: database,
                  nutrition: nutrition!,
                ),
                const SizedBox(width: 8),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.greenAccent,
                            theme.backgroundColor,
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
                              Formatter.date(nutrition.loggedTime),
                              style: TextStyles.body2White54W900,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              const SizedBox(width: 8),
                              if (!(nutrition.isCreditCardTransaction ?? true))
                                Chip(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  labelStyle: TextStyles.button2,
                                  backgroundColor: Colors.grey,
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
                padding: const EdgeInsets.symmetric(vertical: 16),
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
                                  style: ButtonStyles.elevatedStadiumGrey(),
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
                                  style: ButtonStyles.elevatedStadium(context),
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
                    NutritionDescriptionListTile(nutrition: nutrition),
                    NutritionLoggedDateListTile(nutrition: nutrition),
                    NutritionMealTypeListTile(nutrition: nutrition),

                    /// Nutritional Facts
                    kCustomDividerIndent16,
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        S.current.nutritionFacts,
                        style: TextStyles.headline6W900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    NutritionCaloriesListTile(nutrition: nutrition),
                    NutritionTotalFatListTile(nutrition: nutrition),
                    NutritionCarbsListTile(nutrition: nutrition),
                    NutritionProteinListTile(nutrition: nutrition),

                    // Others
                    kCustomDividerIndent16,
                    NutritionNotesListTile(nutrition: nutrition),
                    const SizedBox(height: kBottomNavigationBarHeight + 48)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
