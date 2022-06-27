import 'package:flutter/material.dart';
import 'package:workquest_wallet_app/constants.dart';

class InfoElement extends StatelessWidget {
  final String line;

  const InfoElement({
    Key? key,
    required this.line,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.5, horizontal: 15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        border: Border.all(
          color: AppColor.disabledButton,
        ),
      ),
      child: Text(
        line,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
