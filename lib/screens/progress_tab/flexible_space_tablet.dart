import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';

import '../../constants.dart';
import '../../format.dart';

class FlexibleSpaceTablet extends StatelessWidget {
  final User user;

  const FlexibleSpaceTablet({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final weights = Format.weights(user.totalWeights);
    final unit = Format.unitOfMass(user.unitOfMass);

    return FlexibleSpaceBar(
      background: Column(
        children: <Widget>[
          const SizedBox(height: 64),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.account_circle_rounded,
                color: Colors.white,
                size: 48,
              ),
              const SizedBox(width: 16),
              Text(user.displayName, style: kSubtitle1w900),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            color: kPrimaryColor,
            child: Container(
              height: size.height / 9,
              width: size.width - 48,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          text: weights,
                          style: GoogleFonts.blackHanSans(
                            color: Colors.white,
                            fontSize: 40,
                          ),
                          children: <TextSpan>[
                            TextSpan(text: '  $unit', style: kBodyText1),
                          ],
                        ),
                      ),
                      Text(S.current.lifted, style: kBodyText1),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
