import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool?> showAdaptiveModalBottomSheet(
  context, {
  required Text title,
  required Text message,
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
}) {
  if (!Platform.isIOS) {
    return showModalBottomSheet<bool>(
      useRootNavigator: false,
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return Wrap(
          children: <Widget>[
            const SizedBox(height: 16),
            ListTile(
              title: title,
              subtitle: message,
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
    useRootNavigator: false,
    context: context,
    builder: (context) => CupertinoActionSheet(
      title: title,
      message: message,
      actions: <Widget>[
        if (firstActionText != null)
          CupertinoActionSheetAction(
            isDefaultAction: (isFirstActionDefault == true) ? true : false,
            isDestructiveAction: (isFirstActionDefault == true) ? false : true,
            onPressed: firstActionOnPressed ?? () {},
            child: Text(firstActionText),
          ),
        if (secondActionText != null)
          CupertinoActionSheetAction(
            isDefaultAction: (isSecondActionDefault == true) ? true : false,
            isDestructiveAction: (isSecondActionDefault == true) ? false : true,
            onPressed: secondActionOnPressed ?? () {},
            child: Text(secondActionText),
          ),
        if (thirdActionText != null)
          CupertinoActionSheetAction(
            isDefaultAction: (isThirdActionDefault == true) ? true : false,
            isDestructiveAction: (isThirdActionDefault == true) ? false : true,
            onPressed: thirdActionOnPressed ?? () {},
            child: Text(thirdActionText),
          ),
      ],
      cancelButton: CupertinoActionSheetAction(
        isDefaultAction: (isCancelDefault == true) ? true : false,
        isDestructiveAction: (isCancelDefault == true) ? false : true,
        onPressed: () => Navigator.of(context).pop(),
        child: Text(cancelText ?? 'CANCEL'),
      ),
    ),
  );
}
