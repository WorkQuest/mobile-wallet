import 'package:flutter/cupertino.dart';

class NotifyPage extends ChangeNotifier {
  CupertinoTabController controller = CupertinoTabController();

  setIndex(int value) {
    controller.index = value;
    notifyListeners();
  }
}
