import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/repository/session_repository.dart';
import 'package:workquest_wallet_app/ui/main_page/notify/notify_page.dart';
import 'package:workquest_wallet_app/ui/settings/settings_page.dart';
import 'package:workquest_wallet_app/ui/swap_page/swap_page.dart';
import 'package:workquest_wallet_app/ui/wallet_page/wallet/mobx/wallet_store.dart';
import 'package:workquest_wallet_app/ui/wallet_page/wallet/wallet_page.dart';
import 'package:workquest_wallet_app/utils/snack_bar.dart';
import 'package:workquest_wallet_app/utils/web3_utils.dart';

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

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late CupertinoTabController _controller;
  final int _doubleTapDuration = 2000;
  int _exitAttempt = 0;

  @override
  void initState() {
    super.initState();
    _controller = Provider.of<NotifyPage>(context, listen: false).controller;
    GetIt.I.get<WalletStore>().getCoins();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Builder(
          builder: (context) => Stack(
            alignment: Alignment.bottomCenter,
            children: [
              CupertinoTabScaffold(
                controller: _controller,
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
                      label: 'wallet.swap'.tr(),
                    ),
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
                    return ChangeNotifierProvider(
                      create: (context) =>
                          Provider.of<NotifyPage>(context, listen: false),
                      child: WalletPage(
                        key: _keys[0],
                      ),
                    );
                  } else if (index == 1) {
                    return SwapPage(
                      key: _keys[1],
                    );
                  } else {
                    return SettingsPage(
                      key: _keys[2],
                      update: _update,
                    );
                  }
                },
              ),
              ValueListenableBuilder<NetworkName?>(
                valueListenable: GetIt.I.get<SessionRepository>().networkName,
                builder: (_, value, child) {
                  final _title = Web3Utils.getTitleOtherNetwork(
                      value ?? NetworkName.workNetMainnet);
                  if (_title == null) {
                    return const SizedBox.shrink();
                  }
                  return Container(
                    height: 22,
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(
                        vertical: 50.0 + MediaQuery.of(context).padding.bottom),
                    decoration: const BoxDecoration(
                        color: AppColor.enabledButton,
                        gradient: LinearGradient(
                          colors: <Color>[
                            AppColor.enabledButton,
                            Color(0xFF00AA5B),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )),
                    alignment: Alignment.center,
                    child: Text(
                      _title,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed(BuildContext context) async {
    if (Navigator.of(_keys[_controller.index].currentContext!).canPop()) {
      Navigator.of(_keys[_controller.index].currentContext!).pop();
      return false;
    }

    if (_exitAttempt + _doubleTapDuration >
        DateTime.now().millisecondsSinceEpoch) {
      return true;
    } else {
      _exitAttempt = DateTime.now().millisecondsSinceEpoch;
      SnackBarUtils.show(
        context,
        title: 'meta.press_back'.tr(),
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
