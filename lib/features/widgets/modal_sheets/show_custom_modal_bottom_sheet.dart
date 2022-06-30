import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'custom_modal_bottom_sheet.dart';

Future<bool?> showCustomModalBottomSheet(
  BuildContext context, {
  Key? key,
  bool? isDismissible = true,
  required String title,
  String? subtitle,
  String? firstTileTitle,
  IconData? firstTileIcon,
  void Function()? firstTileOnTap,
  String? secondTileTitle,
  IconData? secondTileIcon,
  void Function()? secondTileOnTap,
  String? cancelTileTitle,
  IconData? cancelTitleIcon,
  void Function()? cancelTitleOnTap,
}) {
  HapticFeedback.mediumImpact();

  return showModalBottomSheet(
    context: context,
    isDismissible: isDismissible!,
    builder: (context) => CustomModalBottomSheet(
      key: key,
      title: title,
      subtitle: subtitle,
      firstTileTitle: firstTileTitle,
      firstTileIcon: firstTileIcon,
      firstTileOnTap: firstTileOnTap,
      secondTileTitle: secondTileTitle,
      secondTileIcon: secondTileIcon,
      secondTileOnTap: secondTileOnTap,
      cancelTileTitle: cancelTileTitle,
      cancelTileIcon: cancelTitleIcon,
      cancelTileOnTap: cancelTitleOnTap,
    ),
  );
}
