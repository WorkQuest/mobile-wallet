import 'dart:io';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/widgets/alert_success.dart';

class AlertDialogUtils {
  static Future<void> showSuccessDialog(BuildContext context) async {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const AlertSuccess(),
        const SizedBox(
          height: 15,
        ),
        const Text(
          'meta',
          style: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
        ).tr(gender: 'success')
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

  static Future<void> showLoadingDialog(BuildContext context,
      {String? message}) async {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator.adaptive(),
        const SizedBox(
          height: 15,
          width: 15,
        ),
        Text(
          message ?? '${'meta'.tr(gender: 'loading')}...',
          style: const TextStyle(
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
          return WillPopScope(
            onWillPop: () => Future.value(false),
            child: AlertDialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 100),
              clipBehavior: Clip.hardEdge,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              content: content,
            ),
          );
        },
      );
    }
  }

  static void showInfoAlertDialog(
    BuildContext context, {
    required String title,
    required String content,
    Function()? okPressed,
  }) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        _onTabOk() {
          Navigator.of(context, rootNavigator: true).pop();
          if (okPressed != null) {
            okPressed.call();
          }
        }

        return Platform.isIOS
            ? CupertinoAlertDialog(
                title: Text(title),
                content: Text(content),
                actions: [
                  CupertinoDialogAction(
                    child: const Text("OK"),
                    onPressed: _onTabOk,
                  )
                ],
              )
            : AlertDialog(
                title: Text(title),
                content: Text(content),
                actions: [
                  CupertinoDialogAction(
                    child: const Text("OK"),
                    onPressed: _onTabOk,
                  )
                ],
              );
      },
    );
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
                    titleCancel ?? 'meta'.tr(gender: 'cancel'),
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
                  titleCancel ?? 'meta'.tr(gender: 'cancel'),
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
      },
    );
  }

  static void showAlertTxConfirm(
    BuildContext context, {
    required String typeTx,
    required String addressTo,
    required String amount,
    required String fee,
    required String tokenSymbol,
    required String tokenSymbolFee,
    required Function() onTabOk,
  }) {
    AlertDialogUtils.showAlertDialog(
      context,
      title: Text(typeTx),
      content: Container(
        width: 300,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.blue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Recipient's address",
              style: TextStyle(
                fontSize: 17.0,
              ),
            ),
            Text(
              addressTo,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 15.0,
                color: Color(0xFF7C838D),
              ),
            ),
            Column(
              children: [
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  "wallet.amount".tr(),
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 17.0,
                  ),
                ),
                Text(
                  "$amount $tokenSymbol",
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    fontSize: 15.0,
                    color: Color(0xFF7C838D),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            const Text(
              "Transaction fee",
              style: TextStyle(
                fontSize: 17.0,
              ),
            ),
            Text(
              "$fee $tokenSymbolFee",
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 15.0,
                color: Color(0xFF7C838D),
              ),
            ),
          ],
        ),
      ),
      needCancel: true,
      titleCancel: null,
      titleOk: 'meta.confirm'.tr(),
      onTabCancel: null,
      onTabOk: () => onTabOk(),
      colorCancel: AppColor.enabledButton,
      colorOk: Colors.red,
    );
  }
}
