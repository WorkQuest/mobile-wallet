import 'package:workquest_wallet_app/constants.dart';
import 'package:workquest_wallet_app/model/transactions_response.dart';
import 'package:workquest_wallet_app/model/tx_other_network_response.dart';

class TxListEntity {
  final String? hashTx;
  final String? fromAddress;
  final String? toAddress;
  final TokenSymbols? symbol;
  final String? amount;
  final DateTime? insertedAt;

  TxListEntity({
    required this.hashTx,
    required this.fromAddress,
    required this.toAddress,
    required this.symbol,
    required this.amount,
    required this.insertedAt,
  });

  factory TxListEntity.fromWorkNet(Tx transaction) => TxListEntity(
        hashTx: transaction.hash,
        fromAddress: transaction.fromAddressHash?.hex,
        toAddress: transaction.toAddressHash?.hex,
        symbol: transaction.getSymbol(),
        amount: transaction.getAmount(),
        insertedAt: transaction.getInsertedAt(),
      );

  factory TxListEntity.fromOtherNetwork(TxOther transaction) => TxListEntity(
        hashTx: transaction.hash,
        fromAddress: transaction.from,
        toAddress: transaction.to,
        symbol: transaction.getSymbol(),
        amount: transaction.value,
        insertedAt: transaction.getInsertedAt(),
      );
}
