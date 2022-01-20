import 'package:mobx/mobx.dart';
import 'package:workquest_wallet_app/base_store/i_store.dart';
import 'package:workquest_wallet_app/http/api.dart';
import 'package:workquest_wallet_app/model/transactions_response.dart';
import 'package:workquest_wallet_app/repository/account_repository.dart';
import 'package:workquest_wallet_app/ui/transfer_page/confirm_page/mobx/confirm_transfer_store.dart';

part 'transactions_store.g.dart';

class TransactionsStore = TransactionsStoreBase with _$TransactionsStore;

abstract class TransactionsStoreBase extends IStore<bool> with Store {
  @observable
  ObservableList<Tx> transactions = ObservableList<Tx>.of([]);

  @observable
  bool isMoreLoading = false;

  @action
  getTransactions({bool isForce = false}) async {
    if (isForce) {
      onLoading();
    } else {
      isMoreLoading = true;
    }
    try {
      if (isForce) {
        if (transactions.isNotEmpty) {
          transactions.clear();
        }
        isMoreLoading = false;
      }
      final result = await Api().getTransactions(
        AccountRepository().userAddress!,
        limit: 10,
        offset: transactions.length,
      );
      // await Future.delayed(const Duration(seconds: 2));
      // final result = List.generate(5, (index) {
      //   return Tx(value: '${index % 2}100000000000000', createdAt: DateTime.now());
      // });

      result.map((tran) {
        if (tran.contractAddress != null) {
          tran.coin = TYPE_COINS.wqt;
          final res = BigInt.parse(tran.logs!.first.data.toString().substring(2), radix: 16);
          tran.value = res.toString();
        } else {
          tran.coin = TYPE_COINS.wusd;
        }
      }).toList();

      transactions.addAll(result);
      await Future.delayed(const Duration( milliseconds: 500));
      isMoreLoading = false;
      onSuccess(true);
    } catch (e, trace) {
      print('$e\n$trace');
      onError(e.toString());
    }
  }
}
