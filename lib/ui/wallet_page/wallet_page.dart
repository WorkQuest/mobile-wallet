import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/page_router.dart';
import 'package:workquest_wallet_app/ui/deposit_page/deposit_page.dart';
import 'package:workquest_wallet_app/ui/wallet_page/list_transactions.dart';
import 'package:workquest_wallet_app/ui/withdraw_page/withdraw_page.dart';
import 'package:workquest_wallet_app/utils/snack_bar.dart';
import 'package:workquest_wallet_app/widgets/default_button.dart';
import 'package:workquest_wallet_app/widgets/main_app_bar.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16.0);

final _balances = [
  _Balance(150, 'WUSD', '\$ 120.34'),
  _Balance(100, 'WQT', '\$ 155.34'),
  _Balance(150, 'wBNB', '\$ 120.34'),
  _Balance(150, 'wETH', '\$ 120.34'),
];

class _Balance {
  int balance;
  String currency;
  String balanceInDollars;

  _Balance(this.balance, this.currency, this.balanceInDollars);
}

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const MainAppBar(
        title: 'Wallet',
      ),
      body: Padding(
        padding: _padding,
        child: Platform.isIOS
            ? _mainLayout()
            : RefreshIndicator(
                child: _mainLayout(),
                onRefresh: () {
                  return Future.delayed(const Duration(seconds: 1));
                },
              ),
      ),
    );
  }

  Widget _mainLayout() {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        if (Platform.isIOS)
          CupertinoSliverRefreshControl(
            onRefresh: () {
              return Future.delayed(const Duration(seconds: 1));
            },
          ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    '0xu383d7g...dq9w',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColor.subtitleText,
                    ),
                  ),
                  const Spacer(),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    pressedOpacity: 0.2,
                    onPressed: () {
                      //TODO make copy
                      SnackBarUtils.success(
                        context,
                        title: 'Copied!',
                        duration: const Duration(milliseconds: 500),
                      );
                    },
                    child: Container(
                      height: 34,
                      width: 34,
                      padding: const EdgeInsets.all(7.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.0),
                          color: AppColor.disabledButton),
                      child: SvgPicture.asset(
                        Images.walletCopyIcon,
                        color: AppColor.enabledButton,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                width: double.infinity,
                child: _InfoCardBalance(),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      pressedOpacity: 0.2,
                      onPressed: () {
                        PageRouter.pushNewRoute(context, const WithdrawPage());
                      },
                      child: Container(
                        height: 43,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.0),
                          border: Border.all(
                            color: Colors.blue.withOpacity(0.1),
                          ),
                        ),
                        child: const Text(
                          'Withdraw',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColor.enabledButton,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 1,
                    child: DefaultButton(
                      title: 'Deposit',
                      onPressed: () {
                        PageRouter.pushNewRoute(context, const DepositPage());
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        const SliverAppBar(
          floating: true,
          pinned: true,
          snap: true,
          expandedHeight: 50.0,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: false,
            titlePadding: EdgeInsets.only(bottom: 12.0),
            title: Text(
              'Transactions',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black),
            ),
          ),
          centerTitle: false,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
        ),
        const ListTransactions(),
      ],
    );
  }
}

class _InfoCardBalance extends StatefulWidget {
  const _InfoCardBalance({Key? key}) : super(key: key);

  @override
  State<_InfoCardBalance> createState() => _InfoCardBalanceState();
}

class _InfoCardBalanceState extends State<_InfoCardBalance> {
  final CarouselController _controller = CarouselController();

  int _currencyIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        color: AppColor.disabledButton,
      ),
      child: Column(
        children: [
          CarouselSlider(
            carouselController: _controller,
            items: _balances.map((balance) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Balance',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      '${balance.balance} ${balance.currency}',
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        color: AppColor.enabledButton,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      balance.balanceInDollars,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColor.unselectedBottomIcon,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            options: CarouselOptions(
                height: 110.0,
                autoPlay: true,
                viewportFraction: 1.0,
                disableCenter: true,
                onPageChanged: (int index, _) {
                  setState(() {
                    _currencyIndex = index;
                  });
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _balances.map((balance) {
              bool isCurrency = balance == _balances[_currencyIndex];
              return GestureDetector(
                onTap: () => _controller.nextPage(),
                child: Container(
                  width: 12.0,
                  height: 12.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: isCurrency
                        ? null
                        : Border.all(
                            color: AppColor.enabledButton.withOpacity(0.1)),
                    color: isCurrency
                        ? AppColor.enabledButton
                        : Colors.transparent,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
