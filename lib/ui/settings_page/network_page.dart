import 'package:flutter/material.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/widgets/default_app_bar.dart';
import 'package:workquest_wallet_app/widgets/default_radio.dart';
import 'package:workquest_wallet_app/widgets/layout_with_scroll.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0);

const _networks = [
  'Mainnet',
  'Devnet',
  'Testnet',
];

class NetworkPage extends StatefulWidget {
  const NetworkPage({Key? key}) : super(key: key);

  @override
  _NetworkPageState createState() => _NetworkPageState();
}

class _NetworkPageState extends State<NetworkPage> {
  String _currentNetwork = 'Mainnet';
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
                    onTap: () {
                      setState(() {
                        _currentNetwork = network;
                      });
                    },
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
                                network,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColor.subtitleText,
                                ),
                              ),
                            ]),
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
}
