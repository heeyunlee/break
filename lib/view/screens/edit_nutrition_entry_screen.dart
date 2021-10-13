import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/models.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/styles/theme_colors.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/edit_nutrition_entry_screen_model.dart';
import 'package:workout_player/view_models/home_screen_model.dart';
import 'package:workout_player/view_models/nutritions_detail_screen_model.dart';

class EditNutritionEntryScreen extends StatefulWidget {
  const EditNutritionEntryScreen({
    Key? key,
    required this.nutrition,
    required this.model,
  }) : super(key: key);

  final Nutrition nutrition;
  final EditNutritionEntryScreenModel model;

  static void show(BuildContext context, {required Nutrition nutrition}) {
    custmFadeTransition(
      context,
      isRoot: false,
      screen: Consumer(
        builder: (context, watch, child) => EditNutritionEntryScreen(
          nutrition: nutrition,
          model: watch(editNutritionEntryScreenModelProvider(nutrition)),
        ),
      ),
    );
  }

  @override
  State<EditNutritionEntryScreen> createState() =>
      _EditNutritionEntryScreenState();
}

class _EditNutritionEntryScreenState extends State<EditNutritionEntryScreen> {
  @override
  void initState() {
    super.initState();
    // widget.model.init(widget.nutrition);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final homeContext = HomeScreenModel.homeScreenNavigatorKey.currentContext!;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: ThemeColors.background,
      body: Form(
        key: EditNutritionEntryScreenModel.formKey,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              pinned: true,
              stretch: true,
              centerTitle: true,
              expandedHeight: size.height / 4,
              backgroundColor: ThemeColors.background,
              leading: const AppBarCloseButton(),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.green, ThemeColors.background],
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
                        children: const [
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 16),
                          //   child: SizedBox(
                          //     height: 48,
                          //     width: size.width - 48,
                          //     child: UnderlinedTextTextFieldWidget(
                          //       counterAsSuffix: true,
                          //       autoFocus: false,
                          //       textAlign: TextAlign.start,
                          //       inputStyle: TextStyles.headline6,
                          //       controller: widget.model.titleEditingController,
                          //       focusNode: widget.model.titleFocusNode,
                          //       formKey: EditNutritionEntryScreenModel.formKey,
                          //       hintText: S.current.foodItem,
                          //       hintStyle: TextStyles.headline6Grey,
                          //     ),
                          //   ),
                          // ),
                          SizedBox(height: 76),
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
                    const SizedBox(height: 8),
                    NutritionLoggedDateListTile(nutrition: widget.nutrition),
                    ChooseMealTypeListTile(nutrition: widget.nutrition),
                    kCustomDividerIndent16,

                    /// Nutrition Facts
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        S.current.nutritionFacts,
                        style: TextStyles.headline6W900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      onTap: () {
                        showModalBottomSheet(
                          context: homeContext,
                          builder: (context) => BlurredCard(
                            child: SizedBox(
                              height: size.height / 2,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: MaxWidthRaisedButton(
                                      radius: 24,
                                      color: ThemeColors.primary500,
                                      buttonText: S.current.save,
                                      onPressed: () =>
                                          Navigator.of(homeContext).pop(),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: size.width - 32,
                                    child: TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text(
                                        S.current.cancel,
                                        style: TextStyles.button1Grey,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                      height: kBottomNavigationBarHeight),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      title: Text(
                        S.current.calories,
                        style: TextStyles.body1,
                      ),
                      trailing: Text(
                        NutritionsDetailScreenModel.totalCalories(
                          widget.nutrition,
                        ),
                        style: TextStyles.body2Grey,
                      ),
                    ),
                    if (widget.nutrition.fat != null)
                      ListTile(
                        onTap: () {},
                        title: Text(
                          S.current.totalFat,
                          style: TextStyles.body2,
                        ),
                        trailing: Text(
                          NutritionsDetailScreenModel.totalFat(
                            widget.nutrition,
                          ),
                          style: TextStyles.caption1Grey,
                        ),
                      ),
                    if (widget.nutrition.carbs != null)
                      ListTile(
                        onTap: () {},
                        title: Text(
                          S.current.totalCarbohydrate,
                          style: TextStyles.body2,
                        ),
                        trailing: Text(
                          NutritionsDetailScreenModel.totalCarbs(
                              widget.nutrition),
                          style: TextStyles.caption1Grey,
                        ),
                      ),
                    ListTile(
                      onTap: () {},
                      title: Text(
                        S.current.protein,
                        style: TextStyles.body2,
                      ),
                      trailing: Text(
                        NutritionsDetailScreenModel.totalProtein(
                          widget.nutrition,
                        ),
                        style: TextStyles.caption1Grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    kCustomDividerIndent16,
                    const SizedBox(height: 16),
                    ListTile(
                      title: Text(
                        S.current.notes,
                        style: TextStyles.body1,
                      ),
                      subtitle: Text(
                        NutritionsDetailScreenModel.notes(widget.nutrition),
                        style: TextStyles.body2Grey,
                      ),
                    ),
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
