import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:workquest_wallet_app/ui/settings_page/settings_page.dart';
import 'package:workquest_wallet_app/ui/transfer_page/transfer_page.dart';
import 'package:workquest_wallet_app/ui/wallet_page/transactions/mobx/transactions_store.dart';
import 'package:workquest_wallet_app/ui/wallet_page/wallet/mobx/wallet_store.dart';
import 'package:workquest_wallet_app/ui/wallet_page/wallet/wallet_page.dart';
import 'package:workquest_wallet_app/utils/snack_bar.dart';
import '../../constants.dart';
import '../swap_page/swap_page.dart';

final _keys = [
  GlobalKey<NavigatorState>(),
  GlobalKey<NavigatorState>(),
  GlobalKey<NavigatorState>(),
  GlobalKey<NavigatorState>(),
];

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  final controller = CupertinoTabController();
  final int _doubleTapDuration = 2000;
  int _exitAttempt = 0;

  @override
  void initState() {
    super.initState();
    GetIt.I.get<TransactionsStore>().getTransactions();
    GetIt.I.get<WalletStore>().getCoins();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Builder(
          builder: (context) => CupertinoTabScaffold(
            controller: controller,
            tabBar: CupertinoTabBar(
              backgroundColor: Colors.white,
              items: [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    Images.walletIconBar,
                    color: AppColor.unselectedBottomIcon,
                    width: 20,
                    height: 16,
                  ),
                  activeIcon: SvgPicture.asset(
                    Images.walletIconBar,
                    color: AppColor.enabledButton,
                    width: 20,
                    height: 16,
                  ),
                  label: 'wallet.wallet'.tr(),
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    Images.transferIconBar,
                    width: 20,
                    height: 16,
                  ),
                  activeIcon: SvgPicture.asset(
                    Images.transferIconBar,
                    color: AppColor.enabledButton,
                    width: 20,
                    height: 16,
                  ),
                  label: 'wallet.transfer'.tr(),
                ),
                // BottomNavigationBarItem(
                //   icon: SvgPicture.asset(
                //     Images.transferIconBar,
                //     width: 20,
                //     height: 16,
                //   ),
                //   activeIcon: SvgPicture.asset(
                //     Images.transferIconBar,
                //     color: AppColor.enabledButton,
                //     width: 20,
                //     height: 16,
                //   ),
                //   label: 'Swap'.tr(),
                // ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    Images.settingsIconBar,
                    width: 20,
                    height: 20,
                  ),
                  activeIcon: SvgPicture.asset(
                    Images.settingsIconBar,
                    color: AppColor.enabledButton,
                    width: 20,
                    height: 20,
                  ),
                  label: 'settings.settings'.tr(),
                ),
              ],
            ),
            tabBuilder: (context, index) {
              if (index == 0) {
                return WalletPage(
                  key: _keys[0],
                );
              } else if (index == 1) {
                return TransferPage(
                  key: _keys[1],
                );
              }
              // else if (index == 2) {
              //   return SwapPage(
              //     key: _keys[2],
              //   );
              // }
              else {
                return SettingsPage(
                  key: _keys[3],
                  update: _update,
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed(BuildContext context) async {
    if (Navigator.of(_keys[controller.index].currentContext!).canPop()) {
      Navigator.of(_keys[controller.index].currentContext!).pop();
      return false;
    }

    if (_exitAttempt + _doubleTapDuration > DateTime.now().millisecondsSinceEpoch) {
      return true;
    } else {
      _exitAttempt = DateTime.now().millisecondsSinceEpoch;
      SnackBarUtils.show(
        context,
        title: 'Press back to exit',
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
      return false;
    }
  }

  void _update() {
    setState(() {});
  }
}
