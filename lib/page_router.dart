import 'package:flutter/material.dart';

class PageRouter {
  static pushNewRoute(BuildContext context, Widget widget) {
    Navigator.of(context, rootNavigator: true)
        .push(MaterialPageRoute(builder: (_) => widget));
  }

  static pushNewReplacementRoute(BuildContext context, Widget widget) {
    Navigator.of(context, rootNavigator: true)
        .pushReplacement(MaterialPageRoute(builder: (_) => widget));
  }


}
