import 'package:decimal/decimal.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/repository/session_repository.dart';
import 'package:workquest_wallet_app/ui/swap_page/store/swap_store.dart';
import 'package:workquest_wallet_app/ui/transfer_page/confirm_page/mobx/confirm_transfer_store.dart';
import 'package:workquest_wallet_app/utils/alert_dialog.dart';
import 'package:workquest_wallet_app/utils/web3_utils.dart';
import 'package:workquest_wallet_app/widgets/animation/login_button.dart';
import 'package:workquest_wallet_app/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:workquest_wallet_app/widgets/observer_consumer.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16.0);

class ConfirmTransferPage extends StatefulWidget {
  final TokenSymbols typeCoin;
  final String addressTo;
  final String amount;
  final String fee;

  const ConfirmTransferPage({
    Key? key,
    required this.typeCoin,
    required this.addressTo,
    required this.amount,
    required this.fee,
  }) : super(key: key);

  @override
  _ConfirmTransferPageState createState() => _ConfirmTransferPageState();
}

class _ConfirmTransferPageState extends State<ConfirmTransferPage> {
  ConfirmTransferStore store = ConfirmTransferStore();

  @override
  Widget build(BuildContext context) {
    return ObserverListener<ConfirmTransferStore>(
      store: store,
      onSuccess: () async {
        Navigator.of(context, rootNavigator: true).pop();
        await AlertDialogUtils.showSuccessDialog(context);
        Navigator.pop(context, true);
      },
      onFailure: () {
        Navigator.of(context, rootNavigator: true).pop();
        if (store.errorMessage!.contains('The waiting time is over')) {
          AlertDialogUtils.showInfoAlertDialog(
            context,
            title: 'meta.warning'.tr(),
            content: store.errorMessage!,
            okPressed: () {
              Navigator.pop(context, true);
            },
          );
          return true;
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: DefaultAppBar(
          title: 'wallet.transfer'.tr(),
        ),
        body: Padding(
          padding: _padding,
          child: Column(
            children: [
              const SizedBox(
                height: 12,
              ),
              _InformationWidget(
                fee: widget.fee,
                typeCoin: widget.typeCoin,
                addressTo: widget.addressTo,
                amount: widget.amount,
              ),
              Expanded(child: Container()),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: double.infinity,
                    ),
                    Observer(
                      builder: (_) => LoginButton(
                        onTap: () {
                          AlertDialogUtils.showLoadingDialog(context,
                              message:
                                  'Processing, please wait for the confirmation process to be completed.');
                          store.sendTransaction(widget.addressTo, widget.amount,
                              widget.typeCoin, Decimal.parse(widget.fee));
                        },
                        title: 'meta.confirm'.tr(),
                        enabled: store.isLoading,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _InformationWidget extends StatelessWidget {
  final String addressTo;
  final TokenSymbols typeCoin;
  final String amount;
  final String fee;

  const _InformationWidget({
    Key? key,
    required this.addressTo,
    required this.typeCoin,
    required this.amount,
    required this.fee,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: AppColor.disabledButton),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'wallet.recipientsAddress'.tr(),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            addressTo,
            style: const TextStyle(
              fontSize: 14,
              color: AppColor.subtitleText,
              fontFamily: 'RobotoMono',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'wallet.amount'.tr(),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            '$amount ${typeCoin.name}',
            style: const TextStyle(
              fontSize: 14,
              color: AppColor.subtitleText,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'wallet.table.trxFee'.tr(),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            '$fee ${_getTitleCoinFee()}',
            style: const TextStyle(
              fontSize: 14,
              color: AppColor.subtitleText,
            ),
          ),
        ],
      ),
    );
  }

  String _getTitleCoinFee() {
    final _network = Web3Utils.getSwapNetworksFromNetworkName(
        GetIt.I.get<SessionRepository>().networkName.value ??
            NetworkName.workNetMainnet);
    switch (_network) {
      case SwapNetworks.ETH:
        return 'ETH';
      case SwapNetworks.BSC:
        return 'BNB';
      case SwapNetworks.POLYGON:
        return 'MATIC';
      default:
        return 'WQT';
    }
  }
}
