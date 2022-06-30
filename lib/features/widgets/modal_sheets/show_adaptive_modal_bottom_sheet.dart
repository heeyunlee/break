import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool?> showAdaptiveModalBottomSheet(
  BuildContext context, {
  String? title,
  String? message,
  bool? isFirstActionDefault,
  Icon? firstActionIcon,
  String? firstActionText,
  void Function()? firstActionOnPressed,
  bool? isSecondActionDefault,
  Icon? secondActionIcon,
  String? secondActionText,
  void Function()? secondActionOnPressed,
  bool? isThirdActionDefault,
  Icon? thirdActionIcon,
  String? thirdActionText,
  void Function()? thirdActionOnPressed,
  bool? isCancelDefault,
  Icon? cancelActionIcon,
  String? cancelText,
  bool? useRootNavigator = false,
}) {
  if (!Platform.isIOS) {
    return showModalBottomSheet<bool>(
      useRootNavigator: useRootNavigator!,
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return Wrap(
          children: <Widget>[
            const SizedBox(height: 16),
            ListTile(
              title: Text(title ?? ''),
              subtitle: Text(message ?? ''),
            ),
            const Divider(indent: 4, endIndent: 4),
            if (firstActionText != null)
              ListTile(
                leading: firstActionIcon,
                title: Text(
                  firstActionText,
                  style: TextStyle(
                    color: (isFirstActionDefault == true)
                        ? Colors.black
                        : Colors.red,
                  ),
                ),
                onTap: firstActionOnPressed,
              ),
            if (secondActionText != null)
              ListTile(
                leading: secondActionIcon,
                title: Text(
                  secondActionText,
                  style: TextStyle(
                    color: (isSecondActionDefault == true)
                        ? Colors.black
                        : Colors.red,
                  ),
                ),
                onTap: secondActionOnPressed,
              ),
            if (thirdActionText != null)
              ListTile(
                leading: thirdActionIcon,
                title: Text(
                  thirdActionText,
                  style: TextStyle(
                    color: (isThirdActionDefault == true)
                        ? Colors.black
                        : Colors.red,
                  ),
                ),
                onTap: thirdActionOnPressed,
              ),
            if (cancelText != null)
              ListTile(
                leading: cancelActionIcon,
                title: Text(
                  cancelText,
                  style: TextStyle(
                    color:
                        (isCancelDefault == true) ? Colors.black : Colors.red,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
          ],
        );
      },
    );
  }
  return showCupertinoModalPopup<bool>(
    useRootNavigator: useRootNavigator!,
    context: context,
    builder: (context) => CupertinoActionSheet(
      title: Text(title ?? ''),
      message: Text(
        message ?? '',
        textAlign: TextAlign.center,
      ),
      actions: <Widget>[
        if (firstActionText != null)
          CupertinoActionSheetAction(
            isDefaultAction: isFirstActionDefault == true,
            isDestructiveAction: isFirstActionDefault != true,
            onPressed: firstActionOnPressed ?? () {},
            child: Text(firstActionText),
          ),
        if (secondActionText != null)
          CupertinoActionSheetAction(
            isDefaultAction: isSecondActionDefault == true,
            isDestructiveAction: isSecondActionDefault != true,
            onPressed: secondActionOnPressed ?? () {},
            child: Text(secondActionText),
          ),
        if (thirdActionText != null)
          CupertinoActionSheetAction(
            isDefaultAction: isThirdActionDefault == true,
            isDestructiveAction: isThirdActionDefault != true,
            onPressed: thirdActionOnPressed ?? () {},
            child: Text(thirdActionText),
          ),
      ],
      cancelButton: CupertinoActionSheetAction(
        isDefaultAction: isCancelDefault == true,
        isDestructiveAction: isCancelDefault != true,
        onPressed: () => Navigator.of(context).pop(),
        child: Text(cancelText ?? 'CANCEL'),
      ),
    ),
  );
}
