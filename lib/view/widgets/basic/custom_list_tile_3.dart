import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

class CustomListTile3 extends StatelessWidget {
  const CustomListTile3({
    Key? key,
    required this.tag,
    required this.imageUrl,
    required this.title,
    required this.leadingText,
    required this.subtitle,
    this.kSubtitle2,
    this.onTap,
    this.onLongTap,
    this.trailingIconButton,
    this.isLeadingDuration = false,
  }) : super(key: key);

  final Object tag;
  final String imageUrl;
  final String title;
  final String leadingText;
  final String subtitle;
  final String? kSubtitle2;
  final void Function()? onTap;
  final void Function()? onLongTap;
  final Widget? trailingIconButton;
  final bool isLeadingDuration;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Card(
          color: Colors.transparent,
          elevation: 0,
          child: Row(
            children: <Widget>[
              Card(
                color: kBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                clipBehavior: Clip.antiAlias,
                child: _buildLeadingWidget(),
              ),
              const SizedBox(width: 16),

              // TODO: check if this works
              Expanded(
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyles.body1_bold,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: TextStyles.caption1_grey,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                      const SizedBox(height: 4),
                      if (kSubtitle2 != null)
                        Text(
                          kSubtitle2 ?? 'Subtitle 2',
                          style: TextStyles.caption1_grey,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeadingWidget() {
    return SizedBox(
      height: 64,
      width: 64,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            errorWidget: (context, url, error) => const Icon(Icons.error),
            fit: BoxFit.cover,
          ),
          Container(color: Colors.black.withOpacity(0.4)),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: FittedBox(
                    child: Text(
                      leadingText,
                      style: GoogleFonts.blackHanSans(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
                if (isLeadingDuration)
                  const Text(
                    'min',
                    style: TextStyles.headline6,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
