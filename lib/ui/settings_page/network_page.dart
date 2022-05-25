import 'package:flutter/material.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/widgets/default_app_bar.dart';
import 'package:workquest_wallet_app/widgets/default_radio.dart';
import 'package:workquest_wallet_app/widgets/layout_with_scroll.dart';

import '../../repository/account_repository.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0);

const _networks = [
  ConfigNameNetwork.devnet,
  ConfigNameNetwork.testnet,
];

class NetworkPage extends StatefulWidget {
  const NetworkPage({Key? key}) : super(key: key);

  @override
  _NetworkPageState createState() => _NetworkPageState();
}

class _NetworkPageState extends State<NetworkPage> {
  late ConfigNameNetwork _currentNetwork;

  @override
  void initState() {
    _currentNetwork = AccountRepository().configName!;
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
    return '${name.substring(0,1).toUpperCase()}${name.substring(1)}';
  }

  _onPressedChange(ConfigNameNetwork network) {
    setState(() {
      _currentNetwork = network;
    });
    AccountRepository().changeNetwork(_currentNetwork);
  }
}
