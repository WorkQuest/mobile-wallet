import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageRouter {
  static Future<dynamic> pushNewRoute(
      BuildContext context, Widget widget) async {
    return await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(builder: (_) => widget),
    );
  }

  static pushNewReplacementRoute(BuildContext context, Widget widget) {
    Navigator.of(context, rootNavigator: true).pushReplacement(
      MaterialPageRoute(builder: (_) => widget),
    );
  }

  static pushNewRemoveRoute(BuildContext context, Widget widget) {
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => widget),
      (Route<dynamic> route) => false,
    );
  }

  static pushWithArguments(BuildContext context, dynamic store, Widget widget) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Provider(
          create: (_) => store,
          child: widget,
        ),
      ),
    );
  }
}
