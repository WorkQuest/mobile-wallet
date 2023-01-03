import 'package:get_it/get_it.dart';
import 'package:workquest_wallet_app/http/api.dart';
import 'package:workquest_wallet_app/repository/session_repository.dart';
import 'package:workquest_wallet_app/ui/wallet_page/transactions/entity/tx_list_entity.dart';

abstract class ITransactionsRepository {
  Future<List<TxListEntity>> getNativeTransactionsWorkNet({
    required String userAddress,
    int limit = 10,
    int offset = 0,
  });

  Future<List<TxListEntity>> getTokenTransactionsWorkNet({
    required String userAddress,
    required String tokenAddress,
    int limit = 10,
    int offset = 0,
  });

  Future<List<TxListEntity>> getTransactionsOtherNetwork({
    int page = 0,
    int offset = 0,
  });
}

class TransactionsRepository implements ITransactionsRepository {
  @override
  Future<List<TxListEntity>> getNativeTransactionsWorkNet({
    required String userAddress,
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final _list = await Api().getTransactions(
        userAddress,
        limit: limit,
        offset: offset,
      );
      final result = _list!.map((tx) => TxListEntity.fromWorkNet(tx)).toList();
      return result;
    } catch (e) {
      print('TransactionsRepository getNativeTransactionsWorkNet | error: $e');
      throw TransactionsException(e.toString());
    }
  }

  @override
  Future<List<TxListEntity>> getTokenTransactionsWorkNet({
    required String userAddress,
    required String tokenAddress,
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final _list = await Api().getTransactionsByToken(
        address: userAddress,
        addressToken: tokenAddress,
        limit: limit,
        offset: offset,
      );

      final result = _list!.map((tx) => TxListEntity.fromWorkNet(tx)).toList();
      return result;
    } catch (e, trace) {
      print('TransactionsRepository getTokenTransactionsWorkNet | error: $e,\n trace: $trace');
      throw TransactionsException(e.toString());
    }
  }

  @override
  Future<List<TxListEntity>> getTransactionsOtherNetwork({int page = 0, int offset = 0}) async {
    try {
      final _list = await Api().getTransactionsOtherNetwork(
        network: GetIt.I.get<SessionRepository>().networkName.value!,
        userAddress: GetIt.I.get<SessionRepository>().userAddress,
        page: page,
        offset: offset,
      );

      final result = _list!.map((tx) => TxListEntity.fromOtherNetwork(tx)).toList();
      return result;
    } catch (e, trace) {
      print('TransactionsRepository getTransactionsOtherNetwork | error: $e,\n trace: $trace');
      throw TransactionsException(e.toString());
    }
  }
}

class TransactionsException implements Exception {
  final String message;

  TransactionsException([this.message = 'Unknown transactions error']);

  @override
  String toString() => message;
}
