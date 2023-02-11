import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/combined/eats_tab_class.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view/screens/connect_bank_account_screen.dart';
import 'package:workout_player/view_models/eats_tab_model.dart';

class EatsTabFlexibleSpaceBar extends StatelessWidget {
  const EatsTabFlexibleSpaceBar({
    Key? key,
    required this.data,
  }) : super(key: key);

  final EatsTabClass data;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return FlexibleSpaceBar(
      background: Stack(
        fit: StackFit.passthrough,
        children: [
          CachedNetworkImage(
            imageUrl: kEatsTabBGUrl,
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  theme.colorScheme.background,
                ],
                begin: const Alignment(0, 0.5),
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            left: 24,
            top: 72,
            child: SizedBox(
              width: size.width - 48,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    S.current.eatAllCap,
                    style: TextStyles.headline5Menlo,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    S.current.eatTabSubtitle,
                    style: TextStyles.body1,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.greenAccent,
              child: InkWell(
                onTap: (data.user.isConnectedToPlaid ?? true)
                    ? null
                    : () => ConnectBankAcocuntScreen.show(context),
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: size.width - 40,
                  height: 120,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        _isPlaidConnectedWidget(),
                        const Spacer(),
                        const Icon(Icons.arrow_forward_ios_rounded)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column _isPlaidConnectedWidget() {
    if (data.user.isConnectedToPlaid ?? true) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            S.current.todaysSummary,
            style: TextStyles.body1Black54,
          ),
          const SizedBox(height: 4),
          Text(
            EatsTabModel.todaysTotalCalories(data),
            style: TextStyles.blackHans1,
          ),
          const SizedBox(height: 4),
          Text(
            '${S.current.carbs}: ${EatsTabModel.todaysCarbs(data)}   |   ${S.current.proteins}: ${EatsTabModel.todaysProtein(data)}',
            style: TextStyles.body2Black54W900,
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            S.current.connectBankAcocunts,
            style: TextStyles.blackHans3,
          ),
          const SizedBox(height: 4),
          Text(
            S.current.connectBankAcocuntsSubtitle,
            style: TextStyles.body2Black54W900,
          ),
        ],
      );
    }
  }
}
