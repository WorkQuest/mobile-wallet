import 'dart:io';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/page_router.dart';
import 'package:workquest_wallet_app/repository/account_repository.dart';
import 'package:workquest_wallet_app/ui/deposit_page/deposit_page.dart';
import 'package:workquest_wallet_app/ui/main_page/notify/notify_page.dart';
import 'package:workquest_wallet_app/ui/swap_page/store/swap_store.dart';
import 'package:workquest_wallet_app/ui/wallet_page/transactions/list_transactions.dart';
import 'package:workquest_wallet_app/ui/wallet_page/transactions/mobx/transactions_store.dart';
import 'package:workquest_wallet_app/ui/wallet_page/wallet/mobx/wallet_store.dart';
import 'package:workquest_wallet_app/ui/withdraw_page/withdraw_page.dart';
import 'package:workquest_wallet_app/utils/web3_utils.dart';
import 'package:workquest_wallet_app/widgets/copy_address_wallet_widget.dart';
import 'package:workquest_wallet_app/widgets/default_button.dart';
import 'package:workquest_wallet_app/widgets/dropdown_adaptive_widget.dart';
import 'package:workquest_wallet_app/widgets/main_app_bar.dart';
import 'package:workquest_wallet_app/widgets/shimmer.dart';
import 'package:workquest_wallet_app/widgets/switch_format_address_widget.dart';

const _padding = EdgeInsets.symmetric(horizontal: 16.0);

class WalletPage extends StatefulWidget {
  const WalletPage({Key? key}) : super(key: key);

  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MainAppBar(
        title: 'wallet.wallet'.tr(),
        actions: [
          ValueListenableBuilder<NetworkName?>(
            valueListenable: AccountRepository().networkName,
            builder: (_, value, child) {
              final _networkName = Web3Utils.getNetworkNameForSwitch(value ?? NetworkName.workNetMainnet);
              return DropDownAdaptiveWidget<SwitchNetworkNames>(
                value: _networkName,
                onChanged: (value) {
                  final _newNetwork = Web3Utils.getNetworkNameFromSwitchNetworkName(
                      value as SwitchNetworkNames, AccountRepository().notifierNetwork.value);
                  AccountRepository().changeNetwork(_newNetwork);
                  final _swapNetwork = Web3Utils.getSwapNetworksFromNetworkName(_newNetwork);
                  GetIt.I.get<SwapStore>().setNetwork(_swapNetwork);
                  return value;
                },
                items: SwitchNetworkNames.values,
                colorText: Colors.black,
                haveIcon: true,
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: _padding,
        child: Platform.isIOS ? _mainLayout() : _mainLayout(),
      ),
    );
  }

  Widget _mainLayout() {
    return Platform.isAndroid
        ? RefreshIndicator(
            displacement: 20, triggerMode: RefreshIndicatorTriggerMode.anywhere, onRefresh: _onRefresh, child: layout())
        : layout();
  }

  Widget layout() {
    return NotificationListener<ScrollEndNotification>(
      onNotification: (ScrollEndNotification scrollEnd) {
        final metrics = scrollEnd.metrics;
        if (metrics.maxScrollExtent <= metrics.pixels &&
            !GetIt.I.get<TransactionsStore>().isMoreLoading &&
            GetIt.I.get<TransactionsStore>().canMoreLoading) {
          GetIt.I.get<TransactionsStore>().getTransactionsMore();
        }
        return true;
      },
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          if (Platform.isIOS)
            CupertinoSliverRefreshControl(
              onRefresh: _onRefresh,
            ),
          CopyAddressWalletWidget(
            format: AccountRepository().isOtherNetwork ? FormatAddress.HEX : FormatAddress.BECH32,
          ),
          SliverToBoxAdapter(
            child: Observer(
              builder: (_) => _BannerBuyingWQT(
                isEnabled: _isShowBanner,
                button: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Future.delayed(const Duration(milliseconds: 100))
                        .then((value) => Provider.of<NotifyPage>(context, listen: false).setIndex(1));
                  },
                  child: Container(
                    height: 43,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      border: Border.all(
                        color: Colors.blue.withOpacity(0.1),
                      ),
                      color: Colors.white,
                    ),
                    child: const Text(
                      'Buy WQT',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColor.enabledButton,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _WalletView(
              minExtend: 0,
              maxExtend: 270,
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
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
              ),
            ),
            centerTitle: false,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            shadowColor: Colors.transparent,
          ),
          ListTransactions(
            key: UniqueKey(),
            scrollController: _scrollController,
          ),
        ],
      ),
    );
  }

  bool get _isShowBanner {
    final _networkName = AccountRepository().networkName.value ?? NetworkName.workNetMainnet;
    if (_networkName == NetworkName.workNetTestnet || _networkName == NetworkName.workNetMainnet) {
      if (GetIt.I.get<WalletStore>().coins.isEmpty) {
        return false;
      }
      try {
        final _wqt = GetIt.I.get<WalletStore>().coins.firstWhere((element) => element.symbol == TokenSymbols.WQT);
        if (double.parse(_wqt.amount!) == 0.0) {
          return true;
        }
      } catch (e) {
        return false;
      }
    }
    return false;
  }

  Future _onRefresh() async {
    GetIt.I.get<TransactionsStore>().getTransactions();
    return GetIt.I.get<WalletStore>().getCoins();
  }
}

class _BannerBuyingWQT extends StatelessWidget {
  final Widget button;
  final bool isEnabled;

