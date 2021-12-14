import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/ui/transfer_page/confirm_transfer_page.dart';
import 'package:workquest_wallet_app/widgets/default_button.dart';
import 'package:workquest_wallet_app/widgets/default_textfield.dart';
import 'package:workquest_wallet_app/widgets/layout_with_scroll.dart';
import 'package:workquest_wallet_app/widgets/main_app_bar.dart';

import '../../page_router.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16.0);

List<_CoinItem> _coins = [
  _CoinItem(Images.wusdCoinIcon, 'WUSD'),
  _CoinItem(Images.wqtCoinIcon, 'WQT'),
  _CoinItem(Images.wbnbCoinIcon, 'wBNB'),
  _CoinItem(Images.wethCoinIcon, 'wETH'),
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

  _CoinItem? _currentCoin;

  bool get _selectedCoin => _currentCoin != null;

  bool get _statusTransferButton =>
      _selectedCoin &&
      _addressController.text.isNotEmpty &&
      _amountController.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _addressController.addListener(() {
      setState(() {});
    });
    _amountController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const MainAppBar(
        title: "Transfer",
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
              const Text(
                'Choose coin',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(
                height: 5,
              ),
              GestureDetector(
                onTap: _chooseCoin,
                child: Container(
                  height: 46,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 12.5),
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
                        _selectedCoin ? _currentCoin!.title : 'Enter coin',
                        style: TextStyle(
                          fontSize: 16,
                          color: _selectedCoin
                              ? Colors.black
                              : AppColor.disabledText,
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
              const Text(
                'Recipient address',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(
                height: 5,
              ),
              DefaultTextField(
                controller: _addressController,
                hint: 'Enter address',
                suffixIcon: null,
                inputFormatters: [
                  MaskTextInputFormatter(
                    mask: 'dxAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA',
                    initialText: _addressController.text,
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Amount',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(
                height: 5,
              ),
              DefaultTextField(
                controller: _amountController,
                hint: 'Enter amount',
                keyboardType: TextInputType.number,
                suffixIcon: CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Text(
                    'Max',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColor.enabledButton,
                    ),
                  ),
                  onPressed: () {
                    _amountController.text = '9999';
                  },
                ),
                inputFormatters: null,
              ),
              const SizedBox(height: 20,),
              Expanded(
                child: Container(),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: DefaultButton(
                    title: 'Transfer',
                    onPressed: _statusTransferButton
                        ? _pushConfirmTransferPage
                        : null,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _pushConfirmTransferPage() {
    print("address -> ${_addressController.text}");
    PageRouter.pushNewRoute(context, const ConfirmTransferPage());
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
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
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
                      const Text(
                        'Choose coin',
                        style: TextStyle(
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 6.5),
                                  child: GestureDetector(
                                    onTap: () {
                                      _selectCoin(coin);
                                      Navigator.pop(context);
                                    },
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
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
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
  }
}

class _CoinItem {
  String iconPath;
  String title;

  _CoinItem(this.iconPath, this.title);
}
