import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';

import 'package:workout_player/models/models.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view_models/eats_tab_model.dart';

class NutritionsListTile extends StatelessWidget {
  const NutritionsListTile({
    Key? key,
    required this.nutrition,
  }) : super(key: key);

  final Nutrition nutrition;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  EatsTabModel.loggedDate(nutrition),
                  style: TextStyles.body2GreyBold,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    EatsTabModel.description(nutrition),
                    style: TextStyles.body1,
                  ),
                  if (nutrition.isCreditCardTransaction ?? false)
                    const Text(
                      'Big Mac, Drink, and fries',
                      style: TextStyles.body2LightGrey,
                    ),
                  const SizedBox(height: 8),
                  if (nutrition.isCreditCardTransaction ?? false)
                    Row(
                      children: [
                        Container(
                          width: 72,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              S.current.modify,
                              style: TextStyles.button2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          width: 72,
                          height: 32,
                          decoration: BoxDecoration(
                            color: kSecondaryColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              S.current.accept,
                              style: TextStyles.button2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (!(nutrition.isCreditCardTransaction ?? false))
                    Container(
                      width: 72,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Center(
                        child: Text(
                          S.current.manual,
                          style: TextStyles.button2,
                        ),
                      ),
                    ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    EatsTabModel.calorie(nutrition),
                    style: TextStyles.body1W800,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
