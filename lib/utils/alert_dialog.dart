import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workquest_wallet_app/widgets/alert_success.dart';

class AlertDialogUtils {
  static Future<void> showSuccessDialog(BuildContext context) async {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        AlertSuccess(),
        SizedBox(
          height: 15,
        ),
        Text(
          'Success',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        )
      ],
    );

    if (Platform.isIOS) {
      await showCupertinoDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          Future.delayed(
            const Duration(seconds: 1),
            () {
              Navigator.pop(context);
            },
          );
          return CupertinoAlertDialog(
            content: content,
          );
        },
      );
    } else {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          Future.delayed(
            const Duration(seconds: 1),
            () {
              Navigator.pop(context);
            },
          );
          return AlertDialog(
            content: content,
          );
        },
      );
    }
  }

  static Future<void> showLoadingDialog(BuildContext context) async {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        CircularProgressIndicator.adaptive(),
        SizedBox(
          height: 15,
          width: 15,
        ),
        Text(
          'Loading...',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        )
      ],
    );
    if (Platform.isIOS) {
      await showCupertinoDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return CupertinoAlertDialog(
            content: content,
          );
        },
      );
    } else {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 100),
            clipBehavior: Clip.hardEdge,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            content: content,
          );
        },
      );
    }
  }

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
                      style: TextStyle(color: colorCancel ?? Colors.black),
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
                    style: TextStyle(color: colorOk ?? Colors.black),
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
