import 'package:flutter/material.dart';

class SnackBarUtils {
  static void show(BuildContext context, {
    required String title,
    Duration duration = const Duration(seconds: 1),
    Color backgroundColor = Colors.white,
    Color textColor = Colors.black,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: duration,
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          content: Row(
            children: [
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 14, color: textColor),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
  }

  static void success(BuildContext context, {String? title, Duration? duration}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: duration ?? const Duration(seconds: 1),
          backgroundColor: Colors.white,
          behavior: SnackBarBehavior.floating,
          content: Row(
            children: [
              Flexible(
                child: Text(
                  title ?? 'Success',
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Icon(
                Icons.check,
                color: Colors.green,
              )
            ],
          ),
        ),
      );
  }

  static void loading(BuildContext context, {String? title, Duration? duration}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: duration ?? const Duration(minutes: 3),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            Text(
              title ?? 'Loading',
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
            const Spacer(),
            const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  color: Colors.grey,
                )),
          ],
        ),
      ),
    );
  }

  static void error(BuildContext context, {String? title, Duration? duration}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: duration ?? const Duration(seconds: 1),
          backgroundColor: Colors.white,
          behavior: SnackBarBehavior.floating,
          content: Row(
            children: [
              Text(
                title ?? 'Error',
                style: const TextStyle(fontSize: 14, color: Colors.black),
              ),
              const Spacer(),
              const Icon(
                Icons.error_outline,
                color: Colors.red,
              )
            ],
          ),
        ),
      );
  }
}


