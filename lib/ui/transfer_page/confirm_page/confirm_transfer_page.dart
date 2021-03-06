import 'package:easy_localization/src/public_ext.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/ui/transfer_page/confirm_page/mobx/confirm_transfer_store.dart';
import 'package:workquest_wallet_app/utils/alert_dialog.dart';
import 'package:workquest_wallet_app/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:workquest_wallet_app/widgets/default_button.dart';
import 'package:workquest_wallet_app/widgets/observer_consumer.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16.0);

class ConfirmTransferPage extends StatefulWidget {
  final TYPE_COINS typeCoin;
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
    return Scaffold(
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
              padding:
                  EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 10.0),
              child: SizedBox(
                width: double.infinity,
                child: ObserverListener(
                  onFailure: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    return false;
                  },
                  store: store,
                  onSuccess: () async {
                    Navigator.of(context, rootNavigator: true).pop();
                    await AlertDialogUtils.showSuccessDialog(context);
                    Navigator.pop(context, true);
                  },
                  child: DefaultButton(
                    onPressed: () {
                      AlertDialogUtils.showLoadingDialog(context);
                      store.sendTransaction(
                          widget.addressTo, widget.amount, widget.typeCoin);
                    },
                    title: 'meta.confirm'.tr(),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _InformationWidget extends StatelessWidget {
  final String addressTo;
  final TYPE_COINS typeCoin;
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
          borderRadius: BorderRadius.circular(5.0), color: AppColor.disabledButton),
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
            '$amount ${_getTitleCoin(typeCoin)}',
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
            '\$ $fee',
            style: const TextStyle(
              fontSize: 14,
              color: AppColor.subtitleText,
            ),
          ),
        ],
      ),
    );
  }

  String _getTitleCoin(TYPE_COINS type) {
    switch (type) {
      case TYPE_COINS.wusd:
        return 'WUSD';
      case TYPE_COINS.wqt:
        return 'WQT';
      case TYPE_COINS.wBnb:
        return 'wBNB';
      case TYPE_COINS.wEth:
        return 'wETH';
    }
  }
}
