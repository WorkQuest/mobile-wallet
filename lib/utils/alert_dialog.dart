import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlertDialogUtils {
  static void showAlertDialog(
    BuildContext context, {
    required Widget title,
    required Widget? content,
    required bool needCancel,
    required String? titleCancel,
    required String? titleOk,
    required Function()? onTabCancel,
    required Function()? onTabOk,
    required Color? colorCancel,
    required Color? colorOk,
  }) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          if (Platform.isIOS) {
            return CupertinoAlertDialog(
              title: title,
              content: content,
              actions: [
                if (needCancel)
                  CupertinoButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (onTabCancel != null) {
                        onTabCancel.call();
                      }
                    },
                    child: Text(
                      titleCancel ?? 'Cancel',
                      style: TextStyle(color: colorOk ?? Colors.black),
                    ),
                  ),
                CupertinoButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (onTabOk != null) {
                      onTabOk.call();
                    }
                  },
                  child: Text(
                    titleOk ?? 'Ok',
                    style: TextStyle(color: colorCancel ?? Colors.black),
                  ),
                ),
              ],
            );
          }
          return AlertDialog(
            title: title,
            content: content,
            actions: [
              if (needCancel)
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (onTabCancel != null) {
                      onTabCancel.call();
                    }
                  },
                  child: Text(
                    titleCancel ?? 'Cancel',
                    style: TextStyle(color: colorOk ?? Colors.black),
                  ),
                ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (onTabOk != null) {
                    onTabOk.call();
                  }
                },
                child: Text(
                  titleOk ?? 'Ok',
                  style: TextStyle(color: colorCancel ?? Colors.black),
                ),
              ),
            ],
          );
        });
  }
}
