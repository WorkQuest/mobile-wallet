import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/page_router.dart';
import 'package:workquest_wallet_app/repository/session_repository.dart';
import 'package:workquest_wallet_app/service/address_service.dart';
import 'package:workquest_wallet_app/ui/transfer_page/confirm_page/confirm_transfer_page.dart';
import 'package:workquest_wallet_app/ui/transfer_page/mobx/transfer_store.dart';
import 'package:workquest_wallet_app/utils/alert_dialog.dart';
import 'package:workquest_wallet_app/utils/bottom_sheet.dart';
import 'package:workquest_wallet_app/utils/formatters.dart';
import 'package:workquest_wallet_app/utils/validators.dart';
import 'package:workquest_wallet_app/utils/web3_utils.dart';
import 'package:workquest_wallet_app/widgets/default_button.dart';
import 'package:workquest_wallet_app/widgets/default_textfield.dart';
import 'package:workquest_wallet_app/widgets/dismiss_keyboard.dart';
import 'package:workquest_wallet_app/widgets/layout_with_scroll.dart';
import 'package:workquest_wallet_app/widgets/observer_consumer.dart';
import 'package:workquest_wallet_app/widgets/selected_item.dart';
import 'package:majascan/majascan.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16.0);
const _divider = SizedBox(height: 15);

class TransferPage extends StatefulWidget {
  const TransferPage({
    Key? key,
  }) : super(key: key);

  @override
  _TransferPageState createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final _key = GlobalKey<FormState>();
  final _keyAmount = GlobalKey<FormState>();

  late TransferStore store;
  late final List<CoinItem> _coins = tokens
      .map((coin) =>
          CoinItem(coin.iconPath, coin.symbolToken.name, coin.symbolToken, true))
      .toList();

  late Timer timer;

  List<DataCoins> get tokens =>
      GetIt.I.get<SessionRepository>().getConfigNetwork().dataCoins;