  const _BannerBuyingWQT({
    Key? key,
    required this.button,
    required this.isEnabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: isEnabled
          ? Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColor.enabledButton,
                borderRadius: BorderRadius.circular(16.0),
              ),
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'wallet.buyTitleWQT'.tr(),
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'wallet.buyDescriptionWQT'.tr(),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: button,
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}

class _WalletView extends SliverPersistentHeaderDelegate {
  final double minExtend;
  final double maxExtend;
  BuildContext? walletPageContext;

  _WalletView({
    required this.minExtend,
    required this.maxExtend,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          top: minExtent,
          right: 0,
          child: Transform.scale(
            scale: 1 - (shrinkOffset / (500 * 3)),
            child: Opacity(
              opacity: max(
                0,
                1 - (shrinkOffset / (500 / 2)),
              ),
              child: Column(
                children: [
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
          ),
        ),
      ],
    );
  }

  @override
  double get maxExtent => maxExtend;

  @override
  double get minExtent => minExtend;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
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
                            const _ShimmerWidget(
                              width: double.infinity,
                              height: 30,
                            )
                          else
                            Text(
                              '${num.parse(balance.amount!).toStringAsFixed(6)} ${balance.symbol.name}',
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
                            const _ShimmerWidget(
                              width: 140,
                              height: 15,
                            )
                          else
                            Text(
                              _getCourseDollar(balance.symbol.name, balance.amount!),
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
                    onPageChanged: _onPageChanged,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: store.coins.map((balance) {
                    if (_currencyIndex >= store.coins.length) {
                      _currencyIndex = 0;
                    }
                    bool isCurrency = balance == store.coins[_currencyIndex];
                    return GestureDetector(
                      onTap: () => _controller.nextPage(),
                      child: Container(
                        width: 12.0,
                        height: 12.0,
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: isCurrency ? null : Border.all(color: AppColor.enabledButton.withOpacity(0.1)),
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
            return const _ShimmerInfoCard();
          }
          if (store.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'errors.failedToGetBalance'.tr(),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'errors.swipeUpdate'.tr(),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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

  _onPageChanged(int index, dynamic _) {
    switch (index) {
      case 0:
        GetIt.I.get<TransactionsStore>().setType(TokenSymbols.WQT);
        break;
      case 1:
        GetIt.I.get<TransactionsStore>().setType(TokenSymbols.WUSD);
        break;
      case 2:
        GetIt.I.get<TransactionsStore>().setType(TokenSymbols.wBNB);
        break;
      case 3:
        GetIt.I.get<TransactionsStore>().setType(TokenSymbols.wETH);
        break;
      case 4:
        GetIt.I.get<TransactionsStore>().setType(TokenSymbols.USDT);
        break;
    }
    GetIt.I.get<TransactionsStore>().getTransactions();
    setState(() {
      _currencyIndex = index;
    });
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

class _ShimmerInfoCard extends StatelessWidget {
  const _ShimmerInfoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}

class _ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;

  const _ShimmerWidget({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
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
    );
  }
}
