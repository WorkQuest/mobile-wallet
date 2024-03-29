import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:workquest_wallet_app/constants.dart';

class DefaultAppBar extends StatelessWidget with PreferredSizeWidget {
  final Function()? onPressed;
  final String? title;
  final bool titleCenter;

  const DefaultAppBar({
    Key? key,
    this.onPressed,
    this.titleCenter = true,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: Colors.white,
      shadowColor: Colors.transparent,
      centerTitle: titleCenter,
      title: Text(
        title ?? '',
        style: const TextStyle(
          fontSize: 17,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      leading: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          if (onPressed != null) {
            onPressed!.call();
          } else {
            Navigator.pop(context);
          }
        },
        child: const Icon(
          Icons.arrow_back_ios,
          color: AppColor.enabledButton,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
