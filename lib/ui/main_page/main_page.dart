import 'package:easy_localization/src/public_ext.dart';
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

const _paddingBottom = EdgeInsets.only(bottom: 6);

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  PageController? pageController;
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    GetIt.I.get<TransactionsStore>().getTransactions(isForce: true);
    GetIt.I.get<WalletStore>().getCoins();
  }

  @override
  void dispose() {
    super.dispose();
    pageController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        children: [
          WalletPage(),
          TransferPage(),
          SettingsPage(
            update: _update,
          ),
        ],
      ),
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          currentIndex: currentPageIndex,
          unselectedLabelStyle: const TextStyle(fontSize: 10),
          selectedLabelStyle: const TextStyle(fontSize: 10),
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: _paddingBottom,
                child: SvgPicture.asset(
                  Images.walletIconBar,
                  color: AppColor.unselectedBottomIcon,
                  width: 20,
                  height: 16,
                ),
              ),
              activeIcon: Padding(
                padding: _paddingBottom,
                child: SvgPicture.asset(
                  Images.walletIconBar,
                  color: AppColor.enabledButton,
                  width: 20,
                  height: 16,
                ),
              ),
              label: 'wallet.wallet'.tr(),
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: _paddingBottom,
                child: SvgPicture.asset(
                  Images.transferIconBar,
                  width: 20,
                  height: 16,
                ),
              ),
              activeIcon: Padding(
                padding: _paddingBottom,
                child: SvgPicture.asset(
                  Images.transferIconBar,
                  color: AppColor.enabledButton,
                  width: 20,
                  height: 16,
                ),
              ),
              label: 'wallet.transfer'.tr(),
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: _paddingBottom,
                child: SvgPicture.asset(
                  Images.settingsIconBar,
                  width: 20,
                  height: 20,
                ),
              ),
              activeIcon: Padding(
                padding: _paddingBottom,
                child: SvgPicture.asset(
                  Images.settingsIconBar,
                  color: AppColor.enabledButton,
                  width: 20,
                  height: 20,
                ),
              ),
              label: 'settings.settings'.tr(),
            ),
          ],
          onTap: (index) async {
            FocusScope.of(context).unfocus();
            setState(() {
              currentPageIndex = index;
              pageController!.jumpToPage(index);
            });
          },
        ),
      ),
    );
  }

  void _update() {
    setState(() {});
  }
}
