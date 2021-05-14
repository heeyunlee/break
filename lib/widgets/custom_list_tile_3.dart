import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

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
                    borderRadius: BorderRadius.circular(10)),
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
                        style: kBodyText1Bold,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: kCaption1Grey,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                      const SizedBox(height: 4),
                      if (kSubtitle2 != null)
                        Text(
                          kSubtitle2 ?? 'Subtitle 2',
                          style: kCaption1Grey,
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
          // if (imageUrl == null)
          //   Container(
          //     decoration: BoxDecoration(
          //       gradient: LinearGradient(
          //         begin: Alignment(0.0, 0.0),
          //         end: Alignment.bottomCenter,
          //         colors: [
          //           Colors.blueGrey,
          //           Colors.blueGrey.shade900,
          //         ],
          //       ),
          //     ),
          //   ),
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
                if (isLeadingDuration) const Text('min', style: kHeadline6),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
