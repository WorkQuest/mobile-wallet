import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/page_router.dart';
import 'package:workquest_wallet_app/repository/account_repository.dart';
import 'package:workquest_wallet_app/ui/deposit_page/deposit_page.dart';
import 'package:workquest_wallet_app/ui/transfer_page/confirm_page/mobx/confirm_transfer_store.dart';
import 'package:workquest_wallet_app/ui/wallet_page/transactions/list_transactions.dart';
import 'package:workquest_wallet_app/ui/wallet_page/transactions/mobx/transactions_store.dart';
import 'package:workquest_wallet_app/ui/wallet_page/wallet/mobx/wallet_store.dart';
import 'package:workquest_wallet_app/ui/withdraw_page/withdraw_page.dart';
import 'package:workquest_wallet_app/utils/snack_bar.dart';
import 'package:workquest_wallet_app/widgets/default_button.dart';
import 'package:workquest_wallet_app/widgets/main_app_bar.dart';
import 'package:workquest_wallet_app/widgets/shimmer.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16.0);

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
      appBar: MainAppBar(
        title: 'wallet.wallet'.tr(),
      ),
      body: Padding(
        padding: _padding,
        child: Platform.isIOS ? _mainLayout() : _mainLayout(),
      ),
    );
  }

  Widget _mainLayout() {
    return LazyLoadScrollView(
      onEndOfPage: () async {
        if (!GetIt.I.get<TransactionsStore>().isMoreLoading) {
          await GetIt.I.get<TransactionsStore>().getTransactionsMore();
        }
        setState(() {});
      },
      child: Platform.isAndroid
          ? RefreshIndicator(
              displacement: 30,
              triggerMode: RefreshIndicatorTriggerMode.anywhere,
              onRefresh: _onRefresh,
              child: layout())
          : layout(),
    );
  }

  Widget layout() {
    final address = AccountRepository().userAddress ?? '1234567890';
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overscroll) {
        overscroll.disallowGlow();
        return true;
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          if (Platform.isIOS)
            CupertinoSliverRefreshControl(
              onRefresh: _onRefresh,
            ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${address.substring(0, 9)}...${address.substring(address.length - 3, address.length)}',
                      style: const TextStyle(
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
                        Clipboard.setData(
                            ClipboardData(text: AccountRepository().userAddress));
                        SnackBarUtils.success(
                          context,
                          title: 'wallet.copy'.tr(),
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
                          child: Text(
                            'wallet'.tr(gender: 'withdraw'),
                            style: const TextStyle(
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
                        title: 'wallet'.tr(gender: 'deposit'),
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
          SliverAppBar(
            floating: true,
            pinned: true,
            snap: true,
            expandedHeight: 50.0,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: const EdgeInsets.only(bottom: 12.0),
              title: Text(
                'wallet.table.trx'.tr(),
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
              ),
            ),
            centerTitle: false,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            shadowColor: Colors.transparent,
          ),
          ListTransactions(
            key: UniqueKey(),
          ),
        ],
      ),
    );
  }

  Future _onRefresh() async {
    GetIt.I.get<TransactionsStore>().getTransactions(isForce: true);
    return GetIt.I.get<WalletStore>().getCoins();
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
    final store = GetIt.I.get<WalletStore>();
    return Container(
      height: 180,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        color: AppColor.disabledButton,
      ),
      child: Observer(
        builder: (_) {
          if (store.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Failed to get balance',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Swipe to update',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }
          if (store.coins.isNotEmpty) {
            return Column(
              children: [
                CarouselSlider(
                  carouselController: _controller,
                  items: store.coins.map((balance) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'wallet'.tr(gender: 'balance'),
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          if (store.isLoading)
                            SizedBox(
                              width: double.infinity,
                              height: 30,
                              child: Shimmer.fromColors(
                                baseColor: const Color(0xfff1f0f0),
                                highlightColor: Colors.white,
                                child: Container(
                                  width: 100,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                ),
                              ),
                            )
                          else
                            Text(
                              // '${num.parse(balance.amount).toInt()} ${balance.title}',
                              '${num.parse(balance.amount).toDouble().toStringAsFixed(
                                  8)} ${balance.title}',
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                                color: AppColor.enabledButton,
                              ),
                            ),
                          const SizedBox(
                            height: 5,
                          ),
                          if (store.isLoading)
                            SizedBox(
                              width: 140,
                              height: 15,
                              child: Shimmer.fromColors(
                                baseColor: const Color(0xfff1f0f0),
                                highlightColor: Colors.white,
                                child: Container(
                                  width: 100,
                                  height: 15,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                ),
                              ),
                            )
                          else
                            Text(
                              _getCourseDollar(balance.title, balance.amount),
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
                    height: 120.0,
                    viewportFraction: 1.0,
                    disableCenter: true,
                    onPageChanged: (int index, _) {
                      switch (index) {
                        case 0:
                          GetIt.I.get<TransactionsStore>().setType(TYPE_COINS.wusd);
                          GetIt.I.get<WalletStore>().setIndex(0);
                          break;
                        case 1:
                          GetIt.I.get<TransactionsStore>().setType(TYPE_COINS.wqt);
                          GetIt.I.get<WalletStore>().setIndex(1);
                          break;
                        case 2:
                          GetIt.I.get<TransactionsStore>().setType(TYPE_COINS.wBnb);
                          GetIt.I.get<WalletStore>().setIndex(2);
                          break;
                        case 3:
                          GetIt.I.get<TransactionsStore>().setType(TYPE_COINS.wEth);
                          GetIt.I.get<WalletStore>().setIndex(3);
                          break;
                      }
                      GetIt.I.get<TransactionsStore>().getTransactions(isForce: true);
                      setState(() {
                        _currencyIndex = index;
                      });
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: store.coins.map((balance) {
                    bool isCurrency = balance == store.coins[_currencyIndex];
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
                          color: isCurrency ? AppColor.enabledButton : Colors.transparent,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          }
          if (store.isLoading) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'wallet.balance'.tr(),
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 30,
                    child: Shimmer.fromColors(
                      baseColor: const Color(0xfff1f0f0),
                      highlightColor: Colors.white,
                      child: Container(
                        width: 100,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: 140,
                    height: 15,
                    child: Shimmer.fromColors(
                      baseColor: const Color(0xfff1f0f0),
                      highlightColor: Colors.white,
                      child: Container(
                        width: 100,
                        height: 15,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: Text(
              'You don\'t have any coins',
            ),
          );
        },
      ),
    );
  }

  String _getCourseDollar(String title, String amount) {
    switch (title) {
      case 'WQT':
        return '\$ ${(num.parse(amount).toDouble() * 0.03431).toStringAsFixed(4)}';
      case 'wBNB':
        return '\$ ${(num.parse(amount).toDouble() * 0.1375).toStringAsFixed(4)}';
      default:
        return '\$ ${num.parse(amount).toDouble().toStringAsFixed(4)}';
    }
  }
}
