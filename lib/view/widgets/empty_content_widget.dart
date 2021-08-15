import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

class EmptyContentWidget extends StatelessWidget {
  final String imageUrl;
  final String bodyText;
  final void Function()? onPressed;

  const EmptyContentWidget({
    Key? key,
    required this.imageUrl,
    required this.bodyText,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width,
      height: size.height * 2 / 3,
      child: Stack(
        clipBehavior: Clip.antiAlias,
        children: [
          Image.asset(
            imageUrl,
            width: size.width,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 48,
            left: 24,
            child: SizedBox(
              width: size.width / 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(bodyText, style: TextStyles.body1_heighted),
                  const SizedBox(height: 36),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      primary: kPrimaryColor,
                    ),
                    onPressed: onPressed,
                    child: Text(S.current.startNow, style: TextStyles.button1),
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
