import 'package:mobx/mobx.dart';
import 'package:workquest_wallet_app/base_store/i_store.dart';
import 'package:workquest_wallet_app/repository/account_repository.dart';

part 'wallet_store.g.dart';

class WalletStore = WalletStoreBase with _$WalletStore;

abstract class WalletStoreBase extends IStore<bool> with Store {
  @observable
  ObservableList<BalanceItem> coins = ObservableList.of([]);

  @action
  getCoins() async {
    onLoading();
    try {
      print('getCoins');
      if (coins.isNotEmpty) {
        coins.clear();
      }
      final list = await AccountRepository()
          .client!
          .getAllBalance(AccountRepository().privateKey);
      final ether = list. firstWhere((element) => element.title == 'ether');
      coins.add(BalanceItem(
        "WUSD",
        ether.amount,
      ));
      coins.add(BalanceItem(
        "WQT",
        (double.parse(ether.amount) * 0.038).toString(),
      ));
      onSuccess(true);
    } catch (e) {
      onError(e.toString());
    }
  }
}
