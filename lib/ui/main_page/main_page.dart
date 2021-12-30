import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:workquest_wallet_app/ui/settings_page/settings_page.dart';
import 'package:workquest_wallet_app/ui/transfer_page/transfer_page.dart';
import 'package:workquest_wallet_app/ui/wallet_page/transactions/mobx/transactions_store.dart';
import 'package:workquest_wallet_app/ui/wallet_page/wallet/mobx/wallet_store.dart';
import 'package:workquest_wallet_app/ui/wallet_page/wallet/wallet_page.dart';
import '../../constants.dart';


final _keys = [
  GlobalKey<NavigatorState>(),
  GlobalKey<NavigatorState>(),
  GlobalKey<NavigatorState>(),
];

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  void initState() {
    super.initState();
    GetIt.I.get<TransactionsStore>().getTransactions();
    GetIt.I.get<WalletStore>().getCoins();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: CupertinoTabScaffold(
        backgroundColor: Colors.white,
        tabBuilder: (BuildContext context, int index) {
          switch (index) {
            case 0:
              return CupertinoTabView(
                  navigatorKey: _keys[0],
                  builder: (context) {
                    return const WalletPage();
                  });
            case 1:
              return CupertinoTabView(
                  navigatorKey: _keys[1],
                  builder: (context) {
                    return const TransferPage();
                  });
            case 2:
              return CupertinoTabView(
                  navigatorKey: _keys[2],
                  builder: (context) {
                    return const SettingsPage();
                  });
          }
          return Container();
        },
        tabBar: CupertinoTabBar(
          backgroundColor: Colors.white,
          activeColor: AppColor.enabledButton,
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade100
            )
          ),
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(Images.walletIconBar, color: AppColor.unselectedBottomIcon,),
              activeIcon: SvgPicture.asset(Images.walletIconBar, color: AppColor.enabledButton,),
              label: 'Wallet',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(Images.transferIconBar),
              activeIcon: SvgPicture.asset(Images.transferIconBar, color: AppColor.enabledButton,),
              label: 'Transfer',
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(Images.settingsIconBar),
              activeIcon: SvgPicture.asset(Images.settingsIconBar, color: AppColor.enabledButton,),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
