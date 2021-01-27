import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool> showAdaptiveModalBottomSheet({
  BuildContext context,
  Text title,
  Text message,
  bool isFirstActionDefault,
  Icon firstActionIcon,
  String firstActionText,
  Function firstActionOnPressed,
  bool isSecondActionDefault,
  Icon secondActionIcon,
  String secondActionText,
  Function secondActionOnPressed,
  bool isThirdActionDefault,
  Icon thirdActionIcon,
  String thirdActionText,
  Function thirdActionOnPressed,
  bool isCancelDefault,
  Icon cancelActionIcon,
  String cancelText,
}) {
  if (!Platform.isIOS) {
    return showModalBottomSheet(
      useRootNavigator: false,
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return Wrap(
          children: <Widget>[
            SizedBox(height: 16),
            if (title != null || message != null)
              ListTile(
                title: title,
                subtitle: message,
              ),
            Divider(indent: 4, endIndent: 4),
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
  return showCupertinoModalPopup(
    useRootNavigator: false,
    context: context,
    builder: (context) => CupertinoActionSheet(
      title: title,
      message: message,
      actions: <Widget>[
        if (firstActionText != null)
          CupertinoActionSheetAction(
            child: Text(firstActionText),
            isDefaultAction: (isFirstActionDefault == true) ? true : false,
            isDestructiveAction: (isFirstActionDefault == true) ? false : true,
            onPressed: firstActionOnPressed,
          ),
        if (secondActionText != null)
          CupertinoActionSheetAction(
            child: Text(secondActionText),
            isDefaultAction: (isSecondActionDefault == true) ? true : false,
            isDestructiveAction: (isSecondActionDefault == true) ? false : true,
            onPressed: secondActionOnPressed,
          ),
        if (thirdActionText != null)
          CupertinoActionSheetAction(
            child: Text(thirdActionText),
            isDefaultAction: (isThirdActionDefault == true) ? true : false,
            isDestructiveAction: (isThirdActionDefault == true) ? false : true,
            onPressed: thirdActionOnPressed,
          ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text(cancelText),
        isDefaultAction: (isCancelDefault == true) ? true : false,
        isDestructiveAction: (isCancelDefault == true) ? false : true,
        onPressed: () => {Navigator.of(context).pop()},
      ),
    ),
  );
}