  @override
  void initState() {
    store = GetIt.I.get<TransferStore>();
    _amountController.addListener(() {
      store.setAmount(_amountController.text);
    });
    _addressController.addListener(() {
      store.setAddressTo(_addressController.text);
    });
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      store.checkBeforeSend(isTimerUpdate: true);
    });
    super.initState();
  }

  @override
  void dispose() {
    store.setAmount('');
    store.setAddressTo('');
    store.setFee('');
    store.setCoin(null);
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ObserverListener(
      store: store,
      onSuccess: () async {
        if (store.successData == TransferStoreState.getMaxAmount) {
          _amountController.text = (store.maxAmount ?? 0.0).toString();
        } else if (store.successData == TransferStoreState.checkBeforeSend) {
          if (_key.currentState!.validate() && _keyAmount.currentState!.validate()) {
            final result = await PageRouter.pushNewRoute(
              context,
              ConfirmTransferPage(
                fee: store.fee,
                typeCoin: store.currentCoin!.typeCoin,
                addressTo: store.addressTo,
                amount: store.amount,
              ),
            );
            if (result != null && result) {
              setState(() {
                store.setCoin(null);
                store.setAddressTo('');
                store.setAmount('');
                _amountController.clear();
                _addressController.clear();
              });
              Navigator.pop(context);
            }
          }
        }
      },
      onFailure: () => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LayoutWithScroll(
          child: Observer(
            builder: (_) => Padding(
              padding: _padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                    width: double.infinity,
                  ),
                  Text(
                    'wallet.chooseCoin'.tr(),
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SelectedItem(
                    title: store.currentCoin?.title,
                    iconPath: store.currentCoin?.iconPath,
                    isSelected: store.currentCoin != null,
                    onTap: _chooseCoin,
                  ),
                  _divider,
                  Text(
                    'wallet.recipientsAddress'.tr(),
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Form(
                    key: _key,
                    child: DefaultTextField(
                      controller: _addressController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      hint: 'wallet.enterAddress'.tr(),
                      suffixIcon: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: _onPressedScan,
                        child: SvgPicture.asset(
                          'assets/svg/scan_qr.svg',
                          color: AppColor.enabledButton,
                        ),
                      ),
                      validator: Validators.transferAddress,
                    ),
                  ),
                  _divider,
                  Text(
                    'wallet.amount'.tr(),
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Form(
                    key: _keyAmount,
                    child: DefaultTextField(
                      controller: _amountController,
                      hint: 'wallet.enterAmount'.tr(),
                      validator: (value) =>
                          Validators.transferAmount(value, store.maxAmount),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      suffixIcon: CupertinoButton(
                        padding: const EdgeInsets.only(right: 12.5),
                        child: Text(
                          'wallet.max'.tr(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColor.enabledButton,
                          ),
                        ),
                        onPressed: _onPressedMax,
                      ),
                      inputFormatters: [
                        DecimalFormatter(),
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,18}')),
                      ],
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  _divider,
                  Text(
                    _getTitleAvailableTx(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColor.enabledButton,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Observer(
                    builder: (_) => Text(
                      _getTitleTrxFee(),
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  _divider,
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(
              bottom: 10 + MediaQuery.of(context).padding.bottom,
              left: 16.0,
              right: 16.0),
          child: SizedBox(
            width: double.infinity,
            child: Observer(
              builder: (_) => DefaultButton(
                title: 'wallet.withdraw'.tr(),
                onPressed: store.statusButtonTransfer ? _onPressedTransfer : null,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _onPressedScan() async {
    String? qrResult = await MajaScan.startScan(
        title: "QRcode scanner",
        barColor: Colors.black,
        titleColor: Colors.white,
        qRCornerColor: Colors.blue,
        qRScannerColor: Colors.white,
        flashlightEnable: true,
        scanAreaScale: 0.7);
    if (qrResult != null) {
      _addressController.text = qrResult;
      store.setAddressTo(qrResult);
    }
  }

  _onPressedMax() {
    if (_key.currentState!.validate()) {
      if (store.currentCoin != null) {
        store.getMaxAmount();
      } else {
        final title = 'meta.error'.tr();
        final content = 'crediting.chooseCoin'.tr();
        AlertDialogUtils.showInfoAlertDialog(context, title: title, content: content);
      }
    }
  }

  _onPressedTransfer() async {
    if (store.isLoading) {
      return;
    }
    if (_key.currentState!.validate() && _keyAmount.currentState!.validate()) {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
        FocusManager.instance.primaryFocus?.unfocus();
      }
      final _isBech = store.addressTo.substring(0, 2).toLowerCase() == 'wq';
      if (_isBech) {
        if (store.addressTo.toLowerCase() ==
            AddressService.hexToBech32(
                GetIt.I.get<SessionRepository>().userWallet!.address!.toLowerCase())) {
          AlertDialogUtils.showInfoAlertDialog(context,
              title: 'meta.error'.tr(), content: 'errors.provideYourAddress'.tr());
          return;
        }
      } else {
        if (store.addressTo.toLowerCase() ==
            GetIt.I.get<SessionRepository>().userWallet!.address!.toLowerCase()) {
          AlertDialogUtils.showInfoAlertDialog(context,
              title: 'meta.error'.tr(), content: 'errors.provideYourAddress'.tr());
          return;
        }
      }
      if (double.parse(store.amount) == 0.0) {
        AlertDialogUtils.showInfoAlertDialog(context,
            title: 'meta.error'.tr(), content: 'errors.invalidAmount'.tr());
        return;
      }
      store.checkBeforeSend();
    }
  }

  _getTitleAvailableTx() {
    final value = store.maxAmount ?? 0.0;
    final network = store.currentCoin?.title;
    if (network != null) {
      return 'Available balance: $value $network';
    }
    return 'Available balance: ';
  }

  _getTitleTrxFee() {
    final _value = store.amount.isNotEmpty ? (double.tryParse(store.fee) ?? 0.0) : 0.0;
    return '${'wallet.table.trxFee'.tr()}: ${_value.toStringAsFixed(7)} '
        '${Web3Utils.getNativeToken().name}';
  }

  void _chooseCoin() {
    BottomSheetUtils.showDefaultBottomSheet(
      context,
      child: Column(
        children: [
          Container(
            width: 100,
            height: 5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: const Color(0xffE9EDF2),
            ),
          ),
          const SizedBox(
            height: 21,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'wallet.chooseCoin'.tr(),
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(
            height: 16.5,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: DismissKeyboard(
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _coins
                          .map((coin) =>
                              _CoinItemWidget(coin: coin, onPressed: _selectCoin))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _selectCoin(CoinItem coin) {
    store.setAmount('');
    _amountController.clear();
    store.setCoin(coin);
  }
}

class _CoinItemWidget extends StatelessWidget {
  final CoinItem coin;
  final Function(CoinItem) onPressed;

  const _CoinItemWidget({
    Key? key,
    required this.coin,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          child: InkWell(
            splashColor: Colors.transparent,
            onTap: coin.isEnable
                ? () {
                    onPressed.call(coin);
                    Navigator.pop(context);
                  }
                : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 6.5,
              ),
              child: InkWell(
                child: Container(
                  height: 32,
                  width: double.infinity,
                  color: Colors.transparent,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColor.enabledButton,
                              AppColor.blue,
                            ],
                          ),
                        ),
                        child: SizedBox(
                          width: 32,
                          height: 32,
                          child: SvgPicture.asset(
                            coin.iconPath,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        coin.title,
                        style: TextStyle(
                          fontSize: 16,
                          color: coin.isEnable ? Colors.black : AppColor.disabledText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 1,
          color: AppColor.disabledButton,
        ),
      ],
    );
  }
}

class CoinItem {
  String iconPath;
  String title;
  TokenSymbols typeCoin;
  bool isEnable;

  CoinItem(this.iconPath, this.title, this.typeCoin, this.isEnable);
}
