import 'dart:math';

import 'package:auto_animated/auto_animated.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:workquest_wallet_app/model/transactions_response.dart';
import 'package:workquest_wallet_app/repository/account_repository.dart';
import 'package:workquest_wallet_app/ui/transfer_page/confirm_page/mobx/confirm_transfer_store.dart';
import 'package:workquest_wallet_app/ui/wallet_page/transactions/mobx/transactions_store.dart';
import 'package:workquest_wallet_app/widgets/shimmer.dart';

import '../../../constants.dart';

class ListTransactions extends StatelessWidget {
  final ScrollController scrollController;

  const ListTransactions({
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = GetIt.I.get<TransactionsStore>();
    return Observer(
      builder: (_) {
        if (store.isLoading) {
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return _shimmer();
              },
              childCount: 8,
            ),
          );
        }
        if (store.isSuccess) {
          if (store.transactions.isEmpty) {
            return SliverFillRemaining(
              child: Center(
                child: Text(
                  'wallet.noTransactions'.tr(),
                ),
              ),
            );
          }
          return LiveSliverList.options(
            options: const LiveOptions(
              delay: Duration.zero,
              reAnimateOnVisibility: false,
              showItemDuration: Duration(milliseconds: 375),
              showItemInterval: Duration(milliseconds: 50),
            ),
            controller: scrollController,
            itemBuilder:
                (BuildContext context, int index, Animation<double> animation) {
                  if (store.isMoreLoading && index == store.transactions.length) {
                    return Column(
                      children: const [
                        SizedBox(
                          height: 10,
                        ),
                        CircularProgressIndicator.adaptive(),
                      ],
                    );
                  }
                  if (store.type == TYPE_COINS.wusd &&
                      store.transactions[index].value == "0") {
                    return Container();
                  }
                  if (!store.transactions[index].show) {
                    store.transactions[index].show = true;
                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.2),
                          end: Offset.zero,
                        ).animate(animation),
                        child: _infoElement(store.transactions[index]),
                      ),
                    );
                  }
                  return _infoElement(store.transactions[index]);
                },
            itemCount: store.isMoreLoading
                ? store.transactions.length + 1
                : store.transactions.length,
          );
          // return SliverList(
          //   delegate: SliverChildBuilderDelegate(
          //     (BuildContext context, int index) {
          //       if (store.isMoreLoading && index == store.transactions.length) {
          //         return Column(
          //           children: const [
          //             SizedBox(
          //               height: 10,
          //             ),
          //             CircularProgressIndicator.adaptive(),
          //           ],
          //         );
          //       }
          //       if (store.type == TYPE_COINS.wusd &&
          //           store.transactions[index].value == "0") {
          //         return Container();
          //       }
          //       if (!store.transactions[index].show) {
          //         store.transactions[index].show = true;
          //         return AnimationConfiguration.staggeredList(
          //           position: index,
          //           duration: const Duration(milliseconds: 375),
          //           child: SlideAnimation(
          //             verticalOffset: 30.0,
          //             child: FadeInAnimation(
          //               child: _infoElement(store.transactions[index]),
          //             ),
          //           ),
          //         );
          //       }
          //       return _infoElement(store.transactions[index]);
          //     },
          //     childCount: store.isMoreLoading
          //         ? store.transactions.length + 1
          //         : store.transactions.length,
          //   ),
          // );
        }
        return SliverFillRemaining(
          child: Center(
            child: Text(store.errorMessage!),
          ),
        );
      },
    );
  }

  Widget _infoElement(
    Tx transaction,
  ) {
    bool increase = transaction.fromAddressHash!.hex! != AccountRepository().userAddress;
    Color color = increase ? Colors.green : Colors.red;
    double score;
    if (transaction.tokenTransfers != null && transaction.tokenTransfers!.isEmpty) {
      score = BigInt.parse(transaction.value!).toDouble() * pow(10, -18);
    } else {
      if (transaction.amount != null) {
        score = BigInt.parse(transaction.amount!).toDouble() * pow(10, -18);
      } else {
        score = BigInt.parse(transaction.tokenTransfers!.first.amount!).toDouble() *
            pow(10, -18);
      }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 7.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 34,
            width: 34,
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.1),
            ),
            child: Transform.rotate(
              angle: increase ? 0 : pi / 1,
              child: SvgPicture.asset(
                Images.transactionStatusIcon,
                color: color,
              ),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                increase ? 'wallet.receive'.tr() : 'wallet.send'.tr(),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                DateFormat('dd.MM.yy HH:mm')
                    .format(transaction.amount != null
                        ? transaction.insertedAt!.toLocal()
                        : transaction.block!.timestamp!.toLocal())
                    .toString(),
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColor.unselectedBottomIcon,
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 20,
          ),
          const Spacer(),
          Flexible(
            child: Text(
              '${increase ? '+' : '-'}${score.toStringAsFixed(5)} ${_getTitleCoin()}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: color,
              ),
              overflow: TextOverflow.clip,
              textAlign: TextAlign.end,
            ),
          )
        ],
      ),
    );
  }

  Widget _shimmer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 7.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Shimmer.stand(
            child: Container(
              height: 34,
              width: 34,
              padding: const EdgeInsets.all(10.0),
              decoration:
                  const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.stand(
                child: Container(
                  height: 20,
                  width: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0), color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Shimmer.stand(
                child: Container(
                  height: 14,
                  width: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0), color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 20,
          ),
          const Spacer(),
          Flexible(
            child: Shimmer.stand(
              child: Container(
                height: 20,
                width: 100,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0), color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  String _getTitleCoin() {
    switch (GetIt.I.get<TransactionsStore>().type) {
      case TYPE_COINS.wqt:
        return "WQT";
      case TYPE_COINS.wusd:
        return "WUSD";
      case TYPE_COINS.wBnb:
        return "wBNB";
      case TYPE_COINS.wEth:
        return "wETH";
      default:
        return "WUSD";
    }
  }
}

class ItemTransaction {
  final DateTime date;
  final String title;
  final int count;

  const ItemTransaction(
    this.date,
    this.title,
    this.count,
  );
}
