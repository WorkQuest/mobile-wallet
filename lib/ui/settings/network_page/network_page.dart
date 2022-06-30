import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/http/web_socket.dart';
import 'package:workquest_wallet_app/page_router.dart';
import 'package:workquest_wallet_app/ui/login_page/login_page.dart';
import 'package:workquest_wallet_app/ui/settings/network_page/store/network_store.dart';
import 'package:workquest_wallet_app/ui/transfer_page/mobx/transfer_store.dart';
import 'package:workquest_wallet_app/utils/alert_dialog.dart';
import 'package:workquest_wallet_app/widgets/default_app_bar.dart';
import 'package:workquest_wallet_app/widgets/default_radio.dart';
import 'package:workquest_wallet_app/widgets/layout_with_scroll.dart';
import 'package:workquest_wallet_app/widgets/observer_consumer.dart';

import '../../../repository/account_repository.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0);

const _networks = Network.values;

class NetworkPage extends StatefulWidget {
  const NetworkPage({Key? key}) : super(key: key);

  @override
  _NetworkPageState createState() => _NetworkPageState();
}

class _NetworkPageState extends State<NetworkPage> {
  late NetworkStore _store;

  @override
  void initState() {
    _store = NetworkStore();
    _store.setNetwork(AccountRepository().notifierNetwork.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultAppBar(
        title: 'wallet.network'.tr(),
      ),
      body: ObserverListener(
        store: _store,
        onSuccess: () async {
          Navigator.of(context, rootNavigator: true).pop();
          await AlertDialogUtils.showSuccessDialog(context);
        },
        onFailure: () {
          Navigator.of(context, rootNavigator: true).pop();
          if (_store.errorMessage != 'User not found') {
            return false;
          }
          _showAlertConfirmChangeNetwork(_store.network == Network.mainnet ? Network.testnet : Network.mainnet);
          return true;
        },
        child: Observer(
          builder: (_) => LayoutWithScroll(
            child: Padding(
              padding: _padding,
              child: Column(
                children: _networks.map((network) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () => _onPressedChange(network),
                        child: ColoredBox(
                          color: Colors.transparent,
                          child: SizedBox(
                            height: 36,
                            width: double.infinity,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                DefaultRadio(
                                  status: _store.network == network,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  _getName(network.name),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppColor.subtitleText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getName(String name) {
    return '${name.substring(0, 1).toUpperCase()}${name.substring(1)}';
  }

  _onPressedChange(Network newNetwork) {
    if (_store.network != newNetwork) {
      AlertDialogUtils.showLoadingDialog(context);
      _store.changeNetwork(newNetwork);
    }
  }

  _showAlertConfirmChangeNetwork(Network network) {
    AlertDialogUtils.showAlertDialog(
      context,
      title: Text('meta.warning'.tr()),
      content: Text('wallet.changeNetworkInfo'.tr()),
      needCancel: true,
      titleCancel: null,
      titleOk: 'meta.confirm'.tr(),
      onTabCancel: null,
      onTabOk: () => _pushToLogin(network),
      colorCancel: AppColor.enabledButton,
      colorOk: Colors.red,
    );
  }

  _pushToLogin(Network network) async {
    await PageRouter.pushNewRemoveRoute(context, const LoginPage());
    WebSocket().closeWebSocket();
    AccountRepository().clearData();
    AccountRepository().notifierNetwork.value = network;
    GetIt.I.get<TransferStore>().setCoin(null);
  }
}
