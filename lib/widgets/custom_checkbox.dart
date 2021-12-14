import 'package:flutter/material.dart';
import 'package:workquest_wallet_app/constants.dart';

class CustomCheckBox extends StatelessWidget {
  final bool value;

  const CustomCheckBox({
    Key? key,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 1500,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.0),
        color: AppColor.disabledButton,
      ),
      child: Icon(
        Icons.check,
        color: value ? Colors.transparent : AppColor.enabledButton,
      ),
    );
  }
}
