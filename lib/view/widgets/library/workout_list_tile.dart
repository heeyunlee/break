import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

class WorkoutListTile extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String leadingText;
  final String subtitle;
  final void Function()? onTap;
  final bool selected;

  const WorkoutListTile({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.leadingText,
    required this.subtitle,
    this.onTap,
    required this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color:
                selected ? kPrimaryColor.withOpacity(0.2) : Colors.transparent,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                Expanded(
                  child: Container(
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
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeadingWidget() {
    return Container(
      height: 64,
      width: 64,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          CachedNetworkImage(
            imageUrl: imageUrl,
            errorWidget: (context, url, error) => Icon(Icons.error),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
