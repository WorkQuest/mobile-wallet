import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/http/api.dart';
import 'package:workquest_wallet_app/http/web_socket.dart';
import 'package:workquest_wallet_app/page_router.dart';
import 'package:workquest_wallet_app/ui/login_page/login_page.dart';
import 'package:workquest_wallet_app/utils/alert_dialog.dart';
import 'package:workquest_wallet_app/widgets/default_app_bar.dart';
import 'package:workquest_wallet_app/widgets/default_radio.dart';
import 'package:workquest_wallet_app/widgets/layout_with_scroll.dart';

import '../../repository/account_repository.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0);

const _networks = ConfigNameNetwork.values;

class NetworkPage extends StatefulWidget {
  const NetworkPage({Key? key}) : super(key: key);

  @override
  _NetworkPageState createState() => _NetworkPageState();
}

class _NetworkPageState extends State<NetworkPage> {
  late ConfigNameNetwork _currentNetwork;
  late bool isTestnet;

  @override
  void initState() {
    _currentNetwork = AccountRepository().configName!;
    isTestnet = Api().currentNetworkIsTestnet;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const DefaultAppBar(
        title: 'Network',
      ),
      body: LayoutWithScroll(
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
                              status: _currentNetwork == network,
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
    );
  }

  String _getName(String name) {
    return '${name.substring(0, 1).toUpperCase()}${name.substring(1)}';
  }

  _onPressedChange(ConfigNameNetwork network) {
    bool _showAlert = false;
    if (isTestnet) {
      _showAlert = network == ConfigNameNetwork.devnet;
    } else {
      _showAlert = network == ConfigNameNetwork.testnet;
    }

    if (_showAlert) {
      _showAlertConfirmChangeNetwork(network);
    } else {
      setState(() {
        _currentNetwork = network;
      });
      AccountRepository().changeNetwork(_currentNetwork);
    }
  }

  _showAlertConfirmChangeNetwork(ConfigNameNetwork network) {
    AlertDialogUtils.showAlertDialog(
      context,
      title: Text('meta.warning'.tr()),
      content: const Text(
          'Do you really want to change the network?\nIf there is a change to this network, the '
          'current '
          'session will be over. You will need to re-enter the platform.'),
      needCancel: true,
      titleCancel: null,
      titleOk: 'Confirm',
      onTabCancel: null,
      onTabOk: () => _pushToLogin(network),
      colorCancel: AppColor.enabledButton,
      colorOk: Colors.red,
    );
  }

  _pushToLogin(ConfigNameNetwork network) async {
    await PageRouter.pushNewRemoveRoute(context, const LoginPage());
    WebSocket().closeWebSocket();
    AccountRepository().clearData();
    AccountRepository().setNetwork(network.name);
  }
}
