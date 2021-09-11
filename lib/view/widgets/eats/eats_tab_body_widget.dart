import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/combined/eats_tab_class.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view/widgets/widgets.dart';

class EatsTabBodyWidget extends StatelessWidget {
  const EatsTabBodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    final size = MediaQuery.of(context).size;

    return CustomStreamBuilder<EatsTabClass>(
      stream: database.eatsTabStream(),
      builder: (context, data) {
        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: true,
              stretch: true,
              backgroundColor: kAppBarColor,
              expandedHeight: size.height * 3 / 4,
              flexibleSpace: EatsTabFlexibleSpaceBar(data: data),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const SizedBox(width: 28),
                      Text(
                        S.current.recentTransactions,
                        style: TextStyles.body1W800,
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            S.current.seeMore,
                            style: TextStyles.button1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: const EdgeInsets.all(16),
                    color: kCardColor,
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) =>
                          kCustomDividerIndent8Heignt1,
                      itemCount: data.recentNutritions.length,
                      itemBuilder: (context, index) {
                        return NutritionsListTile(
                          nutrition: data.recentNutritions[index],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
