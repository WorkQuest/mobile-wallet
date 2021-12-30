import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
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
                  'Not transactions',
                  // style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            );
          }
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                var transaction = store.transactions[index];
                bool increase = transaction.count > 0;
                Color color = increase ? Colors.green : Colors.red;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5.0, vertical: 7.5),
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
                            transaction.title,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            DateFormat('dd.MM.yy H:m')
                                .format(transaction.date)
                                .toString(),
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColor.unselectedBottomIcon,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        '${increase ? '+' : ''}${transaction.count} WUSD',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: increase ? Colors.green : Colors.red,
                        ),
                      )
                    ],
                  ),
                );
              },
              childCount: store.transactions.length,
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
