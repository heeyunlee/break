import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/styles/theme_colors.dart';

class CustomModalBottomSheet extends StatelessWidget {
  const CustomModalBottomSheet({
    Key? key,
    required this.title,
    this.subtitle,
    required this.firstTileTitle,
    required this.firstTileIcon,
    required this.firstTileOnTap,
    this.cancelTileTitle,
    this.cancelTileIcon,
    this.cancelTileOnTap,
  }) : super(key: key);

  final String title;
  final String? subtitle;
  final String firstTileTitle;
  final IconData firstTileIcon;
  final void Function() firstTileOnTap;
  final String? cancelTileTitle;
  final IconData? cancelTileIcon;
  final void Function()? cancelTileOnTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(24),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Card(
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          color: ThemeColors.card.withOpacity(0.75),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  title,
                  style: TextStyles.headline6,
                ),
              ),
              if (subtitle == null) const SizedBox(height: 8),
              if (subtitle != null)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  child: Text(
                    subtitle!,
                    style: TextStyles.body1Grey,
                  ),
                ),
              ListTile(
                onTap: firstTileOnTap,
                leading: Icon(firstTileIcon, color: Colors.white, size: 20),
                title: Text(firstTileTitle, style: TextStyles.body2),
              ),
              ListTile(
                onTap: cancelTileOnTap ?? () => Navigator.of(context).pop(),
                leading: Icon(
                  cancelTileIcon ?? Icons.close_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                title: Text(
                  cancelTileTitle ?? S.current.cancel,
                  style: TextStyles.body2,
                ),
              ),
              const SizedBox(height: kBottomNavigationBarHeight),
            ],
          ),
        ),
      ),
    );
  }
}
