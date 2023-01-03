import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/repository/session_repository.dart';
import 'package:workquest_wallet_app/ui/swap_page/store/swap_store.dart';
import 'package:workquest_wallet_app/utils/web3_utils.dart';
import 'package:workquest_wallet_app/widgets/default_app_bar.dart';
import 'package:workquest_wallet_app/widgets/default_radio.dart';
import 'package:workquest_wallet_app/widgets/layout_with_scroll.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0);

const _networks = Network.values;

class NetworkPage extends StatefulWidget {
  const NetworkPage({Key? key}) : super(key: key);

  @override
  _NetworkPageState createState() => _NetworkPageState();
}

class _NetworkPageState extends State<NetworkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultAppBar(
        title: 'wallet.network'.tr(),
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
                              status: GetIt.I
                                      .get<SessionRepository>()
                                      .notifierNetwork
                                      .value ==
                                  network,
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

  _onPressedChange(Network newNetwork) {
    if (GetIt.I.get<SessionRepository>().notifierNetwork.value != newNetwork) {
      final _newNetworkName = Web3Utils.getNetworkNameSwap(
          GetIt.I.get<SessionRepository>().networkName.value!);
      GetIt.I.get<SessionRepository>().notifierNetwork.value = newNetwork;
      GetIt.I.get<SessionRepository>().changeNetwork(_newNetworkName);
      Future.delayed(const Duration(milliseconds: 450)).then((value) {
        if (GetIt.I.get<SwapStore>().network != null) {
          GetIt.I.get<SwapStore>().getMaxBalance();
        }
      });
      setState(() {});
    }
  }
}
