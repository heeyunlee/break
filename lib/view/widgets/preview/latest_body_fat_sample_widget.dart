import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view/widgets/cards/blur_background_card.dart';

class LatestBodyFatSampleWidget extends StatelessWidget {
  final Color? color;
  final double? padding;

  const LatestBodyFatSampleWidget({
    Key? key,
    this.color,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final date = DateFormat.MMMEd().format(DateTime.now());

    return SizedBox(
      height: 174,
      width: size.width / 2,
      child: BlurBackgroundCard(
        allPadding: padding,
        borderRadius: 28,
        color: color,
        child: Stack(
          children: [
            Positioned(
              right: 16,
              top: 16,
              child: Text(date, style: TextStyles.overline),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  Text(S.current.bodyFat, style: TextStyles.button1),
                  const SizedBox(height: 4),
                  const Text(
                    '20 %',
                    style: TextStyles.headline5MenloBoldLightBlueAccent,
                  ),
                  const SizedBox(height: 8),
                  Stack(
                    children: [
                      Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: 0.8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.lightBlueAccent,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          height: 4,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: const [
                      Text('14.5%', style: TextStyles.caption1),
                      Spacer(),
                      Text('21.4%', style: TextStyles.caption1),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
