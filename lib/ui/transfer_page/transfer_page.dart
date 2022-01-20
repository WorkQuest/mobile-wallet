import 'dart:async';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/ui/transfer_page/confirm_page/confirm_transfer_page.dart';
import 'package:workquest_wallet_app/ui/transfer_page/mobx/transfer_store.dart';
import 'package:workquest_wallet_app/widgets/default_button.dart';
import 'package:workquest_wallet_app/widgets/default_textfield.dart';
import 'package:workquest_wallet_app/widgets/layout_with_scroll.dart';
import 'package:workquest_wallet_app/widgets/main_app_bar.dart';
import 'package:workquest_wallet_app/widgets/observer_consumer.dart';

import '../../page_router.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16.0);

List<_CoinItem> _coins = [
  _CoinItem(Images.wusdCoinIcon, 'WUSD', true),
  _CoinItem(Images.wqtCoinIcon, 'WQT', true),
  _CoinItem(Images.wbnbCoinIcon, 'wBNB', false),
  _CoinItem(Images.wethCoinIcon, 'wETH', false),
];

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
  _CoinItem? _currentCoin;

  TransferStore store = TransferStore();

  bool get _selectedCoin => _currentCoin != null;

  @override
  void initState() {
    super.initState();
    store.getFee();
    _amountController.addListener(() {
      store.setAmount(_amountController.text);
    });
    _addressController.addListener(() {
      store.setAddressTo(_addressController.text);
    });
  }

  @override
  void dispose() {
    // _addressController.dispose();
    // _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MainAppBar(
        title: "wallet.transfer".tr(),
      ),
      body: LayoutWithScroll(
        child: Padding(
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
              GestureDetector(
                onTap: _chooseCoin,
                child: Container(
                  height: 46,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.5),
                  decoration: BoxDecoration(
                    color: _selectedCoin ? Colors.white : AppColor.disabledButton,
                    borderRadius: BorderRadius.circular(6.0),
                    border: Border.all(
                      color: AppColor.disabledButton,
                    ),
                  ),
                  child: Row(
                    children: [
                      if (_selectedCoin)
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
                              _currentCoin!.iconPath,
                            ),
                          ),
                        ),
                      Text(
                        _selectedCoin ? _currentCoin!.title : 'wallet.enterCoin'.tr(),
                        style: TextStyle(
                          fontSize: 16,
                          color: _selectedCoin ? Colors.black : AppColor.disabledText,
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 5.5),
                        child: SvgPicture.asset(
                          Images.chooseCoinIcon,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
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
                  hint: 'wallet.enterAddress'.tr(),
                  suffixIcon: null,
                  inputFormatters: [
                    MaskTextInputFormatter(
                      mask: '0x########################################',
                      filter: {"#": RegExp(r'[0-9a-fA-F]')},
                      initialText: _addressController.text,
                    )
                  ],
                  validator: (value) {
                    if (_addressController.text.length != 42) {
                      return "Invalid format address";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'wallet.amount'.tr(),
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(
                height: 5,
              ),
              DefaultTextField(
                controller: _amountController,
                hint: 'wallet.enterAmount'.tr(),
                // keyboardType: TextInputType.number,
                suffixIcon: ObserverListener(
                  store: store,
                  onFailure: () => false,
                  onSuccess: () {
                    _amountController.text = store.amount;
                  },
                  child: CupertinoButton(
                    padding: const EdgeInsets.only(right: 12.5),
                    child: Text(
                      'wallet.max'.tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColor.enabledButton,
                      ),
                    ),
                    onPressed: () async {
                      store.getMaxAmount();
                    },
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,18}')),
                ],
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Container(),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Observer(
                    builder: (_) => DefaultButton(
                      title: 'wallet.transfer'.tr(),
                      onPressed:
                          store.statusButtonTransfer ? _pushConfirmTransferPage : null,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pushConfirmTransferPage() async {
    if (_key.currentState!.validate()) {
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
        FocusManager.instance.primaryFocus?.unfocus();
      }
      if (store.fee.isEmpty) {
        await store.getFee();
      }
      final result = await PageRouter.pushNewRoute(
        context,
        ConfirmTransferPage(
          fee: store.fee,
          titleCoin: store.titleSelectedCoin,
          addressTo: store.addressTo,
          amount: store.amount,
        ),
      );
      if (result != null && result) {
        setState(() {
          store.setTitleSelectedCoin('');
          store.setAddressTo('');
          store.setAmount('');
          _amountController.clear();
          _addressController.clear();
          _currentCoin = null;
        });
      }
    }
  }

  void _chooseCoin() {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0),
              topRight: Radius.circular(24.0),
            ),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: LayoutWithScroll(
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'wallet.chooseCoin'.tr(),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 16.5,
                      ),
                      ..._coins
                          .map(
                            (coin) => Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6.5),
                                  child: GestureDetector(
                                    onTap: coin.isEnable
                                        ? () {
                                            _selectCoin(coin);
                                            Navigator.pop(context);
                                          }
                                        : null,
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
                                              color: coin.isEnable
                                                  ? Colors.black
                                                  : AppColor.disabledText,
                                            ),
                                          ),
                                        ],
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
                            ),
                          )
                          .toList(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _selectCoin(_CoinItem coin) {
    setState(() {
      _currentCoin = coin;
    });
    store.setTitleSelectedCoin(coin.title);
  }
}

class _CoinItem {
  String iconPath;
  String title;
  bool isEnable;

  _CoinItem(this.iconPath, this.title, this.isEnable);
}
