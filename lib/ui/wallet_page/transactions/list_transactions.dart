import 'dart:math';

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

import '../../../constants.dart';

class ListTransactions extends StatelessWidget {
  const ListTransactions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = GetIt.I.get<TransactionsStore>();
    return Observer(
      builder: (_) {
        if (store.isLoading) {
          return const SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          );
        }
        if (store.isSuccess) {
          if (store.transactions.isEmpty) {
            return const SliverFillRemaining(
              child: Center(
                child: Text(
                  'No transactions',
                  // style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            );
          }
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if (store.isMoreLoading &&
                    index == store.transactions.length) {
                  return Column(
                    children: const [
                      SizedBox(height: 10,),
                      CircularProgressIndicator.adaptive(),
                    ],
                  );
                }
                return _infoElement(store.transactions[index]);
              },
              childCount: store.isMoreLoading
                  ? store.transactions.length + 1
                  : store.transactions.length,
            ),
          );
        }
        return const SliverFillRemaining(
          child: Center(
            child: Text("Error"),
          ),
        );
      },
    );
  }

  Widget _infoElement(Tx transaction) {
    bool increase = transaction.fromAddress != AccountRepository().userAddress;
    Color color = increase ? Colors.green : Colors.red;
    final score = BigInt.parse(transaction.value!).toDouble() * pow(10, -18);
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
                    .format(transaction.createdAt!.toLocal())
                    .toString(),
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColor.unselectedBottomIcon,
                ),
              ),
            ],
          ),
          const SizedBox(width: 20,),
          const Spacer(),
          Text(
            '${increase ? '+' : '-'}${score.toStringAsFixed(5)} ${_getTitleCoin(transaction.coin!)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          )
        ],
      ),
    );
  }

  String _getTitleCoin(TYPE_COINS coin) {
    switch (coin) {
      case TYPE_COINS.wqt:
        return "WQT";
      case TYPE_COINS.wusd:
        return "WUSD";
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
