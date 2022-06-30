import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/features/widgets/cards/blur_background_card.dart';

class LatestBodyWeightSampleWidget extends StatelessWidget {
  final Color? color;
  final double? padding;

  const LatestBodyWeightSampleWidget({
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
        color: color,
        allPadding: padding,
        borderRadius: 28,
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
                  Text(S.current.bodyWeight, style: TextStyles.button1),
                  const SizedBox(height: 4),
                  const Text(
                    '80 kg',
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
                        widthFactor: 0.5,
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
                      Text('75 kg', style: TextStyles.caption1),
                      Spacer(),
                      Text('85 kg', style: TextStyles.caption1),
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
