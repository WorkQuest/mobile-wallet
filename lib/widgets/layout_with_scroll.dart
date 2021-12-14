import 'package:flutter/material.dart';
import 'package:workquest_wallet_app/widgets/dismiss_keyboard.dart';

class LayoutWithScroll extends StatelessWidget {
  final Widget child;

  const LayoutWithScroll({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: LayoutBuilder(
        builder: (context, constraint) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraint.maxHeight),
              child: IntrinsicHeight(
                child: child,
              ),
            ),
          );
        },
      ),
    );
  }
}
