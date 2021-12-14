import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';

final List<_ItemTransaction> _transactions = [
  _ItemTransaction(DateTime.now(), 'Recieve', 1500),
  _ItemTransaction(DateTime.now(), 'Send', -500),
  _ItemTransaction(DateTime.now(), 'Recieve', 1500),
  _ItemTransaction(DateTime.now(), 'Send', -500),
  _ItemTransaction(DateTime.now(), 'Send', -500),
  _ItemTransaction(DateTime.now(), 'Send', -500),
  _ItemTransaction(DateTime.now(), 'Recieve', 1500),
  _ItemTransaction(DateTime.now(), 'Send', -500),
  _ItemTransaction(DateTime.now(), 'Recieve', 1500),
  _ItemTransaction(DateTime.now(), 'Send', -500),
  _ItemTransaction(DateTime.now(), 'Send', -500),
  _ItemTransaction(DateTime.now(), 'Send', -500),
  _ItemTransaction(DateTime.now(), 'Recieve', 1500),
  _ItemTransaction(DateTime.now(), 'Send', -500),
  _ItemTransaction(DateTime.now(), 'Recieve', 1500),
  _ItemTransaction(DateTime.now(), 'Send', -500),
  _ItemTransaction(DateTime.now(), 'Send', -500),
  _ItemTransaction(DateTime.now(), 'Send', -500),
];

class ListTransactions extends StatelessWidget {
  const ListTransactions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          var transaction = _transactions[index];
          bool increase = transaction.count > 0;
          Color color = increase ? Colors.green : Colors.red;

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
        childCount: _transactions.length,
      ),
    );
  }
}

class _ItemTransaction {
  final DateTime date;
  final String title;
  final int count;

  const _ItemTransaction(
    this.date,
    this.title,
    this.count,
  );
}
