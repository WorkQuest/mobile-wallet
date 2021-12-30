
import 'package:mobx/mobx.dart';
import 'package:workquest_wallet_app/base_store/i_store.dart';
import 'package:workquest_wallet_app/ui/wallet_page/transactions/list_transactions.dart';

part 'transactions_store.g.dart';

class TransactionsStore = TransactionsStoreBase with _$TransactionsStore;

abstract class TransactionsStoreBase extends IStore<bool> with Store {

  @observable
  ObservableList<ItemTransaction> transactions = ObservableList<ItemTransaction>.of([]);

  @action
  getTransactions() async {
    onLoading();
    try {
      await Future.delayed(const Duration(seconds: 2));
      if (transactions.isNotEmpty) {
        transactions.clear();
      }
      // transactions.addAll(_transactions);
      onSuccess(true);
    } catch (e) {
      onError(e.toString());
    }
  }
}

final List<ItemTransaction> _transactions = [
  ItemTransaction(DateTime.now(), 'Recieve', 1500),
  ItemTransaction(DateTime.now(), 'Send', -500),
  ItemTransaction(DateTime.now(), 'Recieve', 1500),
  ItemTransaction(DateTime.now(), 'Send', -500),
  ItemTransaction(DateTime.now(), 'Send', -500),
  ItemTransaction(DateTime.now(), 'Send', -500),
  ItemTransaction(DateTime.now(), 'Recieve', 1500),
  ItemTransaction(DateTime.now(), 'Send', -500),
  ItemTransaction(DateTime.now(), 'Recieve', 1500),
  ItemTransaction(DateTime.now(), 'Send', -500),
  ItemTransaction(DateTime.now(), 'Send', -500),
  ItemTransaction(DateTime.now(), 'Send', -500),
  ItemTransaction(DateTime.now(), 'Recieve', 1500),
  ItemTransaction(DateTime.now(), 'Send', -500),
  ItemTransaction(DateTime.now(), 'Recieve', 1500),
  ItemTransaction(DateTime.now(), 'Send', -500),
  ItemTransaction(DateTime.now(), 'Send', -500),
  ItemTransaction(DateTime.now(), 'Send', -500),
];
