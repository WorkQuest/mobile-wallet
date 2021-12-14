import 'package:flutter/material.dart';
import 'package:workquest_wallet_app/constants.dart';

class CustomTabBar extends StatefulWidget {
  final TabController? tabController;

  const CustomTabBar({
    Key? key,
    required this.tabController,
  }) : super(key: key);

  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: AppColor.disabledButton,
        borderRadius: BorderRadius.circular(
          6,
        ),
      ),
      child: TabBar(
        controller: widget.tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: Colors.white,
        ),
        labelColor: Colors.black,
        unselectedLabelColor: const Color(0xff8D96A1),
        tabs: const [
          Tab(
            text: 'Wallet address',
          ),
          Tab(
            text: 'Bank card',
          ),
        ],
      ),
    );
  }
}
