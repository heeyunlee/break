import 'package:flutter/material.dart';

import 'custom_modal_bottom_sheet.dart';

Future<bool?> showCustomModalBottomSheet(
  BuildContext context, {
  Key? key,
  bool? isDismissible = true,
  required String title,
  String? subtitle,
  required String firstTileTitle,
  required IconData firstTileIcon,
  required void Function() firstTileOnTap,
  String? cancelTileTitle,
  IconData? cancelTitleIcon,
  void Function()? cancelTitleOnTap,
}) {
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
      cancelTileTitle: cancelTileTitle,
      cancelTileIcon: cancelTitleIcon,
      cancelTileOnTap: cancelTitleOnTap,
    ),
  );
}
