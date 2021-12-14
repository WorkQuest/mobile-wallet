import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainAppBar extends StatelessWidget with PreferredSizeWidget {
  final String title;

  const MainAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: Colors.white,
      shadowColor: Colors.transparent,
      centerTitle: false,
      leadingWidth: 0,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 30,
          color: Colors.black,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
